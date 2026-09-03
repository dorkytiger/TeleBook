import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/core/util/app_log.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/sync/datasource/sync_down_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_state_local_datasource.dart';
import 'package:tele_book/feature/sync/service/file_sync_service.dart';
import 'package:tele_book/feature/sync/service/sync_op_service.dart';

/// 单个文件的下载状态（阅读页三态：等待中/下载中/完成）。
class FileDownloadState {
  final String relPath;
  final String status; // pending / syncing / done
  final double progress; // 0.0-1.0

  const FileDownloadState({
    required this.relPath,
    required this.status,
    this.progress = 0,
  });
}

/// 乐观下载服务（§2.1.2 下载分支）：先建书（乐观显示）→ 逐文件下载 → 每文件状态推进。
///
/// 阅读页通过 [fileStates] watch 每页文件状态：等待中(占位) → 下载中(进度条) → 完成(图)。
class OptimisticDownloadService {
  final BookRepository _books;
  final SyncDownLocalDatasource _syncDown;
  final FileSyncService _fileSync;
  final SyncOpService _ops;
  final SyncStateLocalDatasource _syncState;

  /// 每文件下载状态（key = `uuid/relPath`），阅读页 watch 渲染三态。
  final ValueNotifier<Map<String, FileDownloadState>> fileStates =
      ValueNotifier(const {});

  /// 是否有下载在进行（全局通知用）。
  final ValueNotifier<bool> downloading = ValueNotifier(false);

  /// 当前书进度（组任务进度上报用）。
  int _currentBook = 0;

  OptimisticDownloadService(
    this._books,
    this._syncDown,
    this._fileSync,
    this._ops,
    this._syncState,
  );

  /// 下载一本书的清单：先建 book + 落 sync_down，再逐个文件下载。
  /// [opType]：组任务类型（init=初始化 / refresh=刷新同步，§2.2）。
  /// [afterBatch]：整批下载完成后（仍在同组任务内）执行，如顺带消费事件流。
  Future<void> downloadLibrary(
    List<RemoteLibraryBook> books, {
    String opType = SyncOpType.init,
    Future<void> Function(SyncOpProgressCallback progress, SyncOpDetailWriter detail)?
        afterBatch,
  }) async {
    if (books.isEmpty) {
      // 空批次也执行 afterBatch（本地空+远程有但快照瞬时空等边界情况）
      if (afterBatch == null) return;
      await _ops.enqueue(
        type: opType,
        executor: (progress, detail) => afterBatch(progress, detail),
      );
      return;
    }
    await _ops.enqueue(
      type: opType,
      executor: (progress, detail) async {
        downloading.value = true;
        _currentBook = 0;
        // 预注册整批书（等待中），让明细/页面先看到"待下载"清单（§0）
        for (final book in books) {
          detail.book(
            book.uuid,
            book.name,
            [for (final f in book.files) f.relPath],
            direction: 'download',
          );
        }
        var failedBooks = 0;
        for (final book in books) {
          final ok = await downloadBook(book, progress, detail);
          if (!ok) failedBooks++;
        }
        downloading.value = false;
        if (failedBooks > 0) {
          // §0：整批有书未下齐 → 组任务标 failed（失败页可展开重试/整批重试）
          throw StateError('$failedBooks 本书有页下载失败，可重试');
        }
        if (afterBatch != null) {
          await afterBatch(progress, detail);
        }
      },
    );
  }

  /// 下载单本书（双向匹配分支用，已在组任务内，不重复 enqueue）。
  /// [detail] 非空时向组任务明细上报组内书/每页状态（§0 明细面板）。
  /// 返回是否全部页都下载成功（失败页会留在 sync_down/明细，可页级或整批重试）。
  Future<bool> downloadBook(
    RemoteLibraryBook book,
    SyncOpProgressCallback progress, [
    SyncOpDetailWriter? detail,
  ]) async {
    _currentBook++;
    // ① 乐观建书（文件可未下载）
    await _createBookOptimistic(book);
    // ② 落 sync_down（文件元数据，pending）
    await _seedSyncDown(book);
    detail?.book(
      book.uuid,
      book.name,
      [for (final f in book.files) f.relPath],
      direction: 'download',
    );
    detail?.bookSyncing(book.uuid);
    // ③ 逐文件下载（fileStates 累积到全局 map，key=uuid/relPath）
    progress(SyncOpProgress(
      currentBook: _currentBook,
      totalPages: book.files.length,
    ));
    await _downloadBookFiles(book, progress, detail);
    await _syncDown.updateBook(book.uuid, status: 'done');
    // ④ 全部页下载完成 → 回填服务器 revision（§2.1.5 乐观锁基准）：
    //    只要还有 pending/失败页就跳过（保持本地基准为旧值，避免误判已同步）
    final allDone = await _allFilesDone(book.uuid);
    if (allDone && book.revision > 0) {
      await _syncState.upsertRevision('book', book.uuid, book.revision);
    }
    return allDone;
  }

  /// 该书是否在下载断点表（sync_down）→ 页级重试按钮可用（上传类任务的书不可）。
  Future<bool> hasSyncDown(String uuid) async {
    return (await _syncDown.filesOf(uuid)).isNotEmpty;
  }

  /// 重试下载单页（§0 页级错误重试 / §8.1 续传共用）：读 sync_down 拿 hash
  /// 重新下载该页，同步更新文件三态、sync_down 与组任务明细。返回是否成功。
  /// 书不在 sync_down（如上传类任务）或未找到该页 → false。
  Future<bool> retryFile(
    String uuid,
    String relPath, {
    SyncOpDetailWriter? detail,
  }) async {
    final rows = await _syncDown.filesOf(uuid);
    final row = rows.where((r) => r.relPath == relPath).firstOrNull;
    if (row == null || row.hash.isEmpty) return false;
    return _downloadOneFile(uuid, row, detail);
  }

  /// 未完成下载的书（§8.0/§8.1 启动恢复）：sync_down 中仍缺页的书。
  /// 书行已被本地删除的残留记录会顺手清理（避免僵尸续传）。
  Future<List<String>> unfinishedDownloads() async {
    final rows = await _syncDown.listAll();
    final result = <String>[];
    for (final row in rows) {
      final files = await _syncDown.filesOf(row.uuid);
      final book = await _books.getBookByUuid(row.uuid);
      if (book == null) {
        // 本地书已删除 → 断点残留，清掉
        await _syncDown.deleteBook(row.uuid);
        continue;
      }
      final missing = files.where((f) => f.status != 'done').length;
      if (files.isEmpty || missing > 0 || row.status != 'done') {
        result.add(row.uuid);
      }
    }
    return result;
  }

  /// 续传一本书（§8.1 ②③）：只补下载缺失页，已 done 页跳过；返回失败页数。
  /// 组任务明细 [detail] 注册书 + 逐页状态（§0 面板可见恢复进度）。
  Future<int> resumeBook(
    String uuid,
    SyncOpProgressCallback progress, [
    SyncOpDetailWriter? detail,
  ]) async {
    final row = (await _syncDown.listAll())
        .where((r) => r.uuid == uuid)
        .firstOrNull;
    if (row == null) return 0;
    final files = await _syncDown.filesOf(uuid);
    if (files.isEmpty) {
      // 只剩书行没有文件记录（拉元数据中断）→ 交给"重新同步"全量重建
      return 0;
    }
    final book = await _books.getBookByUuid(uuid);
    if (book == null) {
      await _syncDown.deleteBook(uuid);
      return 0;
    }
    detail?.book(
      uuid,
      book.name,
      [for (final f in files) f.relPath],
      direction: 'download',
    );
    detail?.bookSyncing(uuid);
    progress(SyncOpProgress(currentBook: 1, totalPages: files.length));
    var failed = 0;
    var pageNo = 0;
    for (final f in files) {
      pageNo++;
      if (f.status == 'done') {
        detail?.fileDone(uuid, f.relPath);
        continue;
      }
      final ok = await _downloadOneFile(uuid, f, detail);
      if (!ok) failed++;
      progress(SyncOpProgress(
        currentBook: 1,
        currentPage: pageNo,
        totalPages: files.length,
      ));
    }
    detail?.finishBook(uuid, ok: failed == 0);
    await _syncDown.updateBook(
      uuid,
      status: 'done',
      bookStatus: failed == 0 ? '已同步' : '部分失败',
      doneFiles: files.length - failed,
    );
    return failed;
  }

  /// 单个文件下载（retryFile / resumeBook 共用）：失败状态回 pending 可再续。
  Future<bool> _downloadOneFile(
    String uuid,
    SyncDownFileTableData row,
    SyncOpDetailWriter? detail,
  ) async {
    final key = '$uuid/${row.relPath}';
    final dest = GlobalConfig.resolveBookPath(key);
    // 清理半截文件
    final existing = File(dest);
    if (await existing.exists()) {
      try {
        await existing.delete();
      } catch (_) {}
    }
    _setState(key, 'syncing', 0);
    await _syncDown.markFile(uuid, row.relPath, 'syncing');
    detail?.fileSyncing(uuid, row.relPath);
    try {
      await _fileSync.downloadFile(
        hash: row.hash,
        destPath: dest,
        onProgress: (p) {
          _setState(key, 'syncing', p);
          detail?.fileSyncing(uuid, row.relPath, progress: p);
        },
      );
      _setState(key, 'done', 1);
      await _syncDown.markFile(uuid, row.relPath, 'done');
      detail?.fileDone(uuid, row.relPath);
      return true;
    } catch (e) {
      _setState(key, 'pending', 0);
      await _syncDown.markFile(uuid, row.relPath, 'pending');
      detail?.fileFailed(uuid, row.relPath, error: '$e');
      return false;
    }
  }

  /// ① 乐观建书：本地无此书则建，subPaths 用文件清单生成（文件可不在）。
  Future<void> _createBookOptimistic(RemoteLibraryBook book) async {
    if (await _books.getBookByUuid(book.uuid) != null) return; // 已存在
    final (localSubPaths, coverSubPath) = deriveSubPaths(book);
    await _books.upsertSyncedBook(
      uuid: book.uuid,
      name: book.name,
      currentPage: book.currentPage,
    );
    await _books.updateSyncedBookFiles(
      uuid: book.uuid,
      localSubPaths: localSubPaths,
      coverSubPath: coverSubPath,
    );
  }

  /// ② 落 sync_down：书 + 每文件（pending）。
  Future<void> _seedSyncDown(RemoteLibraryBook book) async {
    await _syncDown.insertBook(
      SyncDownTableCompanion.insert(
        uuid: book.uuid,
        name: book.name,
        totalFiles: Value(book.files.length),
        coverHash: Value(book.coverHash),
        status: const Value('downloading'),
        bookStatus: const Value('下载中'),
      ),
      [
        for (final f in book.files)
          SyncDownFileTableCompanion.insert(
            uuid: book.uuid,
            relPath: f.relPath,
            hash: f.hash,
            size: Value(f.size.toInt()),
          ),
      ],
    );
  }

  /// ③ 逐文件下载，更新每文件状态（三态）与 sync_down，并向组任务明细上报。
  Future<void> _downloadBookFiles(
    RemoteLibraryBook book,
    SyncOpProgressCallback progress, [
    SyncOpDetailWriter? detail,
  ]) async {
    var done = 0;
    var hadFailure = false;
    for (final f in book.files) {
      if (f.relPath.isEmpty || f.hash.isEmpty) {
        done++;
        continue;
      }
      final dest = GlobalConfig.resolveBookPath('${book.uuid}/${f.relPath}');
      final key = '${book.uuid}/${f.relPath}';

      // 已存在且大小一致 → 直接 done
      final existing = File(dest);
      if (await existing.exists() && existing.lengthSync() == f.size) {
        _setState(key, 'done', 1);
        await _syncDown.markFile(book.uuid, f.relPath, 'done');
        detail?.fileDone(book.uuid, f.relPath);
        done++;
        progress(SyncOpProgress(
          currentBook: _currentBook,
          currentPage: done,
        ));
        continue;
      }

      // 标记下载中
      _setState(key, 'syncing', 0);
      await _syncDown.markFile(book.uuid, f.relPath, 'syncing');
      detail?.fileSyncing(book.uuid, f.relPath);
      try {
        await _fileSync.downloadFile(
          hash: f.hash,
          destPath: dest,
          onProgress: (p) {
            _setState(key, 'syncing', p);
            detail?.fileSyncing(book.uuid, f.relPath, progress: p);
          },
        );
        _setState(key, 'done', 1);
        await _syncDown.markFile(book.uuid, f.relPath, 'done');
        detail?.fileDone(book.uuid, f.relPath);
      } catch (e) {
        // 失败：状态回 pending，页面显示"等待中"，明细标 failed 供页级重试
        hadFailure = true;
        _setState(key, 'pending', 0);
        await _syncDown.markFile(book.uuid, f.relPath, 'pending');
        detail?.fileFailed(book.uuid, f.relPath, error: '$e');
        AppLog.e('乐观下载失败 ${book.uuid}/${f.relPath}: $e', tag: 'OPT_DL');
        // 清理半截文件
        if (await existing.exists()) {
          try {
            await existing.delete();
          } catch (_) {}
        }
      }
      done++;
      progress(SyncOpProgress(
        currentBook: _currentBook,
        currentPage: done,
      ));
    }
    detail?.finishBook(book.uuid, ok: !hadFailure);
    await _syncDown.updateBook(
      book.uuid,
      status: 'done',
      bookStatus: '已同步',
      doneFiles: done,
    );
  }

  /// 更新单个文件状态并通知阅读页（累积到全局 fileStates，不覆盖其它书）。
  void _setState(String key, String status, double p) {
    final relPath = key.split('/').sublist(1).join('/');
    final updated = Map<String, FileDownloadState>.of(fileStates.value);
    updated[key] = FileDownloadState(
      relPath: relPath,
      status: status,
      progress: p,
    );
    fileStates.value = updated;
  }

  /// 该书全部文件是否都已 done（决定能否回填 revision）。
  Future<bool> _allFilesDone(String uuid) async {
    final rows = await _syncDown.filesOf(uuid);
    if (rows.isEmpty) return false;
    return rows.every((r) => r.status == 'done');
  }
}

final optimisticDownloadServiceProvider = Provider<OptimisticDownloadService>((ref) {
  return OptimisticDownloadService(
    ref.watch(bookRepositoryProvider),
    ref.watch(syncDownLocalDatasourceProvider),
    ref.watch(fileSyncServiceProvider),
    ref.watch(syncOpServiceProvider),
    ref.watch(syncStateLocalDatasourceProvider),
  );
});

/// 纯函数：由远程书文件清单推导 book 的 subPaths（可单测）。
/// cover.jpg → (无 localSub, coverSubPath)；original/* → localSubPaths。
(List<String>, String?) deriveSubPaths(RemoteLibraryBook book) {
  final localSubPaths = <String>[];
  String? coverSubPath;
  for (final f in book.files) {
    final sub = '${book.uuid}/${f.relPath}';
    if (f.relPath == 'cover.jpg') {
      coverSubPath = sub;
    } else if (f.relPath.startsWith('original/')) {
      localSubPaths.add(sub);
    }
  }
  return (localSubPaths, coverSubPath);
}
