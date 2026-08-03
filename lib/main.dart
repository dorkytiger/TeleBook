import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/common/theme/app_theme.dart';
import 'package:tele_book/core/route/app_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _init();

  runApp(appProviders);
}

/// 全局 providers，在 runApp 中使用
late Widget appProviders;
WebViewEnvironment? webViewEnvironment;

Future<void> _init() async {
  await GlobalConfig.init();
  // 启动后台缓存清理，不阻塞启动流程
  GlobalConfig.cleanCacheOnStartup();

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

  final (lightTheme, darkTheme) =
      const <TargetPlatform>{
        .android,
        .iOS,
        .fuchsia,
      }.contains(defaultTargetPlatform)
      ? (FTheme.neutral.light.touch, FTheme.neutral.dark.touch)
      : (FTheme.neutral.light.desktop, FTheme.neutral.dark.desktop);

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
