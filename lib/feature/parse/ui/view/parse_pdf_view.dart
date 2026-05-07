import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/core/util/state_util.dart';
import 'package:tele_book/feature/parse/ui/viewmodel/parse_pdf_viewmodel.dart';

class ParsePdfView extends StatelessWidget {
  final String pdfPath;

  const ParsePdfView({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ParsePdfViewmodel(
        pdfPath: pdfPath,
        parsePdfService: context.read(),
        bookRepository: context.read(),
      ),
      child: const _ParsePdfContent(),
    );
  }
}

class _ParsePdfContent extends StatelessWidget {
  const _ParsePdfContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ParsePdfViewmodel>();

    return Scaffold(
      appBar: AppBar(title: Text('解析 PDF：${vm.pdfName}')),
      body: vm.parseState.when<List<String>>(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              if (vm.totalPages > 0)
                Text('正在渲染：${vm.currentPage} / ${vm.totalPages} 页'),
            ],
          ),
        ),
        success: (images) => GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) =>
              Image.file(File(images[index]), fit: BoxFit.cover),
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
                    : const Text('保存到书架'),
              ),
            )
          : null,
    );
  }
}

