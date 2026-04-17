import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

import 'parse_single_archive_controller.dart';

class ParseSingleArchiveScreen extends StatelessWidget {
  final String filePath;

  const ParseSingleArchiveScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParseSingleArchiveController(
        filePath: filePath,
        importStore: context.read(),
      ),
      child: const _ParseSingleArchiveContent(),
    );
  }
}

class _ParseSingleArchiveContent extends StatelessWidget {
  const _ParseSingleArchiveContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<ParseSingleArchiveController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('解析归档'),
            leading: BackButton(onPressed: () => context.pop()),
            actions: [
              IconButton(
                onPressed: controller.isImporting
                    ? null
                    : () async {
                        await controller.importArchive();
                        if (context.mounted) {
                          context.go('${AppRoute.home}?tab=1&taskTab=1');
                        }
                      },
                icon: controller.isImporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
              ),
            ],
          ),
          body: DKStateQueryDisplay(
            state: controller.extractArchiveState,
            successBuilder: (_) => ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.archives.length,
              itemBuilder: (context, index) {
                final archive = controller.archives[index];
                return Column(
                  children: [
                    Row(
                      children: [
                        CustomImageLoader(localUrl: archive.path),
                        Expanded(
                          child: ListTile(
                            title: Text(archive.path.split('/').last),
                            subtitle: Text(
                              '大小: ${(archive.lengthSync() / 1024).toStringAsFixed(2)} KB',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
