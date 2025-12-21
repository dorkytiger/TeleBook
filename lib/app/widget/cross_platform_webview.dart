import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;

/// 跨平台 WebView 包装器
/// 在 Windows 平台使用 flutter_inappwebview
/// 在其他平台使用 webview_flutter
class CrossPlatformWebView extends StatefulWidget {
  final CrossPlatformWebViewController controller;

  const CrossPlatformWebView({
    super.key,
    required this.controller,
  });

  @override
  State<CrossPlatformWebView> createState() => _CrossPlatformWebViewState();
}

class _CrossPlatformWebViewState extends State<CrossPlatformWebView> {
  @override
  Widget build(BuildContext context) {
    // Windows 平台使用 InAppWebView
    if (kIsWeb || Platform.isWindows) {
      return InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.controller.initialUrl)),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          useHybridComposition: true,
          clearCache: true,
        ),
        onWebViewCreated: (controller) {
          widget.controller._inAppWebViewController = controller;
        },
        onProgressChanged: (controller, progress) {
          widget.controller._onProgress?.call(progress);
        },
        onLoadStart: (controller, url) {
          widget.controller._onPageStarted?.call(url?.toString() ?? '');
        },
        onLoadStop: (controller, url) {
          widget.controller._onPageFinished?.call(url?.toString() ?? '');
        },
        onReceivedError: (controller, request, error) {
          debugPrint('WebView 错误: ${error.description}');
        },
        onConsoleMessage: (controller, consoleMessage) {
          widget.controller._onConsoleMessage
              ?.call(consoleMessage.message.toString());
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final url = navigationAction.request.url?.toString() ?? '';
          final uri = Uri.parse(url);

          // 阻止非标准 scheme
          if (uri.scheme != 'http' && uri.scheme != 'https') {
            debugPrint('阻止打开非标准 scheme: $url');
            return NavigationActionPolicy.CANCEL;
          }

          return NavigationActionPolicy.ALLOW;
        },
      );
    }

    // 其他平台使用 webview_flutter
    return webview_flutter.WebViewWidget(
      controller: widget.controller._webViewController!,
    );
  }
}

/// 跨平台 WebView 控制器
class CrossPlatformWebViewController {
  final String initialUrl;
  webview_flutter.WebViewController? _webViewController;
  InAppWebViewController? _inAppWebViewController;

  Function(int progress)? _onProgress;
  Function(String url)? _onPageStarted;
  Function(String url)? _onPageFinished;
  Function(String message)? _onConsoleMessage;

  CrossPlatformWebViewController({required this.initialUrl}) {
    // 如果不是 Windows，初始化 webview_flutter
    if (!kIsWeb && !Platform.isWindows) {
      _webViewController = webview_flutter.WebViewController()
        ..setJavaScriptMode(webview_flutter.JavaScriptMode.unrestricted)
        ..enableZoom(false)
        ..clearCache()
        ..clearLocalStorage();
    }
  }

  /// 设置导航代理
  void setNavigationDelegate({
    Function(int progress)? onProgress,
    Function(String url)? onPageStarted,
    Function(String url)? onPageFinished,
    Function(String message)? onConsoleMessage,
  }) {
    _onProgress = onProgress;
    _onPageStarted = onPageStarted;
    _onPageFinished = onPageFinished;
    _onConsoleMessage = onConsoleMessage;

    if (_webViewController != null) {
      _webViewController!.setNavigationDelegate(
        webview_flutter.NavigationDelegate(
          onProgress: (int progress) {
            _onProgress?.call(progress);
          },
          onPageStarted: (String url) {
            _onPageStarted?.call(url);
          },
          onPageFinished: (String url) {
            _onPageFinished?.call(url);
          },
          onWebResourceError: (webview_flutter.WebResourceError error) {
            debugPrint('WebView资源错误: ${error.description}');
          },
          onNavigationRequest: (webview_flutter.NavigationRequest request) {
            final uri = Uri.parse(request.url);

            if (uri.scheme != 'http' && uri.scheme != 'https') {
              debugPrint('阻止打开非标准 scheme: ${request.url}');
              return webview_flutter.NavigationDecision.prevent;
            }

            return webview_flutter.NavigationDecision.navigate;
          },
        ),
      );
      _webViewController!.setOnConsoleMessage((message) {
        _onConsoleMessage?.call(message.message);
      });
    }
  }

  /// 加载 URL
  Future<void> loadUrl() async {
    if (_webViewController != null) {
      await _webViewController!.loadRequest(Uri.parse(initialUrl));
    }
    // InAppWebView 在创建时已加载
  }

  /// 清除缓存
  Future<void> clearCache() async {
    if (_webViewController != null) {
      await _webViewController!.clearCache();
      await _webViewController!.clearLocalStorage();
    } else if (_inAppWebViewController != null) {
      await _inAppWebViewController!.clearCache();
    }
  }

  /// 运行 JavaScript 并返回结果
  Future<String?> runJavaScriptReturningResult(String javascript) async {
    if (_webViewController != null) {
      final result =
          await _webViewController!.runJavaScriptReturningResult(javascript);
      return result?.toString();
    } else if (_inAppWebViewController != null) {
      final result =
          await _inAppWebViewController!.evaluateJavascript(source: javascript);
      return result?.toString();
    }
    return null;
  }

  /// 执行 JavaScript（不返回结果）
  Future<void> runJavaScript(String javascript) async {
    if (_webViewController != null) {
      await _webViewController!.runJavaScript(javascript);
    } else if (_inAppWebViewController != null) {
      await _inAppWebViewController!.evaluateJavascript(source: javascript);
    }
  }

  /// 获取当前 URL
  Future<String?> currentUrl() async {
    if (_webViewController != null) {
      return await _webViewController!.currentUrl();
    } else if (_inAppWebViewController != null) {
      final url = await _inAppWebViewController!.getUrl();
      return url?.toString();
    }
    return null;
  }

  /// 后退
  Future<void> goBack() async {
    if (_webViewController != null) {
      if (await _webViewController!.canGoBack()) {
        await _webViewController!.goBack();
      }
    } else if (_inAppWebViewController != null) {
      if (await _inAppWebViewController!.canGoBack()) {
        await _inAppWebViewController!.goBack();
      }
    }
  }

  /// 前进
  Future<void> goForward() async {
    if (_webViewController != null) {
      if (await _webViewController!.canGoForward()) {
        await _webViewController!.goForward();
      }
    } else if (_inAppWebViewController != null) {
      if (await _inAppWebViewController!.canGoForward()) {
        await _inAppWebViewController!.goForward();
      }
    }
  }

  /// 重新加载
  Future<void> reload() async {
    if (_webViewController != null) {
      await _webViewController!.reload();
    } else if (_inAppWebViewController != null) {
      await _inAppWebViewController!.reload();
    }
  }
}

