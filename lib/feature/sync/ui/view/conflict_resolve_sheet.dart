import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:tele_book/common/widget/f_adaptive_dialog.dart';
import 'package:tele_book/common/widget/f_sheet_content.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/feature/sync/model/response/conflict_response.dart';
import 'package:tele_book/feature/sync/ui/provider/sync_status_provider.dart';

/// 冲突解决弹层：勾选机制（不点一个就关）。
///
/// 顶部：全选/取消全选 + 冲突计数；底部：保留本地 / 保留服务器 批量解决
/// （对勾选项生效）；解决成功的项从列表移除，弹层保持打开直到全部解决或手动关闭。
Future<void> showConflictResolveSheet(
  BuildContext context,
  WidgetRef ref,
) async {
  final sync = ref.read(syncServiceProvider.notifier);
  final List<SyncConflict> conflicts;
  try {
    conflicts = await sync.listConflicts();
  } catch (e) {
    if (context.mounted) {
      showFToast(context: context, title: const Text('获取冲突列表失败'));
    }
    return;
  }
  if (!context.mounted) return;
  if (conflicts.isEmpty) {
    showFToast(context: context, title: const Text('当前没有冲突'));
    return;
  }

  await showFSheet(
    context: context,
    side: .btt,
    mainAxisMaxRatio: null,
    builder: (context) => FSheetContent(
      side: .btt,
      child: ConflictResolveSheet(conflicts: conflicts),
    ),
  );
  // 关闭后刷新状态
  await ref.read(syncStatusProvider.notifier).refresh();
}

class ConflictResolveSheet extends ConsumerStatefulWidget {
  final List<SyncConflict> conflicts;

  const ConflictResolveSheet({super.key, required this.conflicts});

  @override
  ConsumerState<ConflictResolveSheet> createState() =>
      _ConflictResolveSheetState();
}

class _ConflictResolveSheetState extends ConsumerState<ConflictResolveSheet> {
  late final List<SyncConflict> _conflicts = List.of(widget.conflicts);
  final Set<int> _selected = {};
  bool _resolving = false;

  bool get _allSelected =>
      _conflicts.isNotEmpty && _selected.length == _conflicts.length;

  String _name(Map<String, dynamic>? payload) =>
      (payload?['name'] as String?) ?? '（无书名）';

  void _toggle(int id) {
    setState(() {
      if (!_selected.add(id)) _selected.remove(id);
    });
  }

  void _toggleAll() {
    setState(() {
      if (_allSelected) {
        _selected.clear();
      } else {
        _selected.addAll(_conflicts.map((c) => c.id));
      }
    });
  }

  /// 批量解决勾选项：[strategy] keep_local | keep_server。
  Future<void> _resolveSelected(String strategy) async {
    if (_resolving || _selected.isEmpty) return;
    setState(() => _resolving = true);

    final sync = ref.read(syncServiceProvider.notifier);
    final resolved = <int>[];
    try {
      for (final id in List.of(_selected)) {
        await sync.resolveConflict(conflictId: id, strategy: strategy);
        resolved.add(id);
      }
      // 全部解决后拉取一次，让本地收敛
      await sync.pullOnly();
    } catch (e) {
      if (mounted) {
        showFToast(
          context: context,
          title: const Text('部分解决失败'),
          description: Text('$e'),
        );
      }
    }

    if (!mounted) return;
    setState(() {
      _conflicts.removeWhere((c) => resolved.contains(c.id));
      resolved.forEach(_selected.remove);
      _resolving = false;
    });
  }

  /// 单条手动合并（改书名）。
  Future<void> _manualMerge(SyncConflict conflict) async {
    if (_resolving) return;
    final local = conflict.localPayload ?? const {};
    final controller = TextEditingController(
      text: local['name'] as String? ?? '',
    );
    final name = await showFDialog<String>(
      context: context,
      builder: (context, style, animate) => FAdaptiveDialog(
        title: const Text('手动合并：新书名'),
        body: FTextFormField(
          label: const Text('新书名'),
          hint: '输入合并后的书名',
          control: FTextFieldControl.managed(controller: controller),
        ),
        actions: [
          FButton(
            variant: .outline,
            size: .sm,
            onPress: () => Navigator.pop(context, null),
            child: const Text('取消'),
          ),
          FButton(
            size: .sm,
            onPress: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty || !mounted) return;

    setState(() => _resolving = true);
    try {
      final sync = ref.read(syncServiceProvider.notifier);
      await sync.resolveConflict(
        conflictId: conflict.id,
        strategy: 'manual',
        payload: {...local, 'name': name},
      );
      await sync.pullOnly();
      if (!mounted) return;
      setState(() {
        _conflicts.removeWhere((c) => c.id == conflict.id);
        _selected.remove(conflict.id);
        _resolving = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _resolving = false);
      showFToast(
        context: context,
        title: const Text('解决失败'),
        description: Text('$e'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FSheetContent.drag(),
        FSheetContent.title(
          context,
          _conflicts.isEmpty ? '已全部解决' : '冲突处理（${_conflicts.length}）',
        ),
        FSheetContent.subTitle(context, '勾选要处理的冲突，再选择保留本地或保留服务器'),
        const SizedBox(height: 8),
        if (_conflicts.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('所有冲突已解决')),
          )
        else ...[
          // 全选
          FButton(
            variant: .outline,
            size: .sm,
            onPress: _resolving ? null : _toggleAll,
            child: Text(_allSelected ? '取消全选' : '全选'),
          ),
          // 冲突列表（勾选）
          Flexible(
            child: FItemGroup(
              children: [
                for (final c in _conflicts)
                  .item(
                    prefix: FCheckbox(
                      value: _selected.contains(c.id),
                      onChange: _resolving ? null : (_) => _toggle(c.id),
                    ),
                    title: Text('本地：${_name(c.localPayload)}'),
                    subtitle: Text('服务器：${_name(c.serverPayload)}'),
                    suffix: FButton.icon(
                      variant: .ghost,
                      onPress: _resolving ? null : () => _manualMerge(c),
                      child: Icon(FLucideIcons.gitMerge),
                    ),
                    onPress: _resolving ? null : () => _toggle(c.id),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 底部批量操作
          Row(
            children: [
              Text(
                '已选 ${_selected.length}',
                style: context.theme.typography.body.sm,
              ),
              const Spacer(),
              FButton(
                variant: .outline,
                size: .sm,
                onPress: _resolving || _selected.isEmpty
                    ? null
                    : () => _resolveSelected('keep_local'),
                child: const Text('保留本地'),
              ),
              const SizedBox(width: 8),
              FButton(
                variant: .destructive,
                size: .sm,
                onPress: _resolving || _selected.isEmpty
                    ? null
                    : () => _resolveSelected('keep_server'),
                child: const Text('保留服务器'),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
