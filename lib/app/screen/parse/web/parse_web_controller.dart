import 'dart:convert';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/service/download_service.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/util/html_util.dart';
import 'package:tele_book/app/util/pick_file_util.dart';
import 'package:tele_book/app/widget/cross_platform_webview.dart';

class ParseWebController extends GetxController {
  final parseUrl = Get.arguments as String;
  final selectBar = 0.obs;
  late final CrossPlatformWebViewController webViewController;
  late final RxList<String> images = <String>[].obs;
  late final Rx<String> title = ''.obs;
  final parseState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final saveImageState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final downloadService = Get.find<DownloadService>();
  final parseProgress = 0.obs;

  @override
  void onInit() {
    saveImageState.listenEventToast();
    super.onInit();
    _initWebView();
  }

  void _initWebView() {
    webViewController = CrossPlatformWebViewController(initialUrl: parseUrl);

    webViewController.setNavigationDelegate(
      onProgress: (int progress) {
        parseProgress.value = progress;
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
    await parseState.triggerEvent(
      event: () async {
        final parseTitle = await HtmlUtil.extractTitleFromWebView(
          webViewController,
        );
        final parseImages = await HtmlUtil.extractImagesFromWebView(
          webViewController,
        );
        title.value = parseTitle;
        images.assignAll(parseImages);
      },
    );
  }

  Future<void> copyImageUrl(String url) async {
    Clipboard.setData(ClipboardData(text: url));
    ToastService.showSuccess("图片url已复制到剪贴板");
  }

  Future<void> saveImageTo(String url) async {
    await saveImageState.triggerEvent(
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

class ParseWebResult {
  final String title;
  final List<String> images;

  ParseWebResult({required this.title, required this.images});

  Map<String, dynamic> toJson() {
    return {'title': title, 'images': images};
  }

  factory ParseWebResult.fromJson(Map<String, dynamic> json) {
    return ParseWebResult(
      title: json['title'] as String,
      images: List<String>.from(json['images'] as List),
    );
  }
}
