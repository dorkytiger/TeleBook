import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/core/util/state_util.dart';
import 'package:tele_book/feature/parse/ui/viewmodel/parse_archive_viewmodel.dart';

class ParseArchiveView extends StatelessWidget {
  final String archivePath;

  const ParseArchiveView({super.key, required this.archivePath});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ParseArchiveViewmodel(
        archivePath: archivePath,
        parseArchiveService: context.read(),
        bookRepository: context.read(),
      ),
      child: _ParseArchiveContent(),
    );
  }
}

class _ParseArchiveContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ParseArchiveViewmodel>();
    return Scaffold(
      appBar: AppBar(title: Text("解析压缩包")),
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
              padding: EdgeInsets.all(16),
              child: FilledButton(
                onPressed: vm.saveToBookState.isLoading
                    ? null
                    : () => vm.saveToBook(context),
                child: vm.saveToBookState.isLoading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text("保存到书架"),
              ),
            )
          : null,
    );
  }
}
