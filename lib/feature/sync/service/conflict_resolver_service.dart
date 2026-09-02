import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/util/app_log.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/sync/datasource/sync_down_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_state_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_upload_local_datasource.dart';
import 'package:tele_book/feature/sync/service/file_sync_service.dart';
import 'package:tele_book/feature/sync/service/local_conflict_service.dart';
import 'package:tele_book/feature/sync/service/optimistic_download_service.dart';
import 'package:tele_book/feature/sync/service/sync_op_service.dart';

/// §7 冲突解决动作执行器：把「保留服务器 / 保留本地」作为**组任务**入队执行。
///
/// - 保留服务器 → 清本地该书（**不推删除墓碑**，服务器版本胜）→ 重新下载服务器版本覆盖。
/// - 保留本地 → 本地上传覆盖服务器（服务端同 uuid ForceUpsert，§7）。
/// - 动作全程可中断/可重试（SyncOp 队列负责状态与失败标记）；执行成功后才
///   [LocalConflictService.resolve] 移除待处理冲突。
class ConflictResolverService {
  final BookRepository _books;
  final SyncOpService _ops;
  final OptimisticDownloadService _downloader;
  final FileSyncService _fileSync;
  final LocalConflictService _conflicts;
  final SyncStateLocalDatasource _syncState;
  final SyncDownLocalDatasource _syncDown;
  final SyncUploadLocalDatasource _syncUpload;

  ConflictResolverService(
    this._books,
    this._ops,
    this._downloader,
    this._fileSync,
    this._conflicts,
    this._syncState,
    this._syncDown,
    this._syncUpload,
  );

  /// §7 保留服务器：下载服务器版本覆盖本地。
  ///
  /// 步骤：清本地书（行 + 文件 + 断点残留）→ 乐观下载重建（下载器内部回填
  /// 服务器 revision，供后续编辑推送做乐观锁基准）。
  /// 返回是否成功（成功 = 冲突已被移除）；失败（如网络断）→ 任务标 failed，
  /// 冲突仍待处理，UI 提示可再次重试。
  Future<bool> keepServer(LocalConflict conflict) async {
    final id = await _ops.enqueue(
      type: SyncOpType.conflict,
      title: '解决冲突 · 保留服务器',
      executor: (progress, detail) async {
        progress(const SyncOpProgress(currentBook: 1, totalBooks: 1));
        await _clearLocalBook(conflict.uuid);
        final ok = await _downloader.downloadBook(
          conflict.serverBook,
          progress,
          detail,
        );
        // 全部页下载完成才 resolve（§7：先做单向动作，完成后才移除冲突）；
        // 有失败页 → 抛错标 failed，冲突保留可重试（不 resolve）
        if (!ok) {
          throw StateError('下载不完整，有页下载失败，可重试');
        }
        _conflicts.resolve(conflict.uuid);
      },
    );
    await _ops.waitUntilSettled(id);
    return !_conflicts.pending.value.any((c) => c.uuid == conflict.uuid);
  }

  /// §7 保留本地：本地上传覆盖服务器。
  ///
  /// 单文件失败数 > 0 → 抛错标 failed（服务端断点已记录已 done 文件，重试只传缺失）；
  /// 成功后回填服务器 revision 作为后续编辑的乐观锁基准。
  /// 返回是否成功（成功 = 冲突已被移除）。
  Future<bool> keepLocal(LocalConflict conflict) async {
    final id = await _ops.enqueue(
      type: SyncOpType.conflict,
      title: '解决冲突 · 保留本地',
      executor: (progress, detail) async {
        final book = await _books.getBookByUuid(conflict.uuid);
        if (book == null) {
          // 本地书已不存在 → 没有"本地版本"可保留，冲突自然消除（服务器版保留）
          _conflicts.resolve(conflict.uuid);
          return;
        }
        final files = await _fileSync.buildBookFiles(book);
        if (files.isEmpty) {
          throw StateError('本地书没有可上传的文件: ${book.name}');
        }
        // 整本上传 + 明细/行级进度（§0）
        final (_, ok, fail, revision) =
            await _fileSync.uploadBookToServerWithDetail(
          detail: detail,
          rowProgress: progress,
          currentBook: 1,
          totalBooks: 1,
          uuid: book.uuid,
          name: book.name,
          files: files,
        );
        if (fail > 0) {
          AppLog.e(
            '保留本地上传失败 ${book.name} ok=$ok fail=$fail',
            tag: 'CONFLICT',
          );
          throw StateError('上传失败 $fail 个文件，可重试（已上传部分自动跳过）');
        }
        // 回填服务器 revision（§2.1.5 乐观锁基准：本地内容 = 服务器当前内容）
        if (revision > 0) {
          await _syncState.upsertRevision('book', book.uuid, revision);
        }
        // 收尾进度（跳过非 pending 文件的场景也把页数走满）
        progress(SyncOpProgress(
          currentBook: 1,
          totalBooks: 1,
          currentPage: files.length,
          totalPages: files.length,
        ));
        _conflicts.resolve(conflict.uuid);
      },
    );
    await _ops.waitUntilSettled(id);
    return !_conflicts.pending.value.any((c) => c.uuid == conflict.uuid);
  }

  /// 清空本地某本书：DB 行 + 本地图片目录 + 断点残留（sync_down/sync_upload）。
  ///
  /// ⚠️ 只做本地清理，绝不推 delete 墓碑——服务器版本即将胜出，
  /// 推送墓碑会把服务器这本书也删掉（§7 覆盖语义）。
  Future<void> _clearLocalBook(String uuid) async {
    // 断点残留：旧 sync_down（待下载清单）/ sync_upload（待上传任务）
    try {
      await _syncDown.deleteBook(uuid);
      await _syncUpload.deleteBook(uuid);
    } catch (e) {
      AppLog.w('清理断点残留失败: $e', tag: 'CONFLICT');
    }
    // 服务端若有该 uuid 的上传任务（含无本地 sync_upload 记录的残留）→ 放弃，
    // 防止旧任务残留（§8.2 清理；幂等，失败忽略）
    await _fileSync.abandonUpload(uuid);
    final row = await _books.getBookByUuid(uuid);
    if (row != null) {
      await _books.deleteBook(row.id); // 完整清理（DB + localSubPaths 目录）
      return;
    }
    await _books.deleteBookByUuid(uuid);
    // 无行兜底：直接删 uuid 目录（文件在、行丢的半残留场景）
    final dir = Directory(GlobalConfig.resolveBookPath(uuid));
    if (await dir.exists()) {
      try {
        await dir.delete(recursive: true);
      } catch (e) {
        AppLog.w('删除书籍目录失败 $uuid: $e', tag: 'CONFLICT');
      }
    }
  }
}

final conflictResolverServiceProvider = Provider<ConflictResolverService>((ref) {
  return ConflictResolverService(
    ref.watch(bookRepositoryProvider),
    ref.watch(syncOpServiceProvider),
    ref.watch(optimisticDownloadServiceProvider),
    ref.watch(fileSyncServiceProvider),
    ref.watch(localConflictServiceProvider),
    ref.watch(syncStateLocalDatasourceProvider),
    ref.watch(syncDownLocalDatasourceProvider),
    ref.watch(syncUploadLocalDatasourceProvider),
  );
});
