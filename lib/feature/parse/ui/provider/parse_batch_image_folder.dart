import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
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
    @Default(AsyncData<void>(null)) AsyncValue<void> submitState,
  }) = _SaveBatchAsBookState;
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
              state = AsyncData(localState);
            },
            (count) {
              localState = localState.copyWith(completeCount: count);
              state = AsyncData(localState);
            },
            onCurrentItemChanged: (fileName) {
              localState = localState.copyWith(
                currentFileName: fileName,
                currentFileProgress: 0,
                currentFileTotal: 0,
              );
              state = AsyncData(localState);
            },
            onCurrentItemProgress: (current, total) {
              localState = localState.copyWith(
                currentFileProgress: current,
                currentFileTotal: total,
              );
              state = AsyncData(localState);
            },
          )
        : await _parseArchiveService.parseBatchImageFolders(
            param.parentDirPath ?? '',
            (total) {
              localState = localState.copyWith(totalCount: total);
              state = AsyncData(localState);
            },
            (count) {
              localState = localState.copyWith(completeCount: count);
              state = AsyncData(localState);
            },
            onCurrentItemChanged: (fileName) {
              localState = localState.copyWith(
                currentFileName: fileName,
                currentFileProgress: 0,
                currentFileTotal: 0,
              );
              state = AsyncData(localState);
            },
            onCurrentItemProgress: (current, total) {
              localState = localState.copyWith(
                currentFileProgress: current,
                currentFileTotal: total,
              );
              state = AsyncData(localState);
            },
          );

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
  BookRepository get _bookRepository => ref.read(bookRepositoryProvider);

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

    final result = await _bookRepository.saveBatchAsBooks(dos, (count) {
      state = state.copyWith(saveAsBookCount: count);
    });

    result.fold(
      onSuccess: (_) {
        state = state.copyWith(
          submitState: const AsyncData(null),
          saveAsBookCount: 0,
        );
      },
      onError: (error) {
        state = state.copyWith(
          submitState: AsyncValue.error(
            error.message,
            StackTrace.current,
          ),
        );
      },
    );
  }
}
