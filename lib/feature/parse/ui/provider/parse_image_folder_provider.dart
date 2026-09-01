import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/sync/service/sync_mutation_service.dart';
import 'package:tele_book/feature/parse/service/parse_archive_service.dart';

part 'parse_image_folder_provider.freezed.dart';

part 'parse_image_folder_provider.g.dart';

@freezed
abstract class ParseImageFolderParam with _$ParseImageFolderParam {
  const factory ParseImageFolderParam({
    String? folderPath,
    List<String>? imagePathsInput,
  }) = _ParseImageFolderParam;
}

@freezed
abstract class ParseImageFolderState with _$ParseImageFolderState {
  const factory ParseImageFolderState({
    required String folderName,
    required List<String> imagePaths,
  }) = _ParseImageFolderState;
}

@freezed
abstract class ParseImageFolderSaveBookParam
    with _$ParseImageFolderSaveBookParam {
  const factory ParseImageFolderSaveBookParam({
    required String folderName,
    required List<String> imagePaths,
  }) = _ParseImageFolderSaveBookParam;
}

@freezed
abstract class ParseImageFolderSaveBookProgress
    with _$ParseImageFolderSaveBookProgress {
  const factory ParseImageFolderSaveBookProgress({
    @Default(SaveStep.generateCover) SaveStep step,
    @Default(0) int current,
    @Default(0) int total,
  }) = _ParseImageFolderSaveBookProgress;

  const ParseImageFolderSaveBookProgress._();

  String get stepText => switch (step) {
    SaveStep.generateCover => '生成封面图...',
    SaveStep.generatePreview => '生成预览图... ($current/$total)',
    SaveStep.saveOriginal => '保存原图... ($current/$total)',
    SaveStep.saveDatabase => '保存中...',
  };
}

final parseImageFolderSaveBookProgressProvider =
    StateProvider.family<
      ParseImageFolderSaveBookProgress,
      ParseImageFolderParam
    >((_, __) => const ParseImageFolderSaveBookProgress());

@riverpod
class ParseImageFolder extends _$ParseImageFolder {
  ParseArchiveService get _parseArchiveService =>
      ref.read(parseArchiveServiceProvider);

  @override
  FutureOr<ParseImageFolderState> build(ParseImageFolderParam param) async {
    return await _parseImageFolder(param);
  }

  String _resolveFolderName(ParseImageFolderParam param) {
    final folderPath = param.folderPath;
    final imagePathsInput = param.imagePathsInput;
    if (folderPath != null && folderPath.isNotEmpty) {
      return folderPath.split(RegExp(r'[\\/]')).last;
    }

    if (imagePathsInput != null && imagePathsInput.isNotEmpty) {
      final parts = imagePathsInput.first.split(RegExp(r'[\\/]'));
      return parts.length > 1 ? parts[parts.length - 2] : '导入图片';
    }

    return '导入图片';
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

  Future<ParseImageFolderState> _parseImageFolder(
    ParseImageFolderParam param,
  ) async {
    state = const AsyncLoading();

    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      throw Exception('需要存储权限才能读取图片文件夹');
    }

    final folderName = _resolveFolderName(param);
    final result =
        param.imagePathsInput != null && param.imagePathsInput!.isNotEmpty
        ? await _parseArchiveService.parseImagePaths(param.imagePathsInput!)
        : await _parseArchiveService.parseImageFolder(param.folderPath ?? '');

    if (result.isError) {
      throw Exception(result.error?.message);
    }

    return ParseImageFolderState(
      folderName: folderName,
      imagePaths: result.data!,
    );
  }
}

@riverpod
class ParseImageFolderSaveBook extends _$ParseImageFolderSaveBook {

  @override
  FutureOr<void> build(ParseImageFolderParam param) => null;

  Future<void> submit(ParseImageFolderSaveBookParam submitParam) async {
    if (state.isLoading || submitParam.imagePaths.isEmpty) return;

    state = const AsyncLoading();
    ref
        .read(parseImageFolderSaveBookProgressProvider(param).notifier)
        .state = ParseImageFolderSaveBookProgress(
      step: SaveStep.generateCover,
      current: 0,
      total: submitParam.imagePaths.length,
    );

    try {
      await ref.read(syncMutationServiceProvider).enqueueBookImport(
        SaveAsBookDto(
          title: submitParam.folderName,
          paths: submitParam.imagePaths,
        ),
        onStepProgress: (step, current, total) {
          ref
              .read(parseImageFolderSaveBookProgressProvider(param).notifier)
              .state = ParseImageFolderSaveBookProgress(
            step: step,
            current: current,
            total: total,
          );
        },
      );
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError('$e', StackTrace.current);
    }
  }
}
