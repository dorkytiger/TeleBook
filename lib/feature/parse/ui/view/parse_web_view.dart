import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/network_image_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/util/url_util.dart';
import 'package:tele_book/feature/main/provider/main_provider.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_web_provider.dart';
import 'package:webview_all/webview_all.dart';

class ParseWebView extends ConsumerStatefulWidget {
  final String url;

  const ParseWebView({super.key, required this.url});

  @override
  ConsumerState<ParseWebView> createState() => _ParseWebViewState();
}

class _ParseWebViewState extends ConsumerState<ParseWebView> {
  late final WebViewController _controller;

  /// URL 无效时为 true，build 时显示错误提示而非构建 WebView。
  bool _invalidUrl = false;

  /// 防止 onProgress(100) 与 onPageFinished 重复执行页面完成逻辑。
  bool _handledFinished = false;

  @override
  void initState() {
    super.initState();
    final uri = normalizeWebUrl(widget.url);
    if (uri == null) {
      _invalidUrl = true;
      debugPrint('[ParseWeb] 无效 URL: ${widget.url}');
      return;
    }

    final notifier = ref.read(parseWebProvider(widget.url).notifier);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint('[ParseWeb] 页面开始加载: $url');
            _handledFinished = false;
          },
          onProgress: (progress) {
            notifier.onProgressChange(_controller, progress);
            // 部分平台 onPageFinished 可能不触发，progress 到 100 时兜底
            if (progress >= 100) {
              _handlePageFinished(notifier);
            }
          },
          onPageFinished: (url) {
            debugPrint('[ParseWeb] 页面加载完成: $url');
            _handlePageFinished(notifier);
          },
          onWebResourceError: (error) {
            debugPrint(
              '[ParseWeb] 资源加载错误: ${error.errorCode} '
              '${error.description} ${error.url}',
            );
          },
        ),
      )
      ..loadRequest(uri);
    // 注册 controller，供解析图片使用
    notifier.onLoadStart(_controller);
  }

  /// 页面加载完成后的处理：更新标题 + 提取图片链接。
  ///
  /// 标题获取失败不阻塞图片提取；进度与 finished 双触发只执行一次。
  Future<void> _handlePageFinished(ParseWeb notifier) async {
    if (_handledFinished) return;
    _handledFinished = true;

    String? title;
    try {
      title = await _controller.getTitle();
    } catch (e) {
      debugPrint('[ParseWeb] 获取标题失败: $e');
    }
    if (!mounted) return;
    notifier.onTitleChanged(
      _controller,
      (title == null || title.isEmpty) ? widget.url : title,
    );
    await notifier.onPageFinished(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(parseWebProvider(widget.url));

    return FScaffold(
      header: FHeader.nested(
        title: Text(state.title),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
        suffixes: [
          Builder(
            builder: (innerContext) => FHeaderAction(
              icon: FBadge(child: Text('${state.urls.length}')),
              onPress: () {
                _showBottomSheet(
                  context: innerContext,
                  url: widget.url,
                );
              },
            ),
          ),
        ],
      ),
      child: _invalidUrl
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '无效的网址：${widget.url}',
                  textAlign: TextAlign.center,
                  style: context.theme.typography.body.lg.copyWith(
                    color: context.theme.colors.mutedForeground,
                  ),
                ),
              ),
            )
          : Column(
              children: [
                FDeterminateProgress(value: (state.progress) / 100),
                Expanded(
                  child: WebViewWidget(controller: _controller),
                ),
              ],
            ),
    );
  }

  void _showBottomSheet({required BuildContext context, required String url}) {
    showFSheet(
      context: context,
      side: .btt,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(parseWebProvider(url));
          final notifier = ref.read(parseWebProvider(url).notifier);

          return Container(
            decoration: BoxDecoration(
              color: context.theme.colors.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: .symmetric(
                horizontal: BorderSide(color: context.theme.colors.border),
              ),
            ),
            child: Padding(
              padding: .all(16),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        "解析到的图片链接",
                        style: context.theme.typography.body.xl.copyWith(
                          fontWeight: .w600,
                          color: context.theme.colors.foreground,
                          height: 1.5,
                        ),
                      ),
                      FButton.icon(
                        variant: .ghost,
                        onPress: notifier.isInit
                            ? () {
                                notifier.parseWeb();
                              }
                            : null,
                        child: Icon(FLucideIcons.refreshCcw),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: FItemGroup.builder(
                      count: state.urls.length,
                      itemBuilder: (context, index) {
                        final url = state.urls[index];
                        return FItem(
                          prefix: NetworkImageWidget(imageUrl: url),
                          title: Text(
                            url,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    _buildImagePreview(context, url),
                              ),
                            );
                          },
                          suffix: Icon(FLucideIcons.chevronRight),
                        );
                      },
                    ),
                  ),
                  FButton(
                    onPress: () {
                      if (state.urls.isEmpty) return;
                      ref.read(mainProvider.notifier).updateCurrentIndex(1);
                      context.go(AppRoute.main);
                      unawaited(notifier.startDownload());
                    },
                    child: const Text("下载"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePreview(BuildContext parentContext, String url) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text("图片预览"),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(parentContext).pop()),
        ],
      ),
      child: Center(
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Text(
              "${(loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1) * 100).toStringAsFixed(2)}%",
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: Icon(Icons.broken_image, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
