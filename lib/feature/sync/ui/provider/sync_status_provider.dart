import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/feature/sync/datasource/sync_task_local_datasource.dart';
import 'package:tele_book/feature/sync/service/auto_sync_service.dart';
import 'package:tele_book/feature/sync/service/sync_mutation_service.dart';

/// 全局同步状态（底栏指示用）。
class SyncStatusState {
  final bool configured; // 是否已配置同步服务器
  final bool syncing; // 后台同步进行中
  final String? syncDetail; // 同步中的实时进度文案（如"当前 书X 13/20 · 已完成 1 本"）
  final int pendingCount; // 待同步任务数（outbox）
  final int conflictCount; // 未解决冲突数
  final DateTime? lastSyncedAt; // 上次成功同步时间

  const SyncStatusState({
    this.configured = false,
    this.syncing = false,
    this.syncDetail,
    this.pendingCount = 0,
    this.conflictCount = 0,
    this.lastSyncedAt,
  });

  SyncStatusState copyWith({
    bool? configured,
    bool? syncing,
    String? syncDetail,
    int? pendingCount,
    int? conflictCount,
    DateTime? lastSyncedAt,
  }) {
    return SyncStatusState(
      configured: configured ?? this.configured,
      syncing: syncing ?? this.syncing,
      syncDetail: syncDetail ?? this.syncDetail,
      pendingCount: pendingCount ?? this.pendingCount,
      conflictCount: conflictCount ?? this.conflictCount,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}

/// 底栏同步状态：监听 outbox（待同步数）+ 冲突标记 + 服务器冲突列表；
/// 读取即触发自动同步注册。
class SyncStatusNotifier extends Notifier<SyncStatusState> {
  @override
  SyncStatusState build() {
    // 读取即注册自动同步（启动 drain + 定时）
    ref.watch(autoSyncServiceProvider);

    final mutation = ref.watch(syncMutationServiceProvider);
    mutation.conflictedBookIds.addListener(_refreshListeners);
    mutation.outboxRevision.addListener(_refreshListeners);
    mutation.draining.addListener(_onDrainingChanged);
    ref.onDispose(() {
      mutation.conflictedBookIds.removeListener(_refreshListeners);
      mutation.outboxRevision.removeListener(_refreshListeners);
      mutation.draining.removeListener(_onDrainingChanged);
    });

    Future.microtask(refresh);
    return const SyncStatusState();
  }

  void _refreshListeners() {
    Future.microtask(refresh);
  }

  /// drain 进行中 → 底栏显示"同步中"（任意导入/删除触发）。
  void _onDrainingChanged() {
    final draining = ref.read(syncMutationServiceProvider).draining.value;
    state = state.copyWith(syncing: draining, syncDetail: draining ? '同步中…' : null);
  }

  /// 刷新：配置状态 + 待同步数 + 冲突数（服务器不可达时退回本地标记数）。
  Future<void> refresh() async {
    final mutation = ref.read(syncMutationServiceProvider);
    final configured = await mutation.isConfigured();
    final pending = await ref.read(syncTaskLocalDatasourceProvider).countPending();
    var count = mutation.conflictedBookIds.value.length;
    if (configured) {
      try {
        final list = await ref
            .read(syncServiceProvider.notifier)
            .listConflicts();
        if (list.isNotEmpty) count = list.length;
        state = SyncStatusState(
          configured: true,
          syncing: state.syncing,
          pendingCount: pending,
          conflictCount: count,
          lastSyncedAt: DateTime.now(),
        );
        return;
      } catch (_) {
        // 服务器不可达：退回本地标记
      }
    }
    state = state.copyWith(
      configured: configured,
      pendingCount: pending,
      conflictCount: count,
    );
  }

  void setSyncing(bool syncing) {
    state = state.copyWith(syncing: syncing, syncDetail: syncing ? state.syncDetail : null);
  }

  void setSyncDetail(String? detail) {
    state = state.copyWith(syncDetail: detail);
  }
}

final syncStatusProvider =
    NotifierProvider<SyncStatusNotifier, SyncStatusState>(SyncStatusNotifier.new);
