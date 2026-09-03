import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/core/util/crash_guard.dart';
import 'package:tele_book/feature/setting/repository/setting_repository.dart';
import 'package:tele_book/feature/setting/ui/provider/setting_provider.dart';

/// 常驻（不可见）上下文同步：把同步服务器地址注入 CrashGuard，
/// 崩溃诊断 / 导出包能带上服务器信息（脱敏，不含 token）。
///
/// 监听 [syncConfiguredProvider]：配置变化（连接/重连/清除）时刷新；
/// 只读一次避免每次 build 都查库。
class DiagContextSync extends ConsumerStatefulWidget {
  const DiagContextSync({super.key});

  @override
  ConsumerState<DiagContextSync> createState() => _DiagContextSyncState();
}

class _DiagContextSyncState extends ConsumerState<DiagContextSync> {
  bool _fetchedOnce = false;

  @override
  Widget build(BuildContext context) {
    final configured = ref.watch(syncConfiguredProvider).value ?? false;
    if (!configured) {
      CrashGuard.setServerUrl('');
      _fetchedOnce = false; // 配置清除后允许下次重新读
      return const SizedBox.shrink();
    }
    if (!_fetchedOnce) {
      _fetchedOnce = true;
      _pushUrl();
    }
    return const SizedBox.shrink();
  }

  Future<void> _pushUrl() async {
    final repo = ref.read(settingRepositoryProvider);
    final url = await repo.getString(SyncSettings.serverUrl);
    CrashGuard.setServerUrl(url ?? '');
  }
}
