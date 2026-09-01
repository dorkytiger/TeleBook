import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/sync/datasource/sync_log_local_datasource.dart';

/// 本地同步记录列表：时间 / 同步书籍数 / 状态。
class SyncLogListView extends ConsumerWidget {
  const SyncLogListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(syncLogsProvider);

    return FScaffold(
      header: FHeader.nested(
        title: const Text('本地同步记录'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: logs.when(
        loading: () => const Center(child: FCircularProgress()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('暂无同步记录'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(syncLogsProvider),
            child: FItemGroup(
              children: [
                for (final log in list)
                  .item(
                    prefix: Icon(_statusIcon(log.status), size: 20),
                    title: Text(_statusLabel(log.status)),
                    subtitle: Text(
                      '${_formatTime(log.startedAt)} · 同步 ${log.syncedBooks}/${log.totalBooks} 本'
                      '${log.failedBooks > 0 ? ' · 失败 ${log.failedBooks}' : ''}',
                    ),
                    onPress: () => context.push(
                      AppRoute.syncLogDetail,
                      extra: log.id,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _statusIcon(String status) => switch (status) {
        'running' => FLucideIcons.refreshCw,
        'completed' => FLucideIcons.checkCircle,
        'failed' => FLucideIcons.alertTriangle,
        _ => FLucideIcons.clock,
      };

  String _statusLabel(String status) => switch (status) {
        'running' => '同步中',
        'completed' => '同步完成',
        'failed' => '同步失败',
        _ => status,
      };

  String _formatTime(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${t.year}-${two(t.month)}-${two(t.day)} ${two(t.hour)}:${two(t.minute)}';
  }
}

final syncLogsProvider = FutureProvider.autoDispose<List<SyncLogTableData>>((
  ref,
) async {
  return ref.watch(syncLogLocalDatasourceProvider).listLogs();
});

/// 同步记录的书籍状态（detail JSON 解析）。
class SyncLogBookState {
  final String uuid;
  final String name;
  final String status;
  final List<SyncLogFileState> files;

  const SyncLogBookState({
    required this.uuid,
    required this.name,
    required this.status,
    required this.files,
  });

  factory SyncLogBookState.fromJson(Map<String, dynamic> json) {
    return SyncLogBookState(
      uuid: json['uuid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      files: ((json['files'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(SyncLogFileState.fromJson)
          .toList(),
    );
  }

  int get filesDone => files.where((f) => f.status == 'done').length;
  int get filesFailed => files.where((f) => f.status == 'failed').length;
}

class SyncLogFileState {
  final String rel;
  final String status;

  const SyncLogFileState({required this.rel, required this.status});

  factory SyncLogFileState.fromJson(Map<String, dynamic> json) => SyncLogFileState(
        rel: json['rel'] as String? ?? '',
        status: json['status'] as String? ?? 'pending',
      );
}

/// 从日志行解析书籍状态列表。
List<SyncLogBookState> parseLogBooks(SyncLogTableData log) {
  if (log.detail == null || log.detail!.isEmpty) return [];
  try {
    final root = jsonDecode(log.detail!) as Map<String, dynamic>;
    return ((root['books'] as List?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(SyncLogBookState.fromJson)
        .toList();
  } catch (_) {
    return [];
  }
}
