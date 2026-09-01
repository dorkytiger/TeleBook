import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/feature/setting/repository/setting_repository.dart';

/// 同步服务器设置页：连接配置 / 测试连接 / 手动同步。
class SyncServerView extends ConsumerStatefulWidget {
  const SyncServerView({super.key});

  @override
  ConsumerState<SyncServerView> createState() => _SyncServerViewState();
}

class _SyncServerViewState extends ConsumerState<SyncServerView> {
  final _urlController = TextEditingController();
  final _keyController = TextEditingController();

  bool _testing = false;
  bool _connecting = false;
  String? _statusText;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    final settings = ref.read(settingRepositoryProvider);
    final url = await settings.getString(SyncSettings.serverUrl);
    final key = await settings.getString(SyncSettings.connectionKey);
    final token = await settings.getString(SyncSettings.token);
    if (!mounted) return;
    _urlController.text = url ?? '';
    _keyController.text = key ?? '';
    setState(() {
      _statusText = token == null ? '未连接' : '已连接（服务器：$url）';
    });
  }

  Future<void> _testConnection() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      showFToast(context: context, title: const Text('请先填写服务器地址'));
      return;
    }
    setState(() => _testing = true);
    final ok = await ref.read(syncServiceProvider.notifier).testConnection(url);
    if (!mounted) return;
    setState(() => _testing = false);
    showFToast(
      context: context,
      title: Text(ok ? '连接成功' : '连接失败，请检查地址与网络'),
    );
  }

  Future<void> _connect() async {
    final url = _urlController.text.trim();
    final key = _keyController.text.trim();
    if (url.isEmpty || key.isEmpty) {
      showFToast(context: context, title: const Text('请填写服务器地址与连接密钥'));
      return;
    }
    setState(() => _connecting = true);
    try {
      await ref.read(syncServiceProvider.notifier).configure(url: url, connectionKey: key);
      if (!mounted) return;
      setState(() {
        _connecting = false;
        _statusText = '已连接（服务器：$url）';
      });
      // 连接成功后跳转不可关闭的同步下载页：显示每本书的下载进度，完成自动回书籍页
      context.push(AppRoute.syncDownload);
    } catch (e) {
      if (!mounted) return;
      setState(() => _connecting = false);
      showFToast(
        context: context,
        title: const Text('连接失败'),
        description: Text('$e'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('同步服务器'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FTextFormField(
            label: const Text('服务器地址'),
            hint: 'http://192.168.x.x:18080',
            control: FTextFieldControl.managed(controller: _urlController),
          ),
          const SizedBox(height: 12),
          FTextFormField(
            label: const Text('连接密钥'),
            hint: '服务器上配置的 SYNC_SECRET',
            control: FTextFieldControl.managed(controller: _keyController),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FButton(
                  variant: FButtonVariant.outline,
                  onPress: _testing ? null : _testConnection,
                  child: _testing
                      ? const FCircularProgress()
                      : const Text('测试连接'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FButton(
                  onPress: _connecting ? null : _connect,
                  child: _connecting
                      ? const FCircularProgress()
                      : const Text('保存并连接'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FItem(
            title: const Text('手动同步'),
            subtitle: const Text('同步所有书籍（含图片），每本显示进度'),
            prefix: const Icon(FLucideIcons.refreshCw),
            onPress: () => context.push(AppRoute.syncBooks),
          ),
          const SizedBox(height: 12),
          FItem(
            title: const Text('历史记录'),
            subtitle: const Text('查看同步归档，可恢复到归档时刻'),
            prefix: const Icon(FLucideIcons.history),
            onPress: () => context.push(AppRoute.syncHistory),
          ),
          const SizedBox(height: 12),
          FItem(
            title: const Text('本地同步记录'),
            subtitle: const Text('查看每次同步的书籍与图片进度'),
            prefix: const Icon(FLucideIcons.list),
            onPress: () => context.push(AppRoute.syncLogList),
          ),
          const SizedBox(height: 12),
          if (_statusText != null)
            FItem(
              title: Text(_statusText!),
              prefix: const Icon(FLucideIcons.info),
            ),
          const SizedBox(height: 24),
          Text(
            '首版同步范围：书籍书名与阅读进度。图片文件同步即将支持。',
            style: context.theme.typography.body.sm.copyWith(
              color: context.theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
