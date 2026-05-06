import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/download/service/download_service.dart';
import 'package:tele_book/feature/home/repository/home_repository.dart';
import 'package:tele_book/feature/pase/service/parse_web_service.dart';
import 'package:tele_book/feature/task/repository/task_repository.dart';

class ParseWebViewmodel extends ChangeNotifier {
  final ParseWebService _parseWebService;
  final DownloadService _downloadService;
  final HomeRepository _homeRepository;
  final TaskRepository _taskRepository;

  ParseWebViewmodel(this._parseWebService, this._downloadService, this._homeRepository, this._taskRepository);

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );
  String title = "加载中...";
  List<String> urls = [];
  int progress = 0;

  void onLoadStart(InAppWebViewController controller) {
    webViewController = controller;
    notifyListeners();
  }

  void onTitleChanged(InAppWebViewController controller, String? title) {
    this.title = title ?? "无标题";
    print("提取到的标题: $title");
    notifyListeners();
  }

  void onProgressChange(InAppWebViewController controller, int progress) async {
    final urls = await _parseWebService.extractImagesFromWebView(
      onExtractImages: (js) async {
        final urls = await controller.evaluateJavascript(source: js);
        return urls;
      },
    );
    this.urls = urls;
    this.progress = progress;
    notifyListeners();
  }

  void startDownload(BuildContext context) {
    if (urls.isEmpty) return;
    _downloadService.startDownload(urls, title);
    context.go(AppRoute.home);
    _homeRepository.updateTabIndex(1);
    _taskRepository.updateTaskIndex(0);
  }
}
