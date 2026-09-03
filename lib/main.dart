import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/util/app_log.dart';
import 'package:tele_book/core/util/crash_guard.dart';
import 'package:tele_book/core/util/lifecycle_log_observer.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _init();

    runApp(appProviders);
  }, CrashGuard.zoneError);
}

/// 全局 providers，在 runApp 中使用
late Widget appProviders;

Future<void> _init() async {
  await GlobalConfig.init();
  // 诊断日志系统：统一落盘目录 + 崩溃捕获（须在 runApp 前装好）
  await AppLog.init();
  CrashGuard.install();
  // 前后台切换日志（排查熄屏后台同步是否推进）
  WidgetsBinding.instance
      .addObserver(LifecycleLogObserver());
  AppLog.i('App 启动，日志系统就绪', tag: 'BOOT');
  // 启动后台缓存清理，不阻塞启动流程
  GlobalConfig.cleanCacheOnStartup();

  final isMobile = const <TargetPlatform>{
    .android,
    .iOS,
    .fuchsia,
  }.contains(defaultTargetPlatform);

  // 商业蓝品牌主题：基于 FTheme.neutral 派生，仅替换主色，其余样式自动继承。
  final (lightTheme, darkTheme) = (
    _buildBrandTheme(
      base: isMobile ? FTheme.neutral.light.touch : FTheme.neutral.light.desktop,
      touch: isMobile,
      primary: const Color(0xFF2563EB),
      primaryForeground: Colors.white,
    ),
    _buildBrandTheme(
      base: isMobile ? FTheme.neutral.dark.touch : FTheme.neutral.dark.desktop,
      touch: isMobile,
      primary: const Color(0xFF60A5FA),
      primaryForeground: const Color(0xFF0F172A),
    ),
  );

  appProviders = ProviderScope(
    child: MaterialApp.router(
      title: 'tele_book',
      routerConfig: AppRoute.router,
      debugShowCheckedModeBanner: false,
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: const [...FLocalizations.localizationsDelegates],
      theme: lightTheme.toApproximateMaterialTheme(),
      darkTheme: darkTheme.toApproximateMaterialTheme(),
      themeMode: ThemeMode.system,
      builder: (context, child) => FTheme(
        data: Theme.brightnessOf(context) == .light ? lightTheme : darkTheme,
        child: FToaster(child: FTooltipGroup(child: child!)),
      ),
    ),
  );
}

/// 基于 ForUI 基础主题构建品牌主题（商业蓝），仅替换主色，其余组件样式自动继承。
FThemeData _buildBrandTheme({
  required FThemeData base,
  required bool touch,
  required Color primary,
  required Color primaryForeground,
}) =>
    FThemeData(
      debugLabel: 'brand-blue',
      touch: touch,
      colors: base.colors.copyWith(
        primary: primary,
        primaryForeground: primaryForeground,
      ),
    );
