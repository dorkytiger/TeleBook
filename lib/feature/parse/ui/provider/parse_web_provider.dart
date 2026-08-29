import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/feature/download/service/download_service.dart';
import 'package:tele_book/feature/parse/service/parse_web_service.dart';
import 'package:webview_all/webview_all.dart';

part 'parse_web_provider.g.dart';

part 'parse_web_provider.freezed.dart';

@freezed
abstract class ParseWebState with _$ParseWebState {
  const factory ParseWebState({
    required String title,
    required List<String> urls,
    required int progress,
  }) = _ParseWebState;
}

@riverpod
class ParseWeb extends _$ParseWeb {
  ParseWebService get _parseWebService => ref.read(parseWebServiceProvider);

  DownloadService get _downloadService => ref.read(downloadServiceProvider);

  bool get isInit => _webViewController != null;

  WebViewController? _webViewController;

  @override
  ParseWebState build(String url) {
    Future.microtask(() => _initialize(url));
    return const ParseWebState(title: '加载中...', urls: [], progress: 0);
  }

  Future<void> _initialize(String url) async {
    if (!ref.mounted) return;
    state = state.copyWith(progress: 0);
    await Future.delayed(Duration.zero);
  }

  void onLoadStart(WebViewController controller) {
    _webViewController = controller;
  }

  void onTitleChanged(WebViewController controller, String? title) {
    state = state.copyWith(title: title ?? '未知标题');
  }

  /// 页面加载进度变化：仅更新进度条。
  ///
  /// 不在此处执行 JS——加载过程中 WKWebView 的 evaluateJavaScript 会失败。
  void onProgressChange(WebViewController controller, int progress) {
    _webViewController = controller;
    state = state.copyWith(progress: progress);
  }

  /// 页面加载完成后提取图片链接。
  Future<void> onPageFinished(WebViewController controller) async {
    _webViewController = controller;
    final urls = await _extractUrls(controller);
    if (!ref.mounted) return;
    state = state.copyWith(urls: urls);
  }

  Future<void> parseWeb() async {
    final controller = _webViewController;
    if (controller == null) return;

    final urls = await _extractUrls(controller);
    if (!ref.mounted) return;
    state = state.copyWith(urls: urls);
  }

  /// 执行 JS 提取图片链接；失败时返回空列表而非抛异常。
  Future<List<String>> _extractUrls(WebViewController controller) async {
    try {
      return await _parseWebService.extractImagesFromWebView(
        onExtractImages: (js) async {
          final result = await controller.runJavaScriptReturningResult(js);
          return result.toString();
        },
      );
    } catch (e) {
      // 页面未就绪或 JS 执行失败时静默返回空列表，避免崩溃
      debugPrint('[ParseWeb] 提取图片链接失败: $e');
      return const [];
    }
  }

  Future<void> startDownload() async {
    final current = state;
    if (current.urls.isEmpty) return;
    _downloadService.startDownload(current.urls, current.title);
  }
}
