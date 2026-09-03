import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/core/util/app_log.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/sync/datasource/sync_state_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_upload_local_datasource.dart';
import 'package:tele_book/feature/sync/service/file_sync_service.dart';
import 'package:tele_book/feature/sync/service/local_conflict_service.dart';
import 'package:tele_book/feature/sync/service/match_plan.dart';
import 'package:tele_book/feature/sync/service/optimistic_download_service.dart';
import 'package:tele_book/feature/sync/service/sync_op_service.dart';

/// 初始化同步分支（§2.1.1-2.1.4）。
enum InitSyncBranch {
  bothEmpty, // 本地空 + 远程空 → 直接跳过
  downloadOnly, // 本地空 + 远程有 → 下载（§2.1.2）
  uploadOnly, // 本地有 + 远程空 → 上传（§2.1.3）
  bidirectional, // 本地有 + 远程有 → 双向匹配（§2.1.4）
}

/// 同步编排：检测分支 → 入队一组任务 → 执行对应流程。
///
/// 「初始化同步」与「刷新同步」（§2.2 = 初始化的手动调用）共用本流程，
/// 仅组任务类型不同（init / refresh，显示在全局通知与本地同步记录）。
/// 进度经 SyncOpService 的 progress 上报到全局通知 / 明细面板 / 本地同步记录。
class InitSyncService {
  final BookRepository _books;
  final SyncOpService _ops;
  final SyncService _sync;
  final OptimisticDownloadService _downloader;
  final FileSyncService _fileSync;
  final SyncUploadLocalDatasource _syncUpload;
  final SyncStateLocalDatasource _syncState;
  final LocalConflictService _localConflicts;

  InitSyncService(
    this._books,
    this._ops,
    this._sync,
    this._downloader,
    this._fileSync,
    this._syncUpload,
    this._syncState,
    this._localConflicts,
  );

  /// 检测当前属于哪个分支（本地书数 vs 服务端书数）。
  Future<InitSyncBranch> detect() async {
    final localCount = (await _books.getAllBooks()).length;
    final remote = await _sync.libraryStatus();
    return detectBranch(localCount, remote.bookCount);
  }

  /// 执行同步（初始化或刷新）：入队一组任务（组 = 一次操作）。
  /// [opType]：SyncOpType.init（初始化同步）或 SyncOpType.refresh（刷新同步）。
  Future<void> run({String opType = SyncOpType.init}) async {
    final branch = await detect();
    switch (branch) {
      case InitSyncBranch.bothEmpty:
        // §2.1.1：直接跳过，无任务
        break;
      case InitSyncBranch.downloadOnly:
        await _enqueueDownload(opType);
        break;
      case InitSyncBranch.uploadOnly:
        await _enqueueUpload(opType);
        break;
      case InitSyncBranch.bidirectional:
        await _enqueueBidirectional(opType);
        break;
    }
  }

  /// §2.1.2：本地空 + 远程有 → 下载组任务（乐观显示，OptimisticDownloadService 内部入队）。
  Future<void> _enqueueDownload(String opType) async {
    final books = await _sync.libraryBooks();
    await _downloader.downloadLibrary(
      books,
      opType: opType,
      // 全量下载后顺带消费一次事件流：拉齐 revision/游标 + 其它设备进度（§4）
      afterBatch: (progress, detail) => _pullQuiet(),
    );
  }

  /// 同步主体完成后顺带拉一次事件流（跨设备收敛：progress 进度 / 删除墓碑 /
  /// revision）。失败只记日志（网络问题由任务自身的错误路径体现），不拖垮组任务。
  Future<void> _pullQuiet() async {
    try {
      await _sync.pullOnly();
    } catch (e) {
      AppLog.w('同步后拉取事件失败（下次刷新会重试）: $e', tag: 'SYNC');
    }
  }

  /// §2.1.3：本地有 + 远程空 → 上传组任务。
  ///
  /// **残留优先（§8.2 断点续传）**：sync_upload 里仍有上次中断的书时，
  /// 只续传这些书（服务端 init/complete 幂等，已完成文件自动跳过）；
  /// 残留 uuid 已无本地书（被删）→ 清理记录。无残留 → 全量上传。
  Future<void> _enqueueUpload(String opType) async {
    await _ops.enqueue(
      type: opType,
      executor: (progress, detail) async {
        final allLocal = await _books.getAllBooks();
        final localByUuid = {for (final b in allLocal) b.uuid: b};

        // 残留（上次中断）：sync_upload 中有记录的书
        final residual = await _syncUpload.listAll();
        final targets = <BookTableData>[];
        for (final r in residual) {
          final book = localByUuid[r.uuid];
          if (book == null) {
            await _syncUpload.deleteBook(r.uuid); // 本地已删 → 清残留
            continue;
          }
          targets.add(book); // 续传优先，已 done 的重复上传由服务端幂等跳过
        }
        if (targets.isEmpty) {
          targets.addAll(allLocal); // 全新上传
        }

        // 预注册整批书（等待中），让页面先看到"待上传"清单（§0）
        for (final book in targets) {
          final files = await _fileSync.buildBookFiles(book);
          detail.book(
            book.uuid,
            book.name,
            [for (final f in files) f.relPath],
            direction: 'upload',
          );
        }

        var i = 0;
        var failed = 0;
        for (final book in targets) {
          i++;
          final ok = await _uploadOneBook(
            book,
            progress: progress,
            detail: detail,
            currentBook: i,
            totalBooks: targets.length,
          );
          if (!ok) failed++;
        }
        await _pullQuiet();
        if (failed > 0) {
          // §0：有书未上传成功 → 组任务标 failed（本地记录可见 + 可重试，
          // 重试只处理 sync_upload 残留的书）
          throw StateError('$failed 本上传失败，可重试');
        }
      },
    );
  }

  /// 单本上传任务单元（§P1 单本抽象，uploadOnly/resume 共用）：
  /// 落 sync_upload → init 拿 uuid → 逐文件上传（组任务明细逐页，§0）→
  /// 全部成功 complete（服务端落库 + 返回 revision）→ 回填 sync_state
  /// （乐观锁基准）→ 清理 sync_upload；失败保留 sync_upload 行供续传。
  /// 返回是否成功。
  Future<bool> _uploadOneBook(
    BookTableData book, {
    required SyncOpProgressCallback progress,
    required SyncOpDetailWriter detail,
    required int currentBook,
    required int totalBooks,
  }) async {
    final files = await _fileSync.buildBookFiles(book);
    await _syncUpload.insertBook(SyncUploadTableCompanion.insert(
      uuid: book.uuid,
      name: book.name,
      totalFiles: Value(files.length),
    ));
    await _syncUpload.updateBook(book.uuid,
        status: 'uploading', bookStatus: '上传中');
    progress(SyncOpProgress(
      currentBook: currentBook,
      totalBooks: totalBooks,
      totalPages: files.length,
    ));

    final (_, okCount, failCount, revision) =
        await _fileSync.uploadBookToServerWithDetail(
      detail: detail,
      rowProgress: progress,
      currentBook: currentBook,
      totalBooks: totalBooks,
      uuid: book.uuid,
      name: book.name,
      files: files,
    );
    if (failCount > 0) {
      // 保留 sync_upload 行（failed）：下次上传/恢复只续传该书
      await _syncUpload.updateBook(book.uuid,
          status: 'failed', bookStatus: '失败', doneFiles: okCount);
      return false;
    }
    await _syncUpload.updateBook(book.uuid,
        status: 'done', bookStatus: '已同步', doneFiles: okCount);
    await _syncUpload.deleteBook(book.uuid);
    // 回填服务器 revision（§2.1.5 乐观锁基准）
    if (revision > 0) {
      await _syncState.upsertRevision('book', book.uuid, revision);
    }
    progress(SyncOpProgress(
      currentBook: currentBook,
      totalBooks: totalBooks,
      currentPage: files.length,
      totalPages: files.length,
    ));
    return true;
  }

  /// §2.1.4：本地有 + 远程有 → 双向匹配组任务。
  ///
  /// 拉远程清单 → buildMatchPlan（uuid 主键）→ 按动作执行：
  /// 远程有本地无 → 下载；本地有远程无 → 上传；同 uuid hash 不同 → 冲突
  /// （收集到 LocalConflictService，UI 逐个选择保留哪版，§7）。
  Future<void> _enqueueBidirectional(String opType) async {
    await _ops.enqueue(
      type: opType,
      executor: (progress, detail) async {
        final localBooks = await _books.getAllBooks();
        final remoteBooks = await _sync.libraryBooks();

        // 本地摘要（uuid + 文件 hash 集）
        final localDigests = <LocalBookDigest>[];
        for (final book in localBooks) {
          final files = await _fileSync.buildBookFiles(book);
          localDigests.add(LocalBookDigest(
            uuid: book.uuid,
            name: book.name,
            fileHashes: {for (final f in files) f.hash},
          ));
        }
        final localByUuid = {for (final l in localDigests) l.uuid: l};

        final plan = buildMatchPlan(localDigests, remoteBooks);
        final total = plan.toDownload.length + plan.toUploadUuids.length + plan.conflicts.length;
        var done = 0;

        // 预注册整批待同步书（等待中），让页面先看到完整清单（§0）
        for (final r in plan.toDownload) {
          detail.book(
            r.uuid,
            r.name,
            [for (final f in r.files) f.relPath],
            direction: 'download',
          );
        }
        for (final uuid in plan.toUploadUuids) {
          final book = localBooks.firstWhere((b) => b.uuid == uuid);
          final files = await _fileSync.buildBookFiles(book);
          detail.book(
            book.uuid,
            book.name,
            [for (final f in files) f.relPath],
            direction: 'upload',
          );
        }

        // ① 下载远程有本地无的
        var failedBooks = 0;
        for (final r in plan.toDownload) {
          done++;
          progress(SyncOpProgress(currentBook: done, totalBooks: total));
          final ok = await _downloader.downloadBook(r, progress, detail);
          if (!ok) failedBooks++;
        }

        // ② 上传本地有远程无的（保留本地 uuid）
        for (final uuid in plan.toUploadUuids) {
          done++;
          progress(SyncOpProgress(currentBook: done, totalBooks: total));
          final book = localBooks.firstWhere((b) => b.uuid == uuid);
          final files = await _fileSync.buildBookFiles(book);
          final (_, ok, fail, revision) =
              await _fileSync.uploadBookToServerWithDetail(
            detail: detail,
            rowProgress: progress,
            currentBook: done,
            totalBooks: total,
            uuid: book.uuid,
            name: book.name,
            files: files,
          );
          if (fail > 0) {
            failedBooks++;
            AppLog.w('双向同步上传失败 ${book.name} ok=$ok fail=$fail', tag: 'BIDIR');
          } else if (revision > 0) {
            // 回填服务器 revision（§2.1.5 乐观锁基准）
            await _syncState.upsertRevision('book', book.uuid, revision);
          }
        }

        // ③ 冲突：收集到 LocalConflictService，UI 弹层逐个处理（§7）。
        //    以本轮匹配为准收敛：仍冲突的加入/保留；已不再冲突的旧冲突
        //    （被解决、任一侧已一致、书已删除）自动移除 → 底栏提示随之消失。
        for (final c in plan.conflicts) {
          _localConflicts.add(LocalConflict(
            uuid: c.uuid,
            name: c.name,
            serverBook: c,
          ));
          AppLog.w('双向同步发现冲突: ${c.name}(${c.uuid})', tag: 'BIDIR');
        }
        _localConflicts.retainOnly({for (final c in plan.conflicts) c.uuid});

        // ④ 双方一致的书（跳过）：回填服务器 revision，保证后续编辑的乐观锁基准
        //    与服务器一致（仅在本地内容 == 服务器内容时回填，冲突书不动）
        for (final r in remoteBooks) {
          if (r.revision <= 0) continue;
          final digest = localByUuid[r.uuid];
          if (digest == null) continue;
          final remoteHashes = {for (final f in r.files) f.hash};
          if (!_sameFileSets(digest.fileHashes, remoteHashes)) continue;
          final current =
              await _syncState.getRevision('book', r.uuid) ?? 0;
          if (r.revision > current) {
            await _syncState.upsertRevision('book', r.uuid, r.revision);
          }
        }

        // ⑤ 顺带消费事件流：跨设备进度/墓碑/修订收敛（§4）
        await _pullQuiet();

        if (failedBooks > 0) {
          // §0：部分书失败 → 组任务标 failed（冲突书仍待 UI 处理；下载失败页
          // 已在 sync_down 记录，可页级重试或整批重试）
          throw StateError('$failedBooks 本书同步失败，可重试');
        }
        progress(SyncOpProgress(currentBook: total, totalBooks: total));
      },
    );
  }

  static bool _sameFileSets(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    return a.every(b.contains);
  }

  /// §8.0/§8.1/§8.2：恢复上次未完成的同步（App 启动/用户确认后调用）。
  ///
  /// 下载断点（sync_down 缺页，页级续传）+ 上传残留（sync_upload，文件级断点
  /// 幂等续传）合为一组任务；本地已删的书其残留自动清理。
  Future<void> resumeUnfinished() async {
    final downBooks = await _downloader.unfinishedDownloads();
    final residual = await _syncUpload.listAll();
    if (downBooks.isEmpty && residual.isEmpty) return; // 无残留

    await _ops.enqueue(
      type: SyncOpType.resume,
      executor: (progress, detail) async {
        final localByUuid = {
          for (final b in await _books.getAllBooks()) b.uuid: b,
        };
        final tasks = <({String kind, String uuid})>[
          for (final u in downBooks) (kind: 'down', uuid: u),
          for (final r in residual)
            if (localByUuid.containsKey(r.uuid)) (kind: 'up', uuid: r.uuid),
        ];
        var total = tasks.length;
        var done = 0;
        var failed = 0;
        for (final t in tasks) {
          done++;
          progress(SyncOpProgress(currentBook: done, totalBooks: total));
          if (t.kind == 'down') {
            failed += await _downloader.resumeBook(t.uuid, progress, detail);
          } else {
            final ok = await _uploadOneBook(
              localByUuid[t.uuid]!,
              progress: progress,
              detail: detail,
              currentBook: done,
              totalBooks: total,
            );
            if (!ok) failed++;
          }
        }
        // 恢复完成后顺带消费事件流（跨设备收敛，§4）
        await _pullQuiet();
        if (failed > 0) {
          // §0：恢复未完全成功 → 组任务标 failed，可重试（只处理仍失败的书）
          throw StateError('$failed 项恢复失败，可重试');
        }
      },
    );
  }
}

final initSyncServiceProvider = Provider<InitSyncService>((ref) {
  return InitSyncService(
    ref.watch(bookRepositoryProvider),
    ref.watch(syncOpServiceProvider),
    ref.watch(syncServiceProvider.notifier),
    ref.watch(optimisticDownloadServiceProvider),
    ref.watch(fileSyncServiceProvider),
    ref.watch(syncUploadLocalDatasourceProvider),
    ref.watch(syncStateLocalDatasourceProvider),
    ref.watch(localConflictServiceProvider),
  );
});

/// 纯函数：由本地/远程书数判定初始化同步分支（可单测）。
InitSyncBranch detectBranch(int localCount, int remoteCount) {
  if (localCount == 0 && remoteCount == 0) return InitSyncBranch.bothEmpty;
  if (localCount == 0) return InitSyncBranch.downloadOnly;
  if (remoteCount == 0) return InitSyncBranch.uploadOnly;
  return InitSyncBranch.bidirectional;
}
