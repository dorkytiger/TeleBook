import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/route/app_route.dart';
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

    ref.listen(parsePdfSaveBookProvider, (previous, next) {
      DKLog.d('保存状态变化：previous=$previous, next=$next');

      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败：${next.error}')));
      }

      if (previous?.isLoading == true && next.hasValue) {
        DKLog.d('保存成功，返回书架');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('保存成功')));
        context.go(AppRoute.main);
      }
    });

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
                    : () => ref.read(parsePdfSaveBookProvider.notifier).onSave(
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
