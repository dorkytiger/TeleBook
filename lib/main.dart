import 'package:dk_util/config/dk_config.dart';
import 'package:dk_util/dk_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/common/config/global_config.dart';
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
WebViewEnvironment? webViewEnvironment;

Future<void> _init() async {
  await FileUtil.init();
  await DKLog.initFileLog();
  DkConfig.setShowStateLog(true);
  await GlobalConfig.init();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    final availableVersion = await WebViewEnvironment.getAvailableVersion();
    assert(
      availableVersion != null,
      'Failed to find an installed WebView2 Runtime or non-stable Microsoft Edge installation.',
    );

    webViewEnvironment = await WebViewEnvironment.create(
      settings: WebViewEnvironmentSettings(userDataFolder: 'YOUR_CUSTOM_PATH'),
    );
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

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
