import 'package:dk_util/config/dk_config.dart';
import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/core/di/app_di.dart';
import 'package:tele_book/core/route/app_route.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:tele_book/common/theme/app_theme.dart';
import 'package:tele_book/core/util/file_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _init();

  runApp(appProviders);
}

/// 全局 providers，在 runApp 中使用
late Widget appProviders;

Future<void> _init() async {
  await FileUtil.init();
  await DKLog.initFileLog();
  DkConfig.setShowStateLog(true);

  appProviders = MultiProvider(
    providers: [...createAppDI()],
    child: MaterialApp.router(
      title: 'TeleBook',
      routerConfig: AppRoute.router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 480, name: MOBILE),
          const Breakpoint(start: 481, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1200, name: DESKTOP),
          const Breakpoint(start: 1201, end: double.infinity, name: '4K'),
        ],
      ),
    ),
  );
}
