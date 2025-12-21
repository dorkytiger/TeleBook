import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/util/html_util.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ParseController extends GetxController {
  final parseUrl = Get.arguments as String;
  late final WebViewController webViewController;
  late final RxList<String> images = <String>[].obs;
  late final Rx<String> title = ''.obs;
  final parseState = Rx<RequestState<void>>(Idle());
  final parseProgress = 0.obs;

  @override
  void onInit() {
    super.onInit();
    ever(parseState, (state) async {
      ToastService.dismiss(); // 先关闭可能已存在的 toast

      if (state.isLoading()) {
        ToastService.showLoading('解析中...');
        return;
      }
      if (state.isSuccess()) {
        ToastService.showSuccess("解析成功");
        await Future.delayed(const Duration(milliseconds: 1500));
        ToastService.dismiss();
        // 使用 Get.back() 返回上一页
        Get.offAndToNamed("/download/form",
            arguments: jsonEncode(
                ParseResult(title: title.value, images: images.toList())
                    .toJson()));
      }
      if (state.isError()) {
        ToastService.showError("解析失败");
        await Future.delayed(const Duration(milliseconds: 1500));
        ToastService.dismiss();
        // 使用 Get.back() 返回上一页
        Get.back();
      }
    });
    _initWebView();
  }

  void _initWebView() => webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          parseProgress.value = progress;
        },
        onPageStarted: (String url) {
          parseState.value = Loading();
        },
        onPageFinished: (String url) {
          _handlePageFinished(url);
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..clearCache()
    ..clearLocalStorage()
    ..loadRequest(Uri.parse(parseUrl));

  Future<void> _handlePageFinished(String url) async {
    try {
      final parseTitle =
          await HtmlUtil.extractTitleFromWebView(webViewController);
      final parseImages =
          await HtmlUtil.extractImagesFromWebView(webViewController);
      title.value = parseTitle;
      images.assignAll(parseImages);
      // 调试输出
      debugPrint('解析到 ${parseImages.length} 张图片');
      parseState.value = Success(null);
    } catch (e, st) {
      // 解析失败时保留已有数据或清空
      images.clear();
      debugPrint('解析图片出错: $e\n$st');
      parseState.value = Error(e.toString());
    }
  }
}

class ParseResult {
  final String title;
  final List<String> images;

  ParseResult({required this.title, required this.images});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'images': images,
    };
  }

  factory ParseResult.fromJson(Map<String, dynamic> json) {
    return ParseResult(
      title: json['title'] as String,
      images: List<String>.from(json['images'] as List),
    );
  }
}
