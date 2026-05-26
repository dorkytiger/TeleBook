import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:tele_book/feature/parse/service/parse_pdf_service.dart';

part 'parse_batch_pdf_provider.freezed.dart';

part 'parse_batch_pdf_provider.g.dart';

@freezed
abstract class ParseBatchPdfProgress with _$ParseBatchPdfProgress {
  const factory ParseBatchPdfProgress({
    required int completeCount,
    required int totalCount,
    required String currentFileName,
    required int currentFileProgress,
    required int currentFileTotal,
  }) = _ParseBatchPdfProgress;
}

@freezed
abstract class ParseBatchPdfState with _$ParseBatchPdfState {
  const factory ParseBatchPdfState({
    required List<ParseBatchArchiveVo> parseBatchList,
  }) = _ParseBatchPdfState;
}

@freezed
abstract class ParseBatchPdfParam with _$ParseBatchPdfParam {
  const factory ParseBatchPdfParam({
    required String? pdfDirPath,
    required List<String>? pdfPaths,
  }) = _ParseBatchPdfParam;
}

@freezed
abstract class ParseBatchPdfSaveBookProgressState
    with _$ParseBatchPdfSaveBookProgressState {
  const factory ParseBatchPdfSaveBookProgressState({
    @Default(0) int current,
    @Default(0) int total,
  }) = _ParseBatchPdfSaveBookProgressState;
}

final parseBatchProgressProvider = StateProvider<ParseBatchPdfProgress>((ref) {
  return ParseBatchPdfProgress(
    completeCount: 0,
    totalCount: 0,
    currentFileName: '',
    currentFileProgress: 0,
    currentFileTotal: 0,
  );
});

@riverpod
class ParseBatchPdf extends _$ParseBatchPdf {
  ParsePdfService get _service => ref.read(parsePdfServiceProvider);

  late final ParseBatchPdfParam _param;

  @override
  FutureOr<ParseBatchPdfState> build(ParseBatchPdfParam param) async {
    _param = param;
    Future.microtask(_parseBatch);
    return const ParseBatchPdfState(parseBatchList: []);
  }

  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;
    if (await Permission.manageExternalStorage.isGranted) return true;
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) return true;
    if (await Permission.storage.isGranted) return true;
    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  Future<void> _parseBatch() async {
    final current = state.value ?? const ParseBatchPdfState(parseBatchList: []);
    ref
        .read(parseBatchProgressProvider.notifier)
        .state = const ParseBatchPdfProgress(
      completeCount: 0,
      totalCount: 0,
      currentFileName: '',
      currentFileProgress: 0,
      currentFileTotal: 0,
    );

    state = const AsyncValue.loading();
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      state = AsyncValue.error("需要存储权限才能解析PDF", StackTrace.current);
      return;
    }

    final pdfPaths = _param.pdfPaths;
    final pdfDirPath = _param.pdfDirPath;
    final parseResult = pdfPaths != null && pdfPaths.isNotEmpty
        ? await _service.parseBatchPdfsFromPaths(
            pdfPaths,
            (total) {
              final progress = ref.read(parseBatchProgressProvider);
              ref.read(parseBatchProgressProvider.notifier).state = progress
                  .copyWith(totalCount: total);
            },
            (count) {
              final progress = ref.read(parseBatchProgressProvider);
              ref.read(parseBatchProgressProvider.notifier).state = progress
                  .copyWith(completeCount: count);
            },
            onCurrentFileChanged: (fileName) {
              final progress = ref.read(parseBatchProgressProvider);
              ref.read(parseBatchProgressProvider.notifier).state = progress
                  .copyWith(
                    currentFileName: fileName,
                    currentFileProgress: 0,
                    currentFileTotal: 0,
                  );
            },
            onCurrentFileProgress: (current, total) {
              final progress = ref.read(parseBatchProgressProvider);
              ref.read(parseBatchProgressProvider.notifier).state = progress
                  .copyWith(
                    currentFileProgress: current,
                    currentFileTotal: total,
                  );
            },
          )
        : await _service.parseBatchPdfs(
            pdfDirPath ?? '',
            (total) {
              final progress = ref.read(parseBatchProgressProvider);
              ref.read(parseBatchProgressProvider.notifier).state = progress
                  .copyWith(totalCount: total);
            },
            (count) {
              final progress = ref.read(parseBatchProgressProvider);
              ref.read(parseBatchProgressProvider.notifier).state = progress
                  .copyWith(completeCount: count);
            },
            onCurrentFileChanged: (fileName) {
              final progress = ref.read(parseBatchProgressProvider);
              ref.read(parseBatchProgressProvider.notifier).state = progress
                  .copyWith(
                    currentFileName: fileName,
                    currentFileProgress: 0,
                    currentFileTotal: 0,
                  );
            },
            onCurrentFileProgress: (current, total) {
              final progress = ref.read(parseBatchProgressProvider);
              ref.read(parseBatchProgressProvider.notifier).state = progress
                  .copyWith(
                    currentFileProgress: current,
                    currentFileTotal: total,
                  );
            },
          );

    parseResult.fold(
      onSuccess: (data) {
        state = AsyncValue.data(current.copyWith(parseBatchList: data));
      },
      onError: (error) {
        state = AsyncValue.error(error.message, StackTrace.current);
      },
    );
  }
}

final parseBatchPdfSaveBookProgressProvider =
    StateProvider<ParseBatchPdfSaveBookProgressState>((ref) {
      return const ParseBatchPdfSaveBookProgressState();
    });

@riverpod
class ParseBatchPdfSaveBook extends _$ParseBatchPdfSaveBook {
  BookRepository get _repository => ref.read(bookRepositoryProvider);

  @override
  FutureOr<void> build() => null;

  Future<void> saveBatchAsBook(List<ParseBatchArchiveVo> parseBatchList) async {
    if (parseBatchList.isEmpty) return;

    state = const AsyncValue.loading();

    final dos = parseBatchList
        .map((e) => SaveAsBookDto(title: e.name, paths: e.tempPaths))
        .toList();

    final result = await _repository.saveBatchAsBooks(dos, (count) {
      final progress = ref.read(parseBatchPdfSaveBookProgressProvider);
      ref.read(parseBatchPdfSaveBookProgressProvider.notifier).state = progress
          .copyWith(current: count);
    });

    result.fold(
      onSuccess: (_) {
        state = const AsyncValue.data(null);
      },
      onError: (error) {
        state = AsyncError(error.message, StackTrace.current);
      },
    );
  }
}
