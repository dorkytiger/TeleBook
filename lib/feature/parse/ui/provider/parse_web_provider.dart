import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/feature/download/service/download_service.dart';
import 'package:tele_book/feature/parse/service/parse_web_service.dart';

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

  InAppWebViewController? _webViewController;

  @override
  ParseWebState build(String url) {
    Future.microtask(() => _initialize(url));
    return const ParseWebState(title: '加载中...', urls: [], progress: 0);
  }

  Future<void> _initialize(String url) async {
    state = state.copyWith(progress: 0);
    await Future.delayed(Duration.zero);
  }

  void onLoadStart(InAppWebViewController controller) {
    _webViewController = controller;
  }

  void onTitleChanged(InAppWebViewController controller, String? title) {
    state = state.copyWith(title: title ?? '未知标题');
  }

  Future<void> onProgressChange(
    InAppWebViewController controller,
    int progress,
  ) async {
    _webViewController = controller;
    final urls = await _parseWebService.extractImagesFromWebView(
      onExtractImages: (js) async {
        final result = await controller.evaluateJavascript(source: js);
        return result?.toString();
      },
    );
    state = state.copyWith(urls: urls, progress: progress);
  }

  Future<void> startDownload() async {
    final current = state;
    if (current.urls.isEmpty) return;
    _downloadService.startDownload(current.urls, current.title);
  }
}
