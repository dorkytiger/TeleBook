import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/common/widget/task_item_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/util/url_util.dart';
import 'package:tele_book/feature/download/enum/download_status.dart';
import 'package:tele_book/feature/download/model/bo/download_bo.dart';
import 'package:tele_book/feature/download/service/download_service.dart';
import 'package:tele_book/feature/download/ui/provider/download_provider.dart';
import 'package:tele_book/feature/download/ui/widget/download_task_sheet_widget.dart';

class DownloadListView extends ConsumerWidget {
  const DownloadListView({super.key});

  double _groupProgressPercent(List<DownloadItemBo> items) {
    if (items.isEmpty) return 0;
    final total = items.fold<double>(0, (sum, item) => sum + item.progress);
    return (total / items.length).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(downloadTasksProvider);
    return FScaffold(
      childPad: false,
      header: FHeader(
        title: Text("下载任务"),
        suffixes: [
          FHeaderAction(
            onPress: () async {
              await _clearCompletedTasks(context, ref);
            },
            icon: Icon(FLucideIcons.trash),
          ),

          FHeaderAction(
            onPress: () async {
              await _showDownloadForm(context);
            },
            icon: Icon(FLucideIcons.plus),
          ),
        ],
      ),
      child: state.when(
        loading: () => Center(child: FProgress()),
        error: (e, st) => Center(
          child: CustomErrorWidget(errorMessage: "加载下载任务失败", stackTrace: st),
        ),
        data: (tasks) {
          return tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "暂无下载任务",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : FItemGroup.builder(
                  itemBuilder: (context, index) {
                    final item = tasks[index];
                    final progressPercent = _groupProgressPercent(
                      item.downloadItemBoList,
                    );
                    return TaskItemWidget(
                      title: item.downloadGroupBo.name,
                      coverUrl: item.downloadItemBoList.first.url,
                      status: item.downloadGroupBo.status.description,
                      progress: progressPercent,
                      onTap: () => _showDownloadTaskList(
                        context,
                        item.downloadGroupBo.id,
                        item.downloadGroupBo.name,
                        ref,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 已全部下载成功并保存为书籍 → 显示对勾，不再提供操作菜单
                          if (item.downloadGroupBo.savedToBook)
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(
                                FLucideIcons.check,
                                color: Colors.green,
                              ),
                            )
                          else
                            _DownloadGroupMenu(
                              onRetry: () =>
                                  _retryGroup(context, ref, item.downloadGroupBo),
                              onDelete: () =>
                                  _deleteGroup(context, ref, item.downloadGroupBo),
                            ),
                        ],
                      ),
                    );
                  },
                  count: tasks.length,
                );
        },
      ),
    );
  }

  Future<void> _clearCompletedTasks(BuildContext context, WidgetRef ref) async {
    final tasks = await ref.read(downloadTasksProvider.future);
    final hasCompleted = tasks.any(
      (group) => group.downloadGroupBo.status == DownloadStatus.completed,
    );
    if (!hasCompleted) {
      if (!context.mounted) return;
      showFToast(context: context, title: Text('没有可清空的已完成任务'));
      return;
    }

    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (dialogContext, style, animate) => FDialog.adaptive(
        style: style,
        animation: animate,
        horizontalBuilder: (context, style) =>
            Text('清空已完成任务', style: style.titleTextStyle),
        verticalBuilder: (context, style) =>
            Text('将移除所有已完成的下载任务组及其临时文件，是否继续？', style: style.bodyTextStyle),
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final clearedCount = await ref
          .read(downloadServiceProvider)
          .clearCompletedTasks();
      if (!context.mounted) return;
      showFToast(context: context, title: Text('已清空 $clearedCount 个已完成任务'));
    } catch (e) {
      if (!context.mounted) return;
      showFToast(
        context: context,
        title: Text("清楚失败"),
        description: Text(e.toString()),
      );
    }
  }

  void _showDownloadTaskList(
    BuildContext context,
    String groupId,
    String name,
    WidgetRef ref,
  ) {
    showFSheet(
      context: context,
      side: .btt,
      builder: (_) => DownloadTaskSheetWidget(groupId: groupId,name: name,),
    );
  }

  Future<void> _showDownloadForm(BuildContext context) async {
    final urlController = TextEditingController();
    final url = await showFSheet<String>(
      context: context,
      side: .btt,
      style: const .delta(flingVelocity: 700),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: context.theme.colors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            border: .symmetric(
              horizontal: BorderSide(color: context.theme.colors.border),
            ),
          ),
          child: Padding(
            padding: .all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "下载链接",
                  style: context.theme.typography.display.xl2.copyWith(
                    fontWeight: .w600,
                    color: context.theme.colors.foreground,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '要下载的网页图片链接，如https://www.google.com',
                  style: context.theme.typography.body.sm.copyWith(
                    color: context.theme.colors.mutedForeground,
                  ),
                ),
                SizedBox(height: 16),
                FTextFormField(
                  control: FTextFieldControl.managed(controller: urlController),
                  label: Text("URL"),
                  hint: "请输入网址URL",
                  suffixBuilder: (context, style, _) {
                    return FButton.icon(
                      onPress: () async {
                        final clipData = await Clipboard.getData(
                          Clipboard.kTextPlain,
                        );
                        if (clipData?.text != null) {
                          urlController.text = clipData!.text!;
                        }
                      },
                      child: Icon(FLucideIcons.clipboardPaste),
                      style: style.obscureButtonStyle,
                    );
                  },
                ),
                Padding(
                  padding: .symmetric(vertical: 16),
                  child: FButton(
                    onPress: () {
                      context.pop<String>(urlController.text);
                    },
                    child: Text("解析"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (url != null && url.isNotEmpty) {
      if (!context.mounted) return;
      final uri = normalizeWebUrl(url);
      if (uri == null) {
        showFToast(context: context, title: Text('网址无效，请检查格式'));
        return;
      }
      await context.push(AppRoute.parseWeb, extra: uri.toString());
    }
  }

  /// 重试整个下载组：重新下载组内所有任务
  Future<void> _retryGroup(
    BuildContext context,
    WidgetRef ref,
    DownloadGroupBo group,
  ) async {
    try {
      await ref.read(downloadServiceProvider).retryGroup(group.id);
      if (!context.mounted) return;
      showFToast(context: context, title: Text('已重新下载：${group.name}'));
    } catch (e) {
      if (!context.mounted) return;
      showFToast(
        context: context,
        title: Text('重试失败'),
        description: Text(e.toString()),
      );
    }
  }

  /// 删除整个下载组（含临时文件）
  Future<void> _deleteGroup(
    BuildContext context,
    WidgetRef ref,
    DownloadGroupBo group,
  ) async {
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (dialogContext, style, animate) => FDialog.adaptive(
        style: style,
        animation: animate,
        horizontalBuilder: (context, style) =>
            Text('删除下载组', style: style.titleTextStyle),
        verticalBuilder: (context, style) => Text(
          '将删除"${group.name}"及其所有临时文件，是否继续？',
          style: style.bodyTextStyle,
        ),
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(downloadServiceProvider).deleteGroup(group.id);
      if (!context.mounted) return;
      showFToast(context: context, title: Text('已删除下载组'));
    } catch (e) {
      if (!context.mounted) return;
      showFToast(
        context: context,
        title: Text('删除失败'),
        description: Text(e.toString()),
      );
    }
  }
}

/// 下载组操作菜单（重试 / 删除）。
///
/// 使用独立的 [FPopoverController] 并在菜单项点击后手动隐藏，
/// 因为 forui 的菜单项点击不会自动关闭 popover。
class _DownloadGroupMenu extends StatefulWidget {
  final VoidCallback onRetry;
  final VoidCallback onDelete;

  const _DownloadGroupMenu({required this.onRetry, required this.onDelete});

  @override
  State<_DownloadGroupMenu> createState() => _DownloadGroupMenuState();
}

class _DownloadGroupMenuState extends State<_DownloadGroupMenu>
    with SingleTickerProviderStateMixin {
  late final FPopoverController _controller = FPopoverController(vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FPopoverMenu(
      control: FPopoverControl.managed(controller: _controller),
      menu: [
        .group(
          children: [
            .item(
              prefix: const Icon(FLucideIcons.refreshCw),
              title: const Text('重试'),
              onPress: () {
                _controller.hide();
                widget.onRetry();
              },
            ),
            .item(
              variant: .destructive,
              prefix: const Icon(FLucideIcons.trash),
              title: const Text('删除'),
              onPress: () {
                _controller.hide();
                widget.onDelete();
              },
            ),
          ],
        ),
      ],
      builder: (context, controller, child) {
        return FButton.icon(
          variant: .ghost,
          onPress: () => controller.show(),
          child: const Icon(FLucideIcons.moreHorizontal),
        );
      },
    );
  }
}
