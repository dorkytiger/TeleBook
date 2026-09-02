import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/core/util/app_log.dart';
import 'package:tele_book/feature/sync/service/sync_mutation_service.dart';
import 'package:tele_book/feature/sync/service/sync_op_service.dart';

/// 上传快照服务（§2.3）：把当前客户端书库快照传到服务器 history_book。
/// 入队一组任务（type=uploadSnapshot），全局通知显示；tag='手动'。
class UploadSnapshotService {
  final SyncService _sync;
  final SyncMutationService _mutation;
  final SyncOpService _ops;

  UploadSnapshotService(this._sync, this._mutation, this._ops);

  /// 入队并执行"上传快照"组任务。
  ///
  /// 防连点：队列中已有 running/waiting 的上传快照任务时不再重复入队，抛错提示。
  Future<void> upload() async {
    if (await _ops.hasActiveOfType(SyncOpType.uploadSnapshot)) {
      throw StateError('上传快照已在队列中（进行中或等待中），请稍候');
    }
    await _ops.enqueue(
      type: SyncOpType.uploadSnapshot,
      executor: (progress, detail) async {
        final snapshot = await _mutation.buildSnapshot();
        // 只上传到 history_book（§2.3），不动 current_book；tag=manual 表示手动
        await _sync.recordHistory(
          opType: 'manual_snapshot',
          tag: 'manual',
          snapshot: snapshot,
        );
        AppLog.i('上传快照完成: ${snapshot.length} 本', tag: 'UPLOAD_SNAP');
      },
    );
  }
}

final uploadSnapshotServiceProvider = Provider<UploadSnapshotService>((ref) {
  return UploadSnapshotService(
    ref.watch(syncServiceProvider.notifier),
    ref.watch(syncMutationServiceProvider),
    ref.watch(syncOpServiceProvider),
  );
});
