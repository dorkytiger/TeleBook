import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tele_book/common/widget/f_adaptive_dialog.dart';
import 'package:tele_book/common/widget/f_sheet_content.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/service/package_info_service.dart';
import 'package:tele_book/core/service/version_service.dart';
import 'package:tele_book/feature/setting/enum/setting_key_value.dart';
import 'package:tele_book/feature/setting/ui/provider/setting_provider.dart';
import 'package:tele_book/feature/sync/service/init_sync_service.dart';
import 'package:tele_book/feature/sync/service/sync_op_service.dart';
import 'package:tele_book/feature/sync/service/upload_snapshot_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingView extends ConsumerStatefulWidget {
  const SettingView({super.key});

  @override
  ConsumerState<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends ConsumerState<SettingView> {
  /// 检查更新进行中：点击后 suffix 显示加载转圈，期间禁用重复点击。
  bool _checkingUpdate = false;

  @override
  Widget build(BuildContext context) {
    final readingDirectionSetting = ref.watch(readingDirectionSettingProvider);
    final packInfo = ref.watch(packageInfoServiceProvider);
    final syncConfigured = ref.watch(syncConfiguredProvider).value ?? false;

    return FScaffold(
      childPad: false,
      header: FHeader(title: Text("设置")),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── 基本设置 ──
          _groupTitle('基本设置'),
          FItemGroup(
            children: [
              FItem(
                title: const Text('阅读顺序'),
                subtitle: readingDirectionSetting.when(
                  data: (d) => Text(d.label),
                  loading: () => const SizedBox.shrink(),
                  error: (e, st) => const Text('读取失败'),
                ),
                prefix: const Icon(FLucideIcons.eye),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: () => _showReadingDirectionSheet(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── 服务器（未初始化时只显示「初始化服务器」）──
          _groupTitle('服务器'),
          FItemGroup(
            children: [
              FItem(
                title: Text(syncConfigured ? '重新初始化服务器' : '初始化服务器'),
                subtitle: Text(
                  syncConfigured ? '更换服务器或连接配置' : '填写地址与密钥并连接',
                ),
                prefix: const Icon(FLucideIcons.server),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: () => context.push(AppRoute.syncServer),
              ),
              // 已初始化服务器后才有同步功能
              if (syncConfigured) ...[
                FItem(
                  title: const Text('刷新同步'),
                  subtitle: const Text('拉取服务器最新变更'),
                  prefix: const Icon(FLucideIcons.refreshCw),
                  suffix: const Icon(FLucideIcons.chevronRight),
                  onPress: _refreshSync,
                ),
                FItem(
                  title: const Text('上传快照'),
                  subtitle: const Text('上传当前书籍快照到服务器'),
                  prefix: const Icon(FLucideIcons.uploadCloud),
                  suffix: const Icon(FLucideIcons.chevronRight),
                  onPress: _uploadSnapshot,
                ),
                FItem(
                  title: const Text('历史记录'),
                  subtitle: const Text('查看同步归档，可恢复到归档时刻'),
                  prefix: const Icon(FLucideIcons.history),
                  suffix: const Icon(FLucideIcons.chevronRight),
                  onPress: () => context.push(AppRoute.syncHistory),
                ),
                FItem(
                  title: const Text('本地同步记录'),
                  subtitle: const Text('查看每次同步任务与进度'),
                  prefix: const Icon(FLucideIcons.list),
                  suffix: const Icon(FLucideIcons.chevronRight),
                  onPress: () => context.push(AppRoute.syncLogList),
                ),
              ],
            ],
          ),

          const SizedBox(height: 20),

          // ── 其他 ──
          _groupTitle('其他'),
          FItemGroup(
            children: [
              FItem(
                title: const Text('当前版本与更新'),
                subtitle: packInfo.when(
                  data: (data) => Text('当前版本：${data.version}'),
                  error: (s, t) => Text("加载失败"),
                  loading: () => SizedBox.shrink(),
                ),
                prefix: const Icon(FLucideIcons.arrowUpFromLine),
                suffix: _checkingUpdate
                    ? const FCircularProgress(size: .sm)
                    : const Icon(FLucideIcons.chevronRight),
                onPress: _checkingUpdate ? null : _checkUpdate,
              ),
              FItem(
                title: const Text('关于'),
                subtitle: const Text('TeleBook · MIT License'),
                prefix: const Icon(FLucideIcons.info),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: _showAboutDialog,
              ),
              FItem(
                title: const Text('联系作者'),
                subtitle: const Text('dorkytiger'),
                prefix: const Icon(FLucideIcons.mail),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: _showContactDialog,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── 调试（临时）──
          _groupTitle('调试'),
          FItemGroup(
            children: [
              FItem(
                title: const Text('同步后台日志'),
                subtitle: const Text('查看 sync_bg.log（熄屏后台调试用）'),
                prefix: const Icon(FLucideIcons.fileText),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: () => context.push(AppRoute.syncFileLog),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 分组小标题。
  Widget _groupTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: context.theme.typography.body.md.copyWith(
          color: context.theme.colors.mutedForeground,
        ),
      ),
    );
  }

  /// 阅读方向对应的图标：从左到右 / 从右到左 / 从上到下。
  IconData _directionIcon(ReadingDirection dir) => switch (dir) {
        ReadingDirection.leftToRight => FLucideIcons.arrowRight,
        ReadingDirection.rightToLeft => FLucideIcons.arrowLeft,
        ReadingDirection.topToBottom => FLucideIcons.arrowDown,
      };

  /// 阅读顺序底部弹层：从左到右 / 上到下 / 右到左
  void _showReadingDirectionSheet(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(readingDirectionSettingProvider.notifier);
    showFSheet(
      context: context,
      side: .btt,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final dir = ref.watch(readingDirectionSettingProvider);
          return FSheetContent(
            side: .btt,
            child: dir.when(
              data: (data) => Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  FSheetContent.title(context, '阅读顺序'),
                  for (final dir in ReadingDirection.values)
                    FItem(

                      prefix: Icon(_directionIcon(dir)),
                      title: Text(dir.label),
                      suffix: dir == data
                          ? const Icon(FLucideIcons.check)
                          : null,
                      onPress: () {
                        notifier.set(dir);
                        context.pop();
                      },
                    ),
                ],
              ),
              error: (e, s) => Center(
                child: FAlert(
                  title: Text("获取失败"),
                  subtitle: Text(e.toString(), maxLines: 2),
                ),
              ),
              loading: () => Center(child: FCircularProgress()),
            ),
          );
        },
      ),
    );
  }

  /// 关于对话框：图标 / 名称 / 版本 / 简介 / 开源许可 / 项目主页。
  Future<void> _showAboutDialog() async {
    final info = await ref.read(packageInfoServiceProvider.future);
    if (!mounted) return;
    await showFDialog<void>(
      context: context,
      builder: (dialogContext, style, animate) => FAdaptiveDialog(
        title: const Text('关于 TeleBook'),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/icon/logo.png',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TeleBook', style: style.titleTextStyle),
                      const SizedBox(height: 2),
                      Text(
                        '版本 ${info.version} (${info.buildNumber})',
                        style: style.bodyTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '跨平台图书解析、管理与阅读应用。'
              '支持多种导入方式、智能书库管理、多设备同步与个性化阅读体验。',
              style: style.bodyTextStyle,
            ),
            const SizedBox(height: 12),
            Text(
              '开源许可：MIT License',
              style: style.bodyTextStyle,
            ),
            const SizedBox(height: 8),
            FButton(
              variant: .ghost,
              size: .sm,
              prefix: const Icon(FLucideIcons.globe, size: 16),
              onPress: () async {
                await launchUrl(
                  Uri.parse('https://github.com/dorkytiger/TeleBook'),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: const Text('项目主页'),
            ),
          ],
        ),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => dialogContext.pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  /// 联系作者对话框：作者名 + 邮箱，可一键发送邮件。
  Future<void> _showContactDialog() async {
    await showFDialog<void>(
      context: context,
      builder: (dialogContext, style, animate) => FAdaptiveDialog(
        title: const Text('联系作者'),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  FLucideIcons.userRound,
                  size: 40,
                  color: context.theme.colors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('dorkytiger', style: style.titleTextStyle),
                      const SizedBox(height: 2),
                      Text(
                        'dorkytiger@icloud.com',
                        style: style.bodyTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '如有问题、建议或反馈，欢迎发送邮件联系作者。',
              style: style.bodyTextStyle,
            ),
          ],
        ),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => dialogContext.pop(),
            child: const Text('关闭'),
          ),
          FButton(
            onPress: () async {
              await launchUrl(
                Uri(scheme: 'mailto', path: 'dorkytiger@icloud.com'),
                mode: LaunchMode.externalApplication,
              );
            },
            child: const Text('发送邮件'),
          ),
        ],
      ),
    );
  }

  /// 刷新同步：初始化同步的手动调用（§2.2，逻辑同初始化，组任务类型=refresh）。
  Future<void> _refreshSync() async {
    // 防连点：已有初始化/刷新任务在跑或排队时不再重复入队
    final ops = ref.read(syncOpServiceProvider);
    if (await ops.hasActiveOfType(SyncOpType.refresh) ||
        await ops.hasActiveOfType(SyncOpType.init)) {
      if (!mounted) return;
      showFToast(context: context, title: const Text('刷新同步已在队列中，请稍候'));
      return;
    }
    try {
      await ref.read(initSyncServiceProvider).run(opType: SyncOpType.refresh);
      if (!mounted) return;
      showFToast(context: context, title: const Text('刷新完成'));
    } catch (e) {
      if (!mounted) return;
      showFToast(
        context: context,
        title: const Text('刷新失败'),
        description: Text(
          _shortError(e),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }

  /// 上传当前书库快照到服务器（§2.3）：确认后再入队一组任务，全局通知显示。
  Future<void> _uploadSnapshot() async {
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (context, style, animate) => FAdaptiveDialog(
        title: const Text('上传快照'),
        body: const Text(
          '把当前书库快照上传到服务器历史记录？\n'
          '不会改动服务器上的当前书库，其他设备也看不到这次快照。',
        ),
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
            child: const Text('上传'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(uploadSnapshotServiceProvider).upload();
      if (!mounted) return;
      showFToast(context: context, title: const Text('已加入队列，可在底部查看进度'));
    } catch (e) {
      if (!mounted) return;
      showFToast(
        context: context,
        title: const Text('上传快照失败'),
        description: Text(
          _shortError(e),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }

  /// 异常 → 短文案（防止长 DioException 撑爆 toast）。
  static String _shortError(Object e) {
    final s = e.toString();
    if (s.length <= 120) return s;
    return '${s.substring(0, 120)}…';
  }

  /// 检查更新：请求 GitHub 最新版，与本地比较，弹 forui 对话框。
  /// 请求期间 suffix 显示加载转圈，完成后恢复。
  Future<void> _checkUpdate() async {
    if (_checkingUpdate) return;
    setState(() => _checkingUpdate = true);
    try {
      final info = await ref.read(versionServiceProvider.future);
      final localVersion = (await PackageInfo.fromPlatform()).version;
      if (!mounted) return;

      if (info == null) {
        showFToast(context: context, title: const Text('检查更新失败，请稍后再试'));
        return;
      }

      if (!VersionService.isNewer(info.version, localVersion)) {
        showFToast(context: context, title: const Text('已是最新版本'));
        return;
      }

      await showFDialog<void>(
        context: context,
        builder: (dialogContext, style, animate) => FDialog.adaptive(
          style: style,
          animation: animate,
          horizontalBuilder: (context, style) =>
              _buildUpdateContent(context, style, info),
          verticalBuilder: (context, style) =>
              _buildUpdateContent(context, style, info),
        ),
      );
    } finally {
      if (mounted) setState(() => _checkingUpdate = false);
    }
  }

  Widget _buildUpdateContent(
    BuildContext context,
    FDialogStyle style,
    UpdateInfo info,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('发现新版本 v${info.version}', style: style.titleTextStyle),
          const SizedBox(height: 8),
          // 更新日志过长时截断/滚动
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240),
            child: SingleChildScrollView(
              child: Text(info.notes ?? '暂无更新说明', style: style.bodyTextStyle),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FButton(
                variant: .ghost,
                onPress: () => context.pop(),
                child: const Text('以后再说'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FButton(
                  onPress: () async {
                    context.pop();
                    await launchUrl(
                      Uri.parse(info.url),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: const Text('立即更新'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
