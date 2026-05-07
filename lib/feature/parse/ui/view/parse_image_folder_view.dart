import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/core/util/state_util.dart';
import 'package:tele_book/feature/parse/ui/viewmodel/parse_image_folder_viewmodel.dart';

class ParseImageFolderView extends StatelessWidget {
  final String folderPath;

  const ParseImageFolderView({super.key, required this.folderPath});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ParseImageFolderViewmodel(
        folderPath: folderPath,
        parseArchiveService: context.read(),
        bookRepository: context.read(),
      ),
      child: const _ParseImageFolderContent(),
    );
  }
}

class _ParseImageFolderContent extends StatelessWidget {
  const _ParseImageFolderContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ParseImageFolderViewmodel>();
    return Scaffold(
      appBar: AppBar(title: const Text("解析文件夹")),
      body: vm.parseState.when<List<String>>(
        success: (images) => GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            final image = images[index];
            return Image.file(File(image), fit: BoxFit.cover);
          },
          itemCount: images.length,
        ),
      ),
      bottomNavigationBar: vm.parseState.isSuccess
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: vm.saveToBookState.isLoading
                    ? null
                    : () => vm.saveToBook(context),
                child: vm.saveToBookState.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("保存到书架"),
              ),
            )
          : null,
    );
  }
}

