import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/f_adaptive_dialog.dart';
import 'package:tele_book/core/util/file_log.dart';

/// 临时文件日志查看页（调试用）：release 真机无法连调试器时，
/// 用「设置 → 同步后台日志」查看 {appDocDir}/sync_bg.log，
/// 排查熄屏后后台下载/上传是否持续推进（§BG）。
///
/// 顶栏提供 刷新 / 复制全文 / 清空；进入页面后每 2s 自动刷新
/// （贴在底部时跟随新行滚动）。
class SyncFileLogView extends StatefulWidget {
  const SyncFileLogView({super.key});

  @override
  State<SyncFileLogView> createState() => _SyncFileLogViewState();
}

class _SyncFileLogViewState extends State<SyncFileLogView> {
  List<String> _lines = const [];
  bool _loading = true;
  bool _stickToBottom = true; // 用户上滑查看旧日志时暂停跟随
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
    final lines = await FileLog.read();
    if (!mounted) return;
    final prevLen = _lines.length;
    setState(() {
      _lines = lines;
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
        body: const Text('确定删除 sync_bg.log 的全部内容？'),
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
    await FileLog.clear();
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
        title: const Text('同步后台日志'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
        suffixes: [
          FHeaderAction(
            icon: const Icon(FLucideIcons.copy),
            onPress: _copyAll,
          ),
          FHeaderAction(
            icon: const Icon(FLucideIcons.trash2),
            onPress: _clear,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.theme.colors.muted,
              border: Border(
                bottom: BorderSide(color: context.theme.colors.border),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              '临时调试日志（2s 自动刷新）· ${FileLog.filePath}\n'
              '熄屏/后台后返回本页，查看 BG_DL/BG_UP/BG_EVT/OPQ 记录判断是否推进',
              style: context.theme.typography.body.sm.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ),
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
                              final isError = line.contains('FAIL') ||
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
}
