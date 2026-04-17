import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tele_book/app/util/html_util.dart';
import 'package:tele_book/app/util/pick_file_util.dart';
import 'package:tele_book/app/widget/cross_platform_webview.dart';

class ParseWebController extends ChangeNotifier {
  final String parseUrl;

  late final CrossPlatformWebViewController webViewController;
  int selectBar = 0;
  int parseProgress = 0;
  List<String> images = <String>[];
  String title = '';
  DKStateEvent<void> parseState = DKStateEventIdle();
  DKStateEvent<void> saveImageState = DKStateEventIdle();

  ParseWebController({required this.parseUrl}) {
    _initWebView();
  }

  void _initWebView() {
    webViewController = CrossPlatformWebViewController(initialUrl: parseUrl);
    webViewController.setNavigationDelegate(
      onProgress: (int progress) {
        parseProgress = progress;
        notifyListeners();
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {
        _handlePageFinished(url);
      },
      onConsoleMessage: (String message) {
        debugPrint('WebView Console: $message');
      },
    );

    webViewController.clearCache();
    webViewController.loadUrl();
  }

  Future<void> _handlePageFinished(String url) async {
    await DKStateEventHelper.triggerEvent<void>(
      onStateChange: (value) {
        parseState = value;
        notifyListeners();
      },
      event: () async {
        final parseTitle = await HtmlUtil.extractTitleFromWebView(
          webViewController,
        );
        final parseImages = await HtmlUtil.extractImagesFromWebView(
          webViewController,
        );
        title = parseTitle;
        images = parseImages;
        notifyListeners();
      },
    );
  }

  Future<void> copyImageUrl(String url, BuildContext context) async {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('图片链接已复制到剪贴板')));
  }

  Future<void> saveImageTo(String url) async {
    await DKStateEventHelper.triggerEvent(
      onStateChange: (value) {
        saveImageState = value;
        notifyListeners();
      },
      event: () async {
        final saveDirectory = await PickFileUtil.pickDirectory();
        if (saveDirectory == null) {
          return;
        }
        await HtmlUtil.downloadImageToFile(url, saveDirectory);
      },
    );
  }
}
