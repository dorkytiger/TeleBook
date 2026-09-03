import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/ui/provider/book_provider.dart';
import 'package:tele_book/feature/export/enum/export_format.dart';
import 'package:tele_book/feature/export/service/export_service.dart';

part 'export_single_provider.freezed.dart';

part 'export_single_provider.g.dart';

@freezed
abstract class ExportSingleState with _$ExportSingleState {
  const factory ExportSingleState({
    required BookTableData book,
    required ExportFormat format,
    required TextEditingController fileNameCrl,
    required bool isExporting,
    required bool isDone,
    required TextEditingController outputPathCrl,
    String? errorMsg
  }) = _ExportSingleState;
}

@riverpod
class ExportSingle extends _$ExportSingle {
  final ExportService _exportService = ExportService();

  @override
  ExportSingleState build(int bookId) {
    final book = ref
        .watch(bookListProvider)
        .value
        ?.bookVos
        .where((e) => e.book.id == bookId)
        .first
        .book;
    if (book == null) {
      throw Exception('Book not found');
    }
    return ExportSingleState(
      book: book,
      format: ExportFormat.folder,
      fileNameCrl: TextEditingController(text: book.name),
      isExporting: false,
      isDone: false,
      outputPathCrl: TextEditingController(),
    );
  }

  void setFormat(ExportFormat fmt) {
    state = state.copyWith(format: fmt);
  }


  Future<void> pickOutputDir() async {
    final result = await FilePicker.getDirectoryPath();
    if (result != null) {
      state.outputPathCrl.text = result;
    }
  }

  Future<void> doExport() async {
    final path = state.outputPathCrl.text;
    final name = state.fileNameCrl.text.trim();

    state = state.copyWith(isExporting: true);
    try {
      await _exportService.exportSingle(
        book: state.book,
        outputDirPath: path,
        fileName: name,
        format: state.format,
      );
      state = state.copyWith(isDone: true, isExporting: false);
    } catch (e) {
      state = state.copyWith(isExporting: false, errorMsg: '导出失败：$e');
    }
  }
}
