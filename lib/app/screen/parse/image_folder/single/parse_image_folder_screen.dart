import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/route/app_route.dart';

import 'parse_image_folder_controller.dart';

class ParseImageFolderScreen extends StatelessWidget {
  final String folderPath;

  const ParseImageFolderScreen({super.key, required this.folderPath});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParseImageFolderController(
        folderPath: folderPath,
        importStore: context.read(),
      ),
      child: const _ParseImageFolderContent(),
    );
  }
}

class _ParseImageFolderContent extends StatelessWidget {
  const _ParseImageFolderContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<ParseImageFolderController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('解析图片文件夹'),
            leading: BackButton(onPressed: () => context.pop()),
          ),
          body: DKStateQueryDisplay(
            state: controller.scanImageState,
            successBuilder: (data) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('找到 ${data.length} 张图片',
                      style: Theme.of(context).textTheme.titleMedium),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final imageFile = data[index];
                        return ListTile(
                          title: Text(imageFile.path.split('/').last),
                          subtitle: Text(
                            '大小: ${(imageFile.lengthSync() / 1024).toStringAsFixed(2)} KB',
                          ),
                          leading: AspectRatio(
                            aspectRatio: 9 / 16,
                            child: Image.file(imageFile, fit: BoxFit.contain),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () async {
                        await controller.saveImagesToLocal();
                        if (context.mounted) {
                          context.go('${AppRoute.home}?tab=1&taskTab=1');
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('导入'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
