import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_image_folder_provider.dart';

class ParseImageFolderView extends ConsumerWidget {
  final String? folderPath;
  final List<String>? imagePaths;

  const ParseImageFolderView({super.key, this.folderPath, this.imagePaths});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final param = ParseImageFolderParam(
      folderPath: folderPath,
      imagePathsInput: imagePaths,
    );
    final provider = parseImageFolderProvider(param);
    final asyncState = ref.watch(provider);

    final saveState = ref.watch(parseImageFolderSaveBookProvider(param));
    final saveNotifier = ref.watch(
      parseImageFolderSaveBookProvider(param).notifier,
    );
    final saveProgress = ref.watch(
      parseImageFolderSaveBookProgressProvider(param),
    );

    ref.listen(parseImageFolderSaveBookProvider(param), (previous, next) {
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

    return _ParseImageFolderContent(
      asyncState: asyncState,
      saveState: saveState,
      saveProgress: saveProgress,
      onSave: (data) {
        saveNotifier.submit(
          ParseImageFolderSaveBookParam(
            folderName: data.folderName,
            imagePaths: data.imagePaths,
          ),
        );
      },
    );
  }
}

class _ParseImageFolderContent extends StatelessWidget {
  final AsyncValue<ParseImageFolderState> asyncState;
  final AsyncValue<void> saveState;
  final ParseImageFolderSaveBookProgress saveProgress;
  final void Function(ParseImageFolderState data) onSave;

  const _ParseImageFolderContent({
    required this.asyncState,
    required this.saveState,
    required this.saveProgress,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('解析文件夹'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: asyncState.when(
        loading: () => const Center(child: FCircularProgress(size: .xl)),
        error: (error, stack) => Center(
          child: CustomErrorWidget(
            errorMessage: error.toString(),
            stackTrace: stack,
          ),
        ),
        data: (state) => state.imagePaths.isEmpty
            ? const Center(child: Text('未解析到图片'))
            : Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                            mainAxisExtent: 200,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: state.imagePaths.length,
                      itemBuilder: (context, index) {
                        final image = state.imagePaths[index];
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: FButton(
                      onPress: saveState.isLoading
                          ? null
                          : () => onSave(asyncState.value!),
                      child: saveState.isLoading
                          ? Text(saveProgress.stepText)
                          : const Text("保存到书架"),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
