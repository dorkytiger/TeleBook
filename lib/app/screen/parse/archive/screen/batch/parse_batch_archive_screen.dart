import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

import 'parse_batch_archive_controller.dart';

class ParseBatchArchiveScreen extends StatelessWidget {
  final String folderPath;

  const ParseBatchArchiveScreen({super.key, required this.folderPath});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParseBatchArchiveController(
        folderPath: folderPath,
        importStore: context.read(),
      ),
      child: const _ParseBatchArchiveContent(),
    );
  }
}

class _ParseBatchArchiveContent extends StatelessWidget {
  const _ParseBatchArchiveContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<ParseBatchArchiveController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('批量导入压缩包'),
            actions: [
              IconButton(
                onPressed: () async {
                  await controller.saveAllBooks();
                  if (context.mounted) {
                    context.go('${AppRoute.home}?tab=1&taskTab=1');
                  }
                },
                icon: const Icon(Icons.save),
              ),
            ],
          ),
          body: DKStateQueryDisplay(
            state: controller.extractArchivesState,
            successBuilder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '共找到 ${controller.archiveFolders.length} 个压缩包',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: controller.archiveFolders.length,
                    itemBuilder: (context, index) {
                      final archiveFolder = controller.archiveFolders[index];
                      return _buildArchiveItem(
                          context, controller, archiveFolder, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArchiveItem(
    BuildContext context,
    ParseBatchArchiveController controller,
    ArchiveFolder archiveFolder,
    int index,
  ) {
    return Row(
      children: [
        CustomImageLoader(
          localUrl: archiveFolder.files.firstOrNull?.path,
        ),
        Expanded(
          child: ListTile(
            title: Text(archiveFolder.title),
            subtitle: Text('${archiveFolder.files.length} 个文件'),
            onTap: () async {
              // push 到编辑页面，等待返回结果
              final result = await context.push<ArchiveFolder>(
                AppRoute.parseArchiveBatchEdit,
                extra: archiveFolder,
              );
              if (result != null) {
                controller.updateArchiveFolder(index, result);
              }
            },
          ),
        ),
      ],
    );
  }
}
