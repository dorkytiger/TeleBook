import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:tele_book/feature/parse/service/parse_archive_service.dart';

part 'parse_batch_archive_provider.freezed.dart';

part 'parse_batch_archive_provider.g.dart';

@freezed
abstract class ParseBatchArchiveParam with _$ParseBatchArchiveParam {
  const factory ParseBatchArchiveParam({
    String? archiveDirPath,
    List<String>? archivePaths,
  }) = _ParseBatchArchiveParam;
}

@freezed
abstract class ParseBatchArchiveState with _$ParseBatchArchiveState {
  const factory ParseBatchArchiveState({
    required List<ParseBatchArchiveVo> parseBatchArchiveList,
  }) = _ParseBatchArchiveState;
}

@freezed
abstract class ParseBatchArchiveProgress with _$ParseBatchArchiveProgress {
  const factory ParseBatchArchiveProgress({
    required int completeCount,
    required int totalCount,
    required String currentFileName,
    required int currentFileProgress,
    required int currentFileTotal,
  }) = _ParseBatchArchiveProgress;

  const ParseBatchArchiveProgress._();

  String get currentFileProgressText {
    if (currentFileName.isEmpty) return '';
    if (currentFileTotal <= 0) return '当前文件进度：准备中';
    return '当前文件进度：$currentFileProgress / $currentFileTotal';
  }
}

@freezed
abstract class ParseBatchArchiveSaveBookProgress
    with _$ParseBatchArchiveSaveBookProgress {
  const factory ParseBatchArchiveSaveBookProgress({
    @Default(0) int current,
    @Default(0) int total,
    @Default(SaveStep.generateCover) SaveStep step,
    @Default(0) int stepCurrent,
    @Default(0) int stepTotal,
    @Default(0) int bookIndex,
  }) = _ParseBatchArchiveSaveBookProgress;

  const ParseBatchArchiveSaveBookProgress._();

  String get stepText {
    final bookInfo = total > 0 ? '(${bookIndex + 1}/$total) ' : '';
    return switch (step) {
      SaveStep.generateCover => '$bookInfo生成封面图...',
      SaveStep.generatePreview => '$bookInfo生成预览图... ($stepCurrent/$stepTotal)',
      SaveStep.saveOriginal => '$bookInfo保存原图... ($stepCurrent/$stepTotal)',
      SaveStep.saveDatabase => '保存数据...',
    };
  }
}

final parseBatchArchiveProgressProvider =
    StateProvider<ParseBatchArchiveProgress>(
      (_) => const ParseBatchArchiveProgress(
        completeCount: 0,
        totalCount: 0,
        currentFileName: '',
        currentFileProgress: 0,
        currentFileTotal: 0,
      ),
    );

final parseBatchArchiveSaveBookProgressProvider =
    StateProvider<ParseBatchArchiveSaveBookProgress>(
      (_) => const ParseBatchArchiveSaveBookProgress(),
    );

@riverpod
class ParseBatchArchive extends _$ParseBatchArchive {
  ParseArchiveService get _parseArchiveService =>
      ref.read(parseArchiveServiceProvider);

  late final ParseBatchArchiveParam _param;

  @override
  FutureOr<ParseBatchArchiveState> build(ParseBatchArchiveParam param) async {
    _param = param;
    return _parseBatchArchive();
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

  Future<ParseBatchArchiveState> _parseBatchArchive() async {
    state = const AsyncLoading();
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      throw Exception('需要「所有文件访问权限」才能读取外部目录，请在系统设置中授权后重试。');
    }

    final parseResult =
        _param.archivePaths != null && _param.archivePaths!.isNotEmpty
        ? await _parseArchiveService.parseBatchArchivesFromPaths(
            _param.archivePaths!,
            _onStart,
            _onProgress,
            onCurrentItemChanged: _onCurrentItemChanged,
            onCurrentItemProgress: _onCurrentItemProgress,
          )
        : await _parseArchiveService.parseBatchArchives(
            _param.archiveDirPath ?? '',
            _onStart,
            _onProgress,
            onCurrentItemChanged: _onCurrentItemChanged,
            onCurrentItemProgress: _onCurrentItemProgress,
          );

    if (parseResult.isError) {
      throw Exception(parseResult.error?.message);
    }

    return ParseBatchArchiveState(parseBatchArchiveList: parseResult.data!);
  }

  void _onStart(int total) {
    if (!ref.mounted) return;
    final current = ref.read(parseBatchArchiveProgressProvider);
    ref.read(parseBatchArchiveProgressProvider.notifier).state = current
        .copyWith(totalCount: total);
  }

  void _onProgress(int count) {
    if (!ref.mounted) return;
    final current = ref.read(parseBatchArchiveProgressProvider);
    ref.read(parseBatchArchiveProgressProvider.notifier).state = current
        .copyWith(completeCount: count);
  }

  void _onCurrentItemChanged(String fileName) {
    if (!ref.mounted) return;
    final current = ref.read(parseBatchArchiveProgressProvider);
    ref.read(parseBatchArchiveProgressProvider.notifier).state = current
        .copyWith(
          currentFileName: fileName,
          currentFileProgress: 0,
          currentFileTotal: 0,
        );
  }

  void _onCurrentItemProgress(int currentCount, int total) {
    if (!ref.mounted) return;
    final current = ref.read(parseBatchArchiveProgressProvider);
    ref.read(parseBatchArchiveProgressProvider.notifier).state = current
        .copyWith(currentFileProgress: currentCount, currentFileTotal: total);
  }
}

@riverpod
class ParseBatchArchiveSaveBook extends _$ParseBatchArchiveSaveBook {
  BookRepository get _bookRepository => ref.read(bookRepositoryProvider);

  @override
  FutureOr<void> build() => null;

  Future<void> saveBatchAsBook(List<ParseBatchArchiveVo> parseBatchList) async {
    if (state.isLoading || parseBatchList.isEmpty) return;

    state = const AsyncLoading();
    ref
        .read(parseBatchArchiveSaveBookProgressProvider.notifier)
        .state = ParseBatchArchiveSaveBookProgress(
      current: 0,
      total: parseBatchList.length,
    );

    final dos = parseBatchList
        .map((e) => SaveAsBookDto(title: e.name, paths: e.tempPaths))
        .toList();

    final result = await _bookRepository.saveBatchAsBooks(dos, (count) {
      ref
          .read(parseBatchArchiveSaveBookProgressProvider.notifier)
          .state = ParseBatchArchiveSaveBookProgress(
        current: count,
        total: parseBatchList.length,
      );
    });

    result.fold(
      onSuccess: (_) {
        state = const AsyncData(null);
      },
      onError: (error) {
        state = AsyncError(error.message, StackTrace.current);
      },
    );
  }
}
