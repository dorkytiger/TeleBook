import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/util/html_util.dart';
import 'package:tele_book/app/util/pick_file_util.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/widget/cross_platform_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ParseWebController extends GetxController {
  final parseUrl = Get.arguments as String;
  final selectBar =0.obs;
  late final CrossPlatformWebViewController webViewController;
  late final RxList<String> images = <String>[].obs;
  late final Rx<String> title = ''.obs;
  final parseState = Rx<RequestState<void>>(Idle());
  final saveImageState = Rx<RequestState<void>>(Idle());
  final parseProgress = 0.obs;

  @override
  void onInit() {
    super.onInit();
    parseState.listenWithSuccess(
      onSuccess: () {
        Get.offAndToNamed(
          "/download/form",
          arguments: jsonEncode(
            ParseWebResult(title: title.value, images: images.toList()).toJson(),
          ),
        );
      },
    );

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
    try {
      final parseTitle = await HtmlUtil.extractTitleFromWebView(
        webViewController,
      );
      final parseImages = await HtmlUtil.extractImagesFromWebView(
        webViewController,
      );
      title.value = parseTitle;
      images.assignAll(parseImages);
      // 调试输出
      debugPrint('解析到 ${parseImages.length} 张图片');
    } catch (e, st) {
      // 解析失败时保留已有数据或清空
      images.clear();
      debugPrint('解析图片出错: $e\n$st');
      parseState.value = Error(e.toString());
    }
  }

  Future<void> copyImageUrl(String url) async {
    Clipboard.setData(ClipboardData(text: url));
    ToastService.showSuccess("图片url已复制到剪贴板");
  }

  Future<void> saveImageTo(String url) async {
    try {
      saveImageState.value = Loading();
      ToastService.showLoading("正在保存图片...");
      final saveDirectory =await PickFileUtil.pickDirectory();
      if(saveDirectory==null){
        return;
      }
      final savePath = await HtmlUtil.downloadImageToFile(url,saveDirectory);
      ToastService.dismiss();
      ToastService.showSuccess("图片已保存到: $savePath");
      saveImageState.value = Success(null);
    } catch (e) {
      debugPrint("保存图片失败: $e");
      saveImageState.value = Error(e.toString());
    }
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
