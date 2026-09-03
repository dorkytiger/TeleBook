import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:tele_book/common/widget/f_sheet_content.dart';
import 'package:tele_book/feature/sync/service/conflict_resolver_service.dart';
import 'package:tele_book/feature/sync/service/local_conflict_service.dart';
import 'package:tele_book/feature/sync/ui/view/conflict_choose_sheet.dart';

/// 待处理本地冲突列表（§7 / P0-1）：底栏「存在冲突 N」点击后弹出。
///
/// 每行点开 [showConflictChooseSheet] 选择保留服务器 / 保留本地：
/// 选择即作为**组任务**入队执行（进度在队列/全局通知体现），本弹层用
/// 行内 loading 占位并等待执行结束 → 成功行自动消失（冲突被 resolve），
/// 失败弹 toast 且冲突保留（可再次选择重试）。
Future<void> showLocalConflictSheet(BuildContext context) {
  return showFSheet(
    context: context,
    side: .btt,
    mainAxisMaxRatio: 0.85,
    builder: (context) => FSheetContent(
      side: .btt,
      child: const _LocalConflictSheetBody(),
    ),
  );
}

class _LocalConflictSheetBody extends ConsumerStatefulWidget {
  const _LocalConflictSheetBody();

  @override
  ConsumerState<_LocalConflictSheetBody> createState() =>
      _LocalConflictSheetBodyState();
}

class _LocalConflictSheetBodyState
    extends ConsumerState<_LocalConflictSheetBody> {
  /// 正在执行解决动作的 uuid（行内 loading，防重复点击）。
  final Set<String> _resolving = {};

  /// 对某个冲突执行解决动作并等待队列执行完（成功才 resolve，行消失）。
  Future<void> _resolve(LocalConflict conflict) async {
    if (_resolving.contains(conflict.uuid)) return;
    final choice = await showConflictChooseSheet(
      context,
      bookName: conflict.name,
    );
    if (!mounted || choice == null) return; // 跳过：留在列表

    final resolver = ref.read(conflictResolverServiceProvider);
    setState(() => _resolving.add(conflict.uuid));
    try {
      final ok = choice
          ? await resolver.keepServer(conflict)
          : await resolver.keepLocal(conflict);
      if (!mounted) return;
      showFToast(
        context: context,
        title: Text(ok ? '已${choice ? '保留服务器版本' : '保留本地版本'}' : '处理失败，可重试'),
      );
    } catch (e) {
      if (!mounted) return;
      showFToast(
        context: context,
        title: const Text('处理失败'),
        description: Text('$e'),
      );
    } finally {
      if (mounted) setState(() => _resolving.remove(conflict.uuid));
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(localConflictServiceProvider);
    return ValueListenableBuilder<List<LocalConflict>>(
      valueListenable: service.pending,
      builder: (context, conflicts, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FSheetContent.drag(),
            FSheetContent.title(
              context,
              conflicts.isEmpty ? '冲突已全部解决' : '冲突处理（${conflicts.length}）',
            ),
            FSheetContent.subTitle(
              context,
              '以下书籍在本设备与服务器内容不一致，请选择保留哪一版',
            ),
            const SizedBox(height: 8),
            if (conflicts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('所有冲突已解决')),
              )
            else
              Flexible(
                child: FItemGroup(
                  children: [
                    for (final c in conflicts)
                      .item(
                        prefix: Icon(
                          FLucideIcons.alertTriangle,
                          color: context.theme.colors.destructive,
                        ),
                        title: Text(c.name),
                        subtitle: const Text('内容不一致 · 点击选择保留哪一版'),
                        suffix: _resolving.contains(c.uuid)
                            ? const FCircularProgress(size: .sm)
                            : const Icon(FLucideIcons.chevronRight),
                        onPress: _resolving.contains(c.uuid)
                            ? null
                            : () => _resolve(c),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
