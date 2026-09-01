import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/sync/service/sync_mutation_service.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:tele_book/feature/parse/service/parse_archive_service.dart';

part 'parse_batch_image_folder.freezed.dart';

part 'parse_batch_image_folder.g.dart';

@freezed
abstract class ParseBatchImageFolderState with _$ParseBatchImageFolderState {
  const factory ParseBatchImageFolderState({
    @Default([]) List<ParseBatchArchiveVo> parseBatchFolderList,
    @Default(0) int completeCount,
    @Default(0) int totalCount,
    @Default('') String currentFileName,
    @Default(0) int currentFileProgress,
    @Default(0) int currentFileTotal,
    @Default(false) bool isParsing,
  }) = _ParseBatchImageFolderState;

  const ParseBatchImageFolderState._();

  String get currentFileProgressText {
    if (currentFileName.isEmpty) return '';
    if (currentFileTotal <= 0) return '当前文件进度，准备中';
    return '当前文件进度，$currentFileProgress / $currentFileTotal';
  }
}

@freezed
abstract class SaveBatchAsBookState with _$SaveBatchAsBookState {
  const factory SaveBatchAsBookState({
    @Default(0) int saveAsBookCount,
    @Default(0) int totalCount,
    @Default(SaveStep.generateCover) SaveStep step,
    @Default(0) int stepCurrent,
    @Default(0) int stepTotal,
    @Default(0) int bookIndex,
    @Default(AsyncData<void>(null)) AsyncValue<void> submitState,
  }) = _SaveBatchAsBookState;

  const SaveBatchAsBookState._();

  String get stepText {
    final bookInfo = totalCount > 0 ? '(${bookIndex + 1}/$totalCount) ' : '';
    return switch (step) {
      SaveStep.generateCover => '$bookInfo生成封面图...',
      SaveStep.generatePreview => '$bookInfo生成预览图... ($stepCurrent/$stepTotal)',
      SaveStep.saveOriginal => '$bookInfo保存原图... ($stepCurrent/$stepTotal)',
      SaveStep.saveDatabase => '保存数据...',
    };
  }
}

@freezed
abstract class ParseBatchImageFolderParam with _$ParseBatchImageFolderParam {
  const factory ParseBatchImageFolderParam({
    String? parentDirPath,
    List<String>? imagePaths,
  }) = _ParseBatchImageFolderParam;
}

@riverpod
class ParseBatchImageFolder extends _$ParseBatchImageFolder {
  ParseArchiveService get _parseArchiveService =>
      ref.read(parseArchiveServiceProvider);

  @override
  FutureOr<ParseBatchImageFolderState> build(ParseBatchImageFolderParam param) {
    Future.microtask(() => _parseBatchFolders(param));
    return const ParseBatchImageFolderState(isParsing: true);
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

  Future<void> _parseBatchFolders(ParseBatchImageFolderParam param) async {
    state = AsyncData(
      state.value?.copyWith(
            isParsing: true,
            parseBatchFolderList: const <ParseBatchArchiveVo>[],
            totalCount: 0,
            completeCount: 0,
            currentFileName: '',
            currentFileProgress: 0,
            currentFileTotal: 0,
          ) ??
          const ParseBatchImageFolderState(isParsing: true),
    );

    final hasPermission = await _requestStoragePermission();
    if (!ref.mounted) return;
    if (!hasPermission) {
      state = AsyncValue.error("需要存储权限才能读取图片文件夹", StackTrace.current);
      return;
    }

    var localState = state.value ??
        const ParseBatchImageFolderState(isParsing: true);

    final result = param.imagePaths != null && param.imagePaths!.isNotEmpty
        ? await _parseArchiveService.parseBatchImageFoldersFromPaths(
            param.imagePaths!,
            (total) {
              localState = localState.copyWith(totalCount: total);
              if (!ref.mounted) return;
              state = AsyncData(localState);
            },
            (count) {
              localState = localState.copyWith(completeCount: count);
              if (!ref.mounted) return;
              state = AsyncData(localState);
            },
            onCurrentItemChanged: (fileName) {
              localState = localState.copyWith(
                currentFileName: fileName,
                currentFileProgress: 0,
                currentFileTotal: 0,
              );
              if (!ref.mounted) return;
              state = AsyncData(localState);
            },
            onCurrentItemProgress: (current, total) {
              localState = localState.copyWith(
                currentFileProgress: current,
                currentFileTotal: total,
              );
              if (!ref.mounted) return;
              state = AsyncData(localState);
            },
          )
        : await _parseArchiveService.parseBatchImageFolders(
            param.parentDirPath ?? '',
            (total) {
              localState = localState.copyWith(totalCount: total);
              if (!ref.mounted) return;
              state = AsyncData(localState);
            },
            (count) {
              localState = localState.copyWith(completeCount: count);
              if (!ref.mounted) return;
              state = AsyncData(localState);
            },
            onCurrentItemChanged: (fileName) {
              localState = localState.copyWith(
                currentFileName: fileName,
                currentFileProgress: 0,
                currentFileTotal: 0,
              );
              if (!ref.mounted) return;
              state = AsyncData(localState);
            },
            onCurrentItemProgress: (current, total) {
              localState = localState.copyWith(
                currentFileProgress: current,
                currentFileTotal: total,
              );
              if (!ref.mounted) return;
              state = AsyncData(localState);
            },
          );

    if (!ref.mounted) return;
    result.fold(
      onSuccess: (data) {
        state = AsyncData(localState.copyWith(
          parseBatchFolderList: data,
          isParsing: false,
        ));
      },
      onError: (error) {
        state = AsyncValue.error(error.message, StackTrace.current);
      },
    );
  }

  Future<void> refresh() async {
    await _parseBatchFolders(param);
  }
}

@riverpod
class SaveBatchAsBook extends _$SaveBatchAsBook {

  @override
  SaveBatchAsBookState build(ParseBatchImageFolderParam param) {
    return const SaveBatchAsBookState();
  }

  Future<void> submit(List<ParseBatchArchiveVo> parseList) async {
    if (state.submitState.isLoading) return;
    state = state.copyWith(
      submitState: const AsyncLoading(),
      saveAsBookCount: 0,
      totalCount: parseList.length,
    );

    final dos = parseList
        .map((e) => SaveAsBookDto(title: e.name, paths: e.tempPaths))
        .toList();

    try {
      await ref.read(syncMutationServiceProvider).enqueueBatchBookImport(
        dos,
        onProgress:
        (count) {
          state = state.copyWith(saveAsBookCount: count);
        },
      );
      state = state.copyWith(
        submitState: const AsyncData(null),
        saveAsBookCount: 0,
      );
    } catch (e) {
      state = state.copyWith(
        submitState: AsyncValue.error(
          '$e',
          StackTrace.current,
        ),
      );
    }
  }
}
