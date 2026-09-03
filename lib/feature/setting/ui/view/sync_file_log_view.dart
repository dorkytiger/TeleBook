import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/f_adaptive_dialog.dart';
import 'package:tele_book/core/service/diag_export_service.dart';
import 'package:tele_book/core/util/app_log.dart';

/// 诊断日志查看页：展示统一日志（{appDocDir}/logs/app.log 滚动文件尾部），
/// 供 release 真机排查崩溃/同步问题。顶栏：
/// - 导出（分享诊断包 zip：日志 + 崩溃记录 + 设备上下文）
/// - 复制全文 / 清空日志
/// 进入页面后每 2s 自动刷新（贴底时跟随新行）；顶部显示崩溃记录数。
class SyncFileLogView extends StatefulWidget {
  const SyncFileLogView({super.key});

  @override
  State<SyncFileLogView> createState() => _SyncFileLogViewState();
}

class _SyncFileLogViewState extends State<SyncFileLogView> {
  List<String> _lines = const [];
  List<File> _crashes = const [];
  bool _loading = true;
  bool _stickToBottom = true; // 用户上滑查看旧日志时暂停跟随
  bool _exporting = false;
  Timer? _timer;
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final lines = await AppLog.readTail();
    final crashes = await AppLog.crashFiles();
    if (!mounted) return;
    final prevLen = _lines.length;
    setState(() {
      _lines = lines;
      _crashes = crashes;
      _loading = false;
    });
    // 仅在原本贴底/无滚动时跟随新行
    if (prevLen < lines.length && _stickToBottom && _scroll.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.jumpTo(_scroll.position.maxScrollExtent);
        }
      });
    }
  }

  Future<void> _export() async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      final ok = await DiagExport.share();
      if (!mounted) return;
      if (!ok) {
        showFToast(
          context: context,
          title: const Text('导出失败'),
          description: const Text('请检查是否有可用的分享方式'),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _copyAll() async {
    if (_lines.isEmpty) {
      showFToast(context: context, title: const Text('日志为空'));
      return;
    }
    await Clipboard.setData(ClipboardData(text: _lines.join('\n')));
    if (!mounted) return;
    showFToast(context: context, title: const Text('已复制全部日志'));
  }

  Future<void> _clear() async {
    final ok = await showFDialog<bool>(
      context: context,
      builder: (context, style, animate) => FAdaptiveDialog(
        title: const Text('清空日志'),
        body: const Text('确定清空统一日志？崩溃记录（crash_*.log）会保留。'),
        actions: [
          FButton(
            variant: .outline,
            size: .sm,
            onPress: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FButton(
            size: .sm,
            onPress: () => Navigator.pop(context, true),
            child: const Text('清空'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await AppLog.clear();
    if (!mounted) return;
    setState(() {
      _lines = const [];
      _loading = false;
    });
    showFToast(context: context, title: const Text('已清空'));
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      childPad: false,
      header: FHeader.nested(
        title: const Text('诊断日志'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
        suffixes: [
          FHeaderAction(
            icon: _exporting
                ? const FCircularProgress(size: .sm)
                : const Icon(FLucideIcons.packageOpen),
            semanticsLabel: '导出诊断包',
            onPress: _export,
          ),
          FHeaderAction(
            icon: const Icon(FLucideIcons.copy),
            semanticsLabel: '复制全部',
            onPress: _copyAll,
          ),
          FHeaderAction(
            icon: const Icon(FLucideIcons.trash2),
            semanticsLabel: '清空',
            onPress: _clear,
          ),
        ],
      ),
      child: Column(
        children: [
          _banner(context),
          Expanded(
            child: _loading && _lines.isEmpty
                ? const Center(child: FCircularProgress())
                : _lines.isEmpty
                    ? const Center(child: Text('暂无日志'))
                    : NotificationListener<ScrollNotification>(
                        onNotification: (n) {
                          if (n.metrics.maxScrollExtent == 0 ||
                              n.metrics.pixels >=
                                  n.metrics.maxScrollExtent - 4) {
                            _stickToBottom = true;
                          } else if (n is UserScrollNotification) {
                            _stickToBottom = false;
                          }
                          return false;
                        },
                        child: Scrollbar(
                          controller: _scroll,
                          child: ListView.builder(
                            controller: _scroll,
                            padding: const EdgeInsets.all(8),
                            itemCount: _lines.length,
                            itemBuilder: (context, i) {
                              final line = _lines[i];
                              final isError = line.contains(' ERROR ') ||
                                  line.contains('CRASH') ||
                                  line.contains('FAIL') ||
                                  line.contains('err=');
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                child: Text(
                                  line,
                                  style: context.theme.typography.body.sm
                                      .copyWith(
                                    fontFamily: 'monospace',
                                    fontSize: 11,
                                    color: isError
                                        ? context.theme.colors.error
                                        : context.theme.colors.foreground,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _banner(BuildContext context) {
    final hasCrash = _crashes.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: FAlert(
        variant: hasCrash ? .destructive : .primary,
        icon: Icon(
          hasCrash ? FLucideIcons.alertTriangle : FLucideIcons.info,
        ),
        title: Text(
          hasCrash
              ? '发现崩溃记录 ${_crashes.length} 份'
              : '统一诊断日志（2s 自动刷新）',
        ),
        subtitle: Text(
          hasCrash
              ? '导出诊断包会自动带上崩溃记录与设备信息\n'
                  '目录: ${AppLog.dirPath ?? '（未初始化）'}'
              : '点右上角 📦 导出诊断包（日志+崩溃+设备信息）\n'
                  '目录: ${AppLog.dirPath ?? '（未初始化）'}',
        ),
      ),
    );
  }
}
