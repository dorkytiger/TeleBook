import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/network_image_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_web_provider.dart';

class ParseWebView extends ConsumerWidget {
  final String url;

  const ParseWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parseWebProvider(url));
    final notifier = ref.read(parseWebProvider(url).notifier);

    return Scaffold(
      appBar: AppBar(title: Text(state.title)),
      floatingActionButton: FloatingActionButton(
        child: Badge(
          label: Text((state.urls.length).toString()),
          child: const Icon(Icons.photo),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => _buildBottomSheet(context, state, notifier),
          );
        },
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: (state.progress) / 100),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(url)),
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

  Widget _buildBottomSheet(
    BuildContext context,
    ParseWebState state,
    ParseWeb notifier,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          Text("解析到的图片链接", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: state.urls.length,
              itemBuilder: (context, index) {
                final url = state.urls[index];
                return Row(
                  children: [
                    NetworkImageWidget(imageUrl: url),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          url,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _buildImagePreview(url),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                notifier.startDownload();
                context.push(AppRoute.download);
              },
              child: Text("下载"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String url) {
    return Scaffold(
      appBar: AppBar(title: Text("图片预览")),
      body: Center(
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
