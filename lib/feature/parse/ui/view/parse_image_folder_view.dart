import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_image_folder_provider.dart';

class ParseImageFolderView extends ConsumerWidget {
  final String? folderPath;
  final List<String>? imagePaths;

  const ParseImageFolderView({
    super.key,
    this.folderPath,
    this.imagePaths,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final param = ParseImageFolderParam(
      folderPath: folderPath,
      imagePathsInput: imagePaths,
    );
    final provider = parseImageFolderProvider(param);
    final asyncState = ref.watch(provider);

    final saveState = ref.watch(parseImageFolderSaveBookProvider(param));
    final saveNotifier = ref.watch(parseImageFolderSaveBookProvider(param).notifier);
    final saveProgress = ref.watch(parseImageFolderSaveBookProgressProvider(param));

    ref.listen(parseImageFolderSaveBookProvider(param), (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败：${next.error}')));
      } else if (previous?.isLoading == true && next.hasValue) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('保存成功')));
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
    return Scaffold(
      appBar: AppBar(title: const Text('解析文件夹')),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: CustomErrorWidget(
            errorMessage: error.toString(),
            stackTrace: stack,
          ),
        ),
        data: (state) => state.imagePaths.isEmpty
            ? const Center(child: Text('未解析到图片'))
            : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              final image = state.imagePaths[index];
              return Image.file(File(image), fit: BoxFit.cover);
            },
            itemCount: state.imagePaths.length,
          ),
      ),
      bottomNavigationBar: asyncState.value?.imagePaths.isNotEmpty == true
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: saveState.isLoading
                    ? null
                    : () => onSave(asyncState.value!),
                child: saveState.isLoading
                    ? Text('保存中 ${saveProgress.current}/${saveProgress.total}')
                    : const Text("保存到书架"),
              ),
            )
          : null,
    );
  }
}

