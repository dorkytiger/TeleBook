import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
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
      if (previous == null) return;

      if (next.hasError && !next.isLoading) {
        showFToast(
          context: context,
          title: Text("保存失败"),
          description: Text(next.error.toString()),
        );
      }

      if (previous.isLoading && next.hasValue) {
        showFToast(context: context, title: Text('保存成功'));
        context.go(AppRoute.main);
      }
    });

    return FScaffold(
      header: FHeader.nested(
        title: Text('解析 PDF：${asyncState.value?.pdfName ?? ''}'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: asyncState.when(
        loading: () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FCircularProgress(size: .xl),
              const SizedBox(height: 16),
              Text('正在解析 ${progress.$1}/${progress.$2}'),
            ],
          ),
        ),
        error: (error, stack) => Center(child: Text(error.toString())),
        data: (state) => Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisExtent: 200,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: state.tempPaths.length,
                itemBuilder: (context, index) {
                  final image = state.tempPaths[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          File(image),
                          fit: BoxFit.cover,
                          cacheWidth: 300,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                        // 页码角标
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FButton(
                onPress: saveBookState.isLoading
                    ? null
                    : () => ref
                          .read(parsePdfSaveBookProvider.notifier)
                          .onSave(
                            asyncState.value!.tempPaths,
                            asyncState.value!.pdfName,
                          ),
                child: saveBookState.isLoading
                    ? Text(saveBookStepText(saveBookProgress))
                    : const Text('保存到书架'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
