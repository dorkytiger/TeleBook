import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/parse/service/parse_pdf_service.dart';

part 'parse_pdf_provider.freezed.dart';

part 'parse_pdf_provider.g.dart';

@freezed
abstract class ParsePdfState with _$ParsePdfState {
  const factory ParsePdfState({
    required String pdfName,
    required List<String> tempPaths,
  }) = _ParsePdfProgressState;
}

final parsePdfProgressProvider =
    StateProvider.family<(int current, int total), String>(
      (ref, pdfPath) => (0, 0),
    );

@riverpod
class ParsePdf extends _$ParsePdf {
  ParsePdfService get _service => ref.read(parsePdfServiceProvider);

  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;
    if (await Permission.manageExternalStorage.isGranted) return true;
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) return true;
    if (await Permission.storage.isGranted) return true;
    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  @override
  FutureOr<ParsePdfState> build(String pdfPath) async {
    final pdfName = pdfPath.split(RegExp(r'[\\/]')).last.replaceAll('.pdf', '');
    Future.microtask(() => _parsePdf(pdfPath));
    return ParsePdfState(tempPaths: const [], pdfName: pdfName);
  }

  Future<void> _parsePdf(String pdfPath) async {
    final pdfName = pdfPath.split(RegExp(r'[\\/]')).last.replaceAll('.pdf', '');

    ref.read(parsePdfProgressProvider(pdfPath).notifier).state = (0, 0);

    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      state = AsyncValue.error('需要存储权限才能解析 PDF', StackTrace.current);
      return;
    }

    state = AsyncValue.loading();
    final result = await _service.parsePdf(
      pdfPath,
      onProgress: (current, total) {
        ref.read(parsePdfProgressProvider(pdfPath).notifier).state = (
          current,
          total,
        );
      },
    );
    result.fold(
      onSuccess: (data) {
        state = AsyncValue.data(
          ParsePdfState(tempPaths: data, pdfName: pdfName),
        );
      },
      onError: (error) {
        state = AsyncValue.error(error.message, StackTrace.current);
      },
    );
  }
}

final parsePdfSaveBookProgressProvider =
    StateProvider<(int current, int total)>((_) => (0, 0));

@riverpod
class ParsePdfSaveBook extends _$ParsePdfSaveBook {
  BookRepository get _repository => ref.read(bookRepositoryProvider);

  @override
  FutureOr<void> build() async {
    return null;
  }

  Future<void> onSave(List<String> tempPaths, String pdfName) async {
    DKLog.i('开始保存解析结果为书籍，tempPaths: $tempPaths, pdfName: $pdfName');
    state = AsyncValue.loading();

    ref.read(parsePdfSaveBookProgressProvider.notifier).state = (
      0,
      tempPaths.length,
    );

    DKLog.i('调用 repository.saveAsBook，开始文件复制和 DB 写入');
    final result = await _repository.saveAsBook(
      SaveAsBookDto(title: pdfName, paths: tempPaths),
      onProgress: (current, total) {
        ref.read(parsePdfSaveBookProgressProvider.notifier).state = (
          current,
          total,
        );
      },
    );

    result.fold(
      onSuccess: (_) {
        DKLog.i('保存书籍成功');
        state = AsyncValue.data(null);
      },
      onError: (e) {
        DKLog.e('保存书籍失败，错误信息：${e.message}');
        state = AsyncValue.error(e.message, StackTrace.current);
      },
    );
  }
}
