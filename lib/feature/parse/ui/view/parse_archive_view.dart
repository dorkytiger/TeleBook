import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('解析压缩包')),
      body: asyncState.when(
        loading: () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
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
            : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              final image = state.tempPaths[index];
              return Image.file(File(image), fit: BoxFit.cover);
            },
            itemCount: state.tempPaths.length,
          ),
      ),
      bottomNavigationBar: asyncState.value?.tempPaths.isNotEmpty == true
          ? Padding(
              padding: EdgeInsets.all(16),
              child: FilledButton(
                onPressed: saveState.isLoading
                    ? null
                    : () => onSave(asyncState.value!),
                child: saveState.isLoading
                    ? Text('保存中 ${saveProgress.current}/${saveProgress.total}')
                    : const Text('保存到书架'),
              ),
            )
          : null,
    );
  }
}
