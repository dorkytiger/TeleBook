import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/common/widget/network_image_widget.dart';
import 'package:tele_book/feature/pase/ui/viewmodel/parse_web_viewmodel.dart';

class ParseWebView extends StatelessWidget {
  final String url;

  const ParseWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ParseWebViewmodel(
        context.read(),
        context.read(),
        context.read(),
        context.read(),
      ),
      child: _ParseWebContent(url: url),
    );
  }
}

class _ParseWebContent extends StatefulWidget {
  final String url;

  const _ParseWebContent({super.key, required this.url});

  @override
  State<_ParseWebContent> createState() => __ParseWebContentState();
}

class __ParseWebContentState extends State<_ParseWebContent> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ParseWebViewmodel>();
    return Scaffold(
      appBar: AppBar(title: const Text("解析网页")),
      floatingActionButton: FloatingActionButton(
        child: Badge(
          label: Text(vm.urls.length.toString()),
          child: Icon(Icons.photo),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => _buildBottomSheet(context, vm),
          );
        },
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: vm.progress / 100),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              onLoadStart: (controller, url) {
                vm.onLoadStart(controller);
              },
              onTitleChanged: (controller, title) {
                vm.onTitleChanged(controller, title);
              },
              onProgressChanged: (controller, progress) {
                vm.onProgressChange(controller, progress);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context, ParseWebViewmodel vm) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          Text("解析到的图片链接", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: vm.urls.length,
              itemBuilder: (context, index) {
                final url = vm.urls[index];
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
                vm.startDownload(context);
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
