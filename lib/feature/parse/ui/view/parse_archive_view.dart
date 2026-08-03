import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_archive_provider.dart';

class ParseArchiveView extends ConsumerWidget {
  final String archivePath;

  const ParseArchiveView({super.key, required this.archivePath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = parseArchiveProvider(archivePath);
    final asyncState = ref.watch(provider);
    final parseProgress = ref.watch(parseArchiveProgressProvider(archivePath));

    final saveState = ref.watch(parseArchiveSaveBookProvider);
    final saveNotifier = ref.watch(parseArchiveSaveBookProvider.notifier);
    final saveProgress = ref.watch(parseArchiveSaveBookProgressProvider);

    ref.listen(parseArchiveSaveBookProvider, (previous, next) {
      if (previous == null) return;
      if (next.hasError) {
        showFToast(
          context: context,
          title: Text("保存失败"),
          description: Text(next.error.toString()),
        );
      } else if (previous.isLoading && next.hasValue) {
        showFToast(context: context, title: Text("保存成功"));
        context.go(AppRoute.main);
      }
    });

    return _ParseArchiveContent(
      asyncState: asyncState,
      parseProgress: parseProgress,
      saveState: saveState,
      saveProgress: saveProgress,
      onSave: (data) {
        saveNotifier.submit(
          ParseArchiveSaveBookParam(
            archiveName: data.archiveName,
            tempPaths: data.tempPaths,
          ),
        );
      },
    );
  }
}

class _ParseArchiveContent extends StatelessWidget {
  final AsyncValue<ParseArchiveState> asyncState;
  final (int current, int total) parseProgress;
  final AsyncValue<void> saveState;
  final ParseArchiveSaveBookProgress saveProgress;
  final void Function(ParseArchiveState data) onSave;

  const _ParseArchiveContent({
    required this.asyncState,
    required this.parseProgress,
    required this.saveState,
    required this.saveProgress,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('解析压缩包'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: asyncState.when(
        loading: () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FCircularProgress(size: .xl),
              const SizedBox(height: 12),
              Text('正在解析 ${parseProgress.$1}/${parseProgress.$2}'),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: CustomErrorWidget(
            errorMessage: error.toString(),
            stackTrace: stack,
          ),
        ),
        data: (state) => state.tempPaths.isEmpty
            ? const Center(child: Text('未解析到图片'))
            : Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                            mainAxisExtent: 200,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
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
                      itemCount: state.tempPaths.length,
                    ),
                  ),
                  asyncState.value?.tempPaths.isNotEmpty == true
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: FButton(
                            onPress: saveState.isLoading
                                ? null
                                : () => onSave(asyncState.value!),
                            child: saveState.isLoading
                                ? Text(saveProgress.stepText)
                                : const Text('保存到书架'),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
      ),
    );
  }
}
