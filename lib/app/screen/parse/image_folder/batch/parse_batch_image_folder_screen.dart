import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/route/app_route.dart';

import 'parse_batch_image_folder_controller.dart';

class ParseBatchImageFolderScreen extends StatelessWidget {
  final String parentFolderPath;

  const ParseBatchImageFolderScreen({super.key, required this.parentFolderPath});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParseBatchImageFolderController(
        parentFolderPath: parentFolderPath,
        importStore: context.read(),
      ),
      child: const _ParseBatchImageFolderContent(),
    );
  }
}

class _ParseBatchImageFolderContent extends StatelessWidget {
  const _ParseBatchImageFolderContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<ParseBatchImageFolderController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar:  AppBar(title: Text('批量导入图片文件夹')),
          body: DKStateQueryDisplay(
            state: controller.scanFoldersState,
            successBuilder: (data) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '找到 ${data.length} 个文件夹，共 ${data.fold<int>(0, (s, f) => s + f.images.length)} 张图片',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final folderInfo = data[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                const Icon(Icons.folder),
                                const SizedBox(width: 8),
                                Expanded(child: Text(folderInfo.folderName)),
                              ]),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      folderInfo.images.length.clamp(0, 5),
                                  itemBuilder: (_, i) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Image.file(
                                      folderInfo.images[i],
                                      width: 60,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        await controller.saveAllToLocal();
                        if (context.mounted) {
                          context.go('${AppRoute.home}?tab=1&taskTab=1');
                        }
                      },
                      child: const Text('批量保存到本地'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
