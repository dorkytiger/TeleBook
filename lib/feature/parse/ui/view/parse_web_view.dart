import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/network_image_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/main/provider/main_provider.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_web_provider.dart';

class ParseWebView extends ConsumerStatefulWidget {
  final String url;

  const ParseWebView({super.key, required this.url});

  @override
  ConsumerState<ParseWebView> createState() => _ParseWebViewState();
}

class _ParseWebViewState extends ConsumerState<ParseWebView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(parseWebProvider(widget.url));
    final notifier = ref.read(parseWebProvider(widget.url).notifier);

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
      child: Column(
        children: [
          FDeterminateProgress(value: (state.progress) / 100),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              onLoadStart: (controller, url) {
                notifier.onLoadStart(controller);
              },
              onTitleChanged: (controller, title) {
                notifier.onTitleChanged(controller, title);
              },
              onProgressChanged: (controller, progress) {
                notifier.onProgressChange(controller, progress);
              },
            ),
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
