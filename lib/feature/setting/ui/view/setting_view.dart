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

    final itemList = [
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
      FItem(
        title: const Text('同步服务器'),
        subtitle: const Text('多设备书库同步'),
        prefix: const Icon(FLucideIcons.server),
        suffix: const Icon(FLucideIcons.chevronRight),
        onPress: () => context.push(AppRoute.syncServer),
      ),
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
    ];

    return FScaffold(
      childPad: false,
      header: FHeader(title: Text("设置")),
      child: FItemGroup.builder(
        count: itemList.length,
        itemBuilder: (context, index) {
          return itemList[index];
        },
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
