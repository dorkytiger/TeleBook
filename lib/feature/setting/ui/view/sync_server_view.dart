import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/common/widget/f_adaptive_dialog.dart';
import 'package:tele_book/feature/setting/repository/setting_repository.dart';
import 'package:tele_book/feature/sync/service/init_sync_service.dart';

/// 初始化服务器引导页（§1.4）：
/// 地址 + 密钥 → 复制/粘贴/测试 → 保存并连接 → 询问是否立即同步。
/// 同步功能（刷新/快照/历史/本地记录）在设置页按已配置状态显示，不在此页堆叠。
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
      // 连接成功 → 询问是否立即同步（§1.4）
      await _askSyncNow();
    } catch (e) {
      if (!mounted) return;
      setState(() => _connecting = false);
      showFToast(
        context: context,
        title: const Text('连接失败'),
        description: Text(
          _friendlyConnectError(e),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }

  /// 把连接异常转成用户可读的短文案（不要拿 DioException 长原文直接弹 toast，
  /// 会撑爆 ForUI 通知高度）。
  String _friendlyConnectError(Object e) {
    if (e is DioException) {
      // 注册 401 = 连接密钥不对（服务器 SYNC_SECRET 比对失败）
      if (e.response?.statusCode == 401) {
        return '连接密钥不正确：请填写服务器 .env 中的 SYNC_SECRET';
      }
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return '无法连接服务器：请检查地址与网络';
      }
      // 服务器返回的业务错误 message 优先
      final data = e.response?.data;
      if (data is Map && data['message'] is String && (data['message'] as String).isNotEmpty) {
        return data['message'] as String;
      }
      return e.message ?? '连接失败';
    }
    final s = e.toString();
    return s.length > 80 ? '${s.substring(0, 80)}…' : s;
  }

  /// 连接成功后的引导：询问是否立即初始化同步（是→同步；否→后续刷新同步）。
  Future<void> _askSyncNow() async {
    if (!mounted) return;
    final sync = await showFDialog<bool>(
      context: context,
      builder: (context, style, animate) => FAdaptiveDialog(
        title: const Text('连接成功'),
        body: const Text('是否立即同步书籍？\n（否则可稍后在设置中「刷新同步」）'),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(context, false),
            child: const Text('稍后'),
          ),
          FButton(
            onPress: () => Navigator.pop(context, true),
            child: const Text('立即同步'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (sync == true) {
      // 立即初始化同步 → 入队一组任务，全局通知显示进度（§1.4/§2.1）
      await ref.read(initSyncServiceProvider).run();
      if (!mounted) return;
      showFToast(context: context, title: const Text('已开始同步，可在底部查看进度'));
      context.pop();
    }
  }

  // ── 复制 / 粘贴连接配置 ──────────────────────────────────

  /// 简单混淆：SHA-256(固定盐) 派生密钥流，逐字节 XOR + base64。
  /// 防止剪贴板明文直读；非安全边界（真正安全在服务器 SYNC_SECRET）。
  static final List<int> _xorKey = sha256
      .convert(utf8.encode('telebook-sync-config-v1'))
      .bytes;

  static String _obfuscate(String plain) {
    final data = utf8.encode(plain);
    final out = List<int>.generate(data.length, (i) => data[i] ^ _xorKey[i % _xorKey.length]);
    return base64Encode(out);
  }

  static String _deobfuscate(String encoded) {
    final data = base64Decode(encoded);
    final out = List<int>.generate(data.length, (i) => data[i] ^ _xorKey[i % _xorKey.length]);
    return utf8.decode(out);
  }

  /// 把当前填写的服务器信息打包成一段可分享文本：
  /// 每行一个 key: value（密钥字段混淆），便于另一台设备"粘贴"时按行解析回填。
  String _formatConfig(String url, String key) {
    final lines = <String>[
      'TeleBook 同步配置',
      '服务器地址: ${url.trim()}',
    ];
    if (key.trim().isNotEmpty) {
      lines.add('连接密钥: enc:${_obfuscate(key.trim())}');
    }
    return lines.join('\n');
  }

  /// 复制连接配置到剪贴板（可分享给其他设备 / 好友）。
  Future<void> _copyConfig() async {
    final url = _urlController.text;
    final key = _keyController.text;
    if (url.trim().isEmpty && key.trim().isEmpty) {
      showFToast(context: context, title: const Text('请先填写服务器地址与连接密钥'));
      return;
    }
    await Clipboard.setData(ClipboardData(text: _formatConfig(url, key)));
    if (!mounted) return;
    showFToast(context: context, title: const Text('已复制连接配置，可分享给其他设备'));
  }

  /// 从剪贴板解析连接配置并回填输入框。
  ///
  /// 借鉴 RustDesk 的配置解析设计：
  /// - 宽松解析：大小写不敏感、支持中文/英文冒号、兼容裸 URL 与
  ///   `host=xxx,key=yyy` 逗号分隔格式（RustDesk 同款）
  /// - 严格校验：地址必须是合法 http/https URL；enc: 密文必须能解密；
  ///   整体解析失败明确报错（对应 RustDesk 的 bail!("Failed to parse")）
  Future<void> _pasteConfig() async {
    final data = await Clipboard.getData('text/plain');
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) {
      if (mounted) {
        showFToast(context: context, title: const Text('剪贴板中没有内容'));
      }
      return;
    }

    // 解析 + 校验，失败给出具体原因
    final (url, key) = _parseConfig(text);

    // 完全没解析出任何有效字段 → 明确报错（含剪贴板预览）
    if (url == null && key == null) {
      if (mounted) {
        showFToast(
          context: context,
          title: const Text('未能识别服务器配置'),
          description: Text(
            '剪贴板内容:\n${text.length > 60 ? '${text.substring(0, 60)}…' : text}',
          ),
        );
      }
      return;
    }

    // 部分无效：地址非法或密钥损坏 → 报具体原因
    final errors = <String>[
      if (url == null && _containsUrlField(text)) '服务器地址无效（需 http/https）',
      if (key == null && _containsKeyField(text)) '连接密钥无效或已损坏',
    ];
    if (errors.isNotEmpty) {
      if (mounted) {
        showFToast(
          context: context,
          title: const Text('配置部分无效'),
          description: Text(errors.join('；')),
        );
      }
    }

    setState(() {
      if (url != null) _urlController.text = url;
      if (key != null) _keyController.text = key;
    });
    if (!mounted) return;
    showFToast(
      context: context,
      title: const Text('已粘贴服务器配置'),
      description: Text(
        [
          if (url != null) '服务器地址: $url',
          if (key != null) '连接密钥: $key',
          if (url != null && key == null) '提示：未识别到密钥，请手动填写',
        ].join('\n'),
      ),
    );
  }

  /// 剪贴板文本中是否包含"服务器地址"字段（判断"地址无效"还是"根本没地址"）。
  bool _containsUrlField(String text) {
    final t = text.toLowerCase().replaceAll('：', ':');
    return t.contains('服务器地址:') || t.contains('host=') ||
        t.contains('http://') || t.contains('https://');
  }

  /// 剪贴板文本中是否包含"连接密钥"字段。
  bool _containsKeyField(String text) {
    final t = text.toLowerCase().replaceAll('：', ':');
    return t.contains('连接密钥:') || t.contains('key=');
  }

  /// 解析剪贴板文本，返回 (服务器地址, 连接密钥)。
  ///
  /// 支持格式：
  /// 1. 本 App 复制格式：`服务器地址: http://...` / `连接密钥: enc:xxx`
  ///    （中文/英文冒号均可）
  /// 2. RustDesk 风格：`host=xxx,key=yyy`（逗号分隔 key=value，大小写不敏感）
  /// 3. 裸 URL：`http://192.168.x.x:18080`
  ///
  /// 校验：地址必须是合法 http/https URL（host 非空）；
  /// enc: 密文解密失败视为密钥无效（null）。
  (String?, String?) _parseConfig(String text) {
    String? url;
    String? key;

    // ① 逐行扫描（本 App 复制格式 / 裸 URL）
    for (final rawLine in text.split('\n')) {
      var line = rawLine.trim();
      if (line.isEmpty) continue;
      // 支持中文/英文冒号
      line = line.replaceAll('：', ':');
      final lower = line.toLowerCase();
      if (lower.startsWith('服务器地址:')) {
        url = line.substring('服务器地址:'.length).trim();
      } else if (lower.startsWith('连接密钥:')) {
        key = _tryDecodeKey(line.substring('连接密钥:'.length).trim());
      } else if (lower.startsWith('http://') || lower.startsWith('https://')) {
        // 裸地址兜底
        url = line;
      }
    }

    // ② RustDesk 风格：host=xxx,key=yyy（逗号分隔，大小写不敏感）
    if (url == null && text.toLowerCase().contains('host=')) {
      for (final part in text.split(RegExp(r'[,，]'))) {
        final p = part.trim();
        final idx = p.indexOf('=');
        if (idx <= 0) continue;
        final k = p.substring(0, idx).trim().toLowerCase();
        final v = p.substring(idx + 1).trim();
        if (k == 'host') {
          url = v;
        } else if (k == 'key') {
          key = _tryDecodeKey(v);
        }
      }
    }

    // 校验地址：必须是合法 http/https URL
    url = _validateUrl(url);
    // 校验密钥：非空
    if (key != null && key.isEmpty) key = null;
    return (url, key);
  }

  /// 校验并规范化服务器地址；非法返回 null。
  String? _validateUrl(String? raw) {
    if (raw == null) return null;
    final s = raw.trim();
    if (s.isEmpty) return null;
    final uri = Uri.tryParse(s);
    if (uri == null) return null;
    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') return null;
    if (uri.host.isEmpty) return null;
    return s;
  }

  /// 解析密钥字段：enc: 前缀走混淆解密（失败返回 null），否则视为明文。
  String? _tryDecodeKey(String v) {
    if (v.isEmpty) return null;
    if (v.startsWith('enc:') || v.startsWith('ENC:')) {
      try {
        final decoded = _deobfuscate(v.substring(4));
        return decoded.isEmpty ? null : decoded;
      } catch (_) {
        return null; // 密文损坏 → 密钥无效
      }
    }
    return v;
  }

  @override
  Widget build(BuildContext context) {
    final configured = _statusText != null && _statusText!.startsWith('已连接');
    return FScaffold(
      header: FHeader.nested(
        title: Text(configured ? '重新初始化服务器' : '初始化服务器'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 引导说明
          Text(
            '输入服务器地址与连接密钥，让本设备与其他设备共享书库。\n'
            '完成后可立即同步或稍后在设置中同步。',
            style: context.theme.typography.body.sm.copyWith(
              color: context.theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 8),
          // 复制 / 粘贴配置（分享给其它设备或从剪贴板导入）
          Row(
            children: [
              Expanded(
                child: FButton(
                  variant: FButtonVariant.ghost,
                  size: .sm,
                  prefix: const Icon(FLucideIcons.copy, size: 14),
                  onPress: _copyConfig,
                  child: const Text('复制配置'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FButton(
                  variant: FButtonVariant.ghost,
                  size: .sm,
                  prefix: const Icon(FLucideIcons.clipboardPaste, size: 14),
                  onPress: _pasteConfig,
                  child: const Text('粘贴配置'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 16),
          // 连接状态提示
          if (_statusText != null)
            FItem(
              title: Text(_statusText!),
              prefix: Icon(
                configured ? FLucideIcons.checkCircle : FLucideIcons.info,
                size: 16,
                color: configured
                    ? context.theme.colors.primary
                    : context.theme.colors.mutedForeground,
              ),
            ),
          const SizedBox(height: 12),
          Text(
            '连接成功后：书库 / 阅读进度 / 图片可跨设备同步。\n'
            '同步功能入口在「设置 → 服务器」分组中。',
            style: context.theme.typography.body.sm.copyWith(
              color: context.theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
