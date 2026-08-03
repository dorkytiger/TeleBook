import 'package:dk_util/dk_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/feature/book/ui/provider/book_provider.dart';
import 'package:tele_book/feature/export/enum/export_format.dart';
import 'package:tele_book/feature/export/model/export_item.dart';
import 'package:tele_book/feature/export/service/export_service.dart';

part 'export_batch_provider.freezed.dart';

part 'export_batch_provider.g.dart';

@freezed
abstract class ExportBatchState with _$ExportBatchState {
  const factory ExportBatchState({
    required ExportFormat format,
    required bool isExporting,
    required bool isDone,
    required int progress,
    required List<ExportItem> items,
    required TextEditingController outputPathController,
    String? errorMessage,
  }) = _ExportBatchState;
}

@riverpod
class ExportBatch extends _$ExportBatch {
  final ExportService _exportService = ExportService();

  @override
  ExportBatchState build(List<int> bookIds) {
    final books = ref
        .read(bookListProvider)
        .value
        ?.bookVos
        .where((e) => bookIds.contains(e.book.id))
        .map((e) => e.book)
        .toList();
    if (books == null || books.isEmpty) {
      throw Exception('Books not found');
    }

    final items = books
        .map(
          (b) => ExportItem(
            book: b,
            coverPath: b.coverSubPath != null
                ? '${GlobalConfig.booksDir.path}/${b.coverSubPath}'
                : '${GlobalConfig.booksDir.path}/${b.localSubPaths.first}',
          ),
        )
        .toList();

    ref.onDispose(() {
      for (final item in items) {
        item.dispose();
      }
    });

    return ExportBatchState(
      format: ExportFormat.folder,
      isExporting: false,
      isDone: false,
      progress: 0,
      items: items,
      outputPathController: TextEditingController()
    );
  }

  void setFormat(ExportFormat fmt) {
    state = state.copyWith(format: fmt);
  }

  void setError(String message) {
    state = state.copyWith(errorMessage: message);
  }

  Future<void> pickOutputDir() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
       state.outputPathController.text=result;
    }
  }

  Future<void> doExport() async {
    final path = state.outputPathController.text;

    state = state.copyWith(isExporting: true, progress: 0, errorMessage: null);
    try {
      final exportList = state.items
          .map((i) => (book: i.book, fileName: i.nameController.text.trim()))
          .toList();

      await _exportService.exportBatch(
        items: exportList,
        outputDirPath: path,
        format: state.format,
        onProgress: (current, total) {
          if (!ref.mounted) return;
          state = state.copyWith(progress: current);
        },
      );
      if (!ref.mounted) return;
      state = state.copyWith(isDone: true, isExporting: false);
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isExporting: false, errorMessage: '导出失败：$e');
    }
  }
}
