import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_pdf_provider.dart';

class ParsePdfView extends ConsumerWidget {
  final String pdfPath;

  const ParsePdfView({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(parsePdfProvider(pdfPath));
    final progress = ref.watch(parsePdfProgressProvider(pdfPath));

    final saveBookProgress = ref.watch(parsePdfSaveBookProgressProvider);
    final saveBookState = ref.watch(parsePdfSaveBookProvider);
    final saveBookNotifier = ref.watch(parsePdfSaveBookProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('解析 PDF：${asyncState.value?.pdfName ?? ''}')),
      body: asyncState.when(
        loading: () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('正在解析 ${progress.$1}/${progress.$2}'),
            ],
          ),
        ),
        error: (error, stack) => Center(child: Text(error.toString())),
        data: (state) => GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: state.tempPaths.length,
          itemBuilder: (context, index) =>
              Image.file(File(state.tempPaths[index]), fit: BoxFit.cover),
        ),
      ),
      bottomNavigationBar: asyncState.hasValue == true
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: saveBookState.isLoading
                    ? null
                    : () => saveBookNotifier.onSave(
                        ref,
                        asyncState.value!.tempPaths,
                        asyncState.value!.pdfName,
                      ),
                child: saveBookState.isLoading
                    ? Text(
                        '保存中... ${saveBookProgress.$1}/${saveBookProgress.$2}',
                      )
                    : const Text('保存到书架'),
              ),
            )
          : null,
    );
  }
}
