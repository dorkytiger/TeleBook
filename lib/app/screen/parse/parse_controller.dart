import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/util/html_util.dart';
import 'package:tele_book/app/util/pick_file_util.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ParseController extends GetxController {
  final parseUrl = Get.arguments as String;
  final selectBar =0.obs;
  late final WebViewController webViewController;
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
            ParseResult(title: title.value, images: images.toList()).toJson(),
          ),
        );
      },
    );

    _initWebView();
  }

  void _initWebView() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            parseProgress.value = progress;
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            _handlePageFinished(url);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView资源错误: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            final uri = Uri.parse(request.url);

            // 处理非标准 scheme (如 weixin://, tel: 等)
            if (uri.scheme != 'http' && uri.scheme != 'https') {
              debugPrint('阻止打开非标准 scheme: ${request.url}');
              return NavigationDecision.prevent;
            }

            // // 阻止跳转到其他域名
            // final initialUri = Uri.parse(parseUrl);
            // if (uri.host != initialUri.host) {
            //   debugPrint('阻止跨域跳转: ${request.url}');
            //   return NavigationDecision.prevent;
            // }

            // 允许同域名的页面加载
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setOnConsoleMessage((message) {
        debugPrint('WebView Console: ${message.message}');
      })
      ..clearCache()
      ..clearLocalStorage()
      ..enableZoom(false)
      ..loadRequest(Uri.parse(parseUrl));
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

class ParseResult {
  final String title;
  final List<String> images;

  ParseResult({required this.title, required this.images});

  Map<String, dynamic> toJson() {
    return {'title': title, 'images': images};
  }

  factory ParseResult.fromJson(Map<String, dynamic> json) {
    return ParseResult(
      title: json['title'] as String,
      images: List<String>.from(json['images'] as List),
    );
  }
}
