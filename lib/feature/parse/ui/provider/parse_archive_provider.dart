import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/parse/service/parse_archive_service.dart';

part 'parse_archive_provider.freezed.dart';

part 'parse_archive_provider.g.dart';

@freezed
abstract class ParseArchiveState with _$ParseArchiveState {
  const factory ParseArchiveState({
    required String archiveName,
    required List<String> tempPaths,
  }) = _ParseArchiveState;
}

@freezed
abstract class ParseArchiveSaveBookParam with _$ParseArchiveSaveBookParam {
  const factory ParseArchiveSaveBookParam({
    required String archiveName,
    required List<String> tempPaths,
  }) = _ParseArchiveSaveBookParam;
}

@freezed
abstract class ParseArchiveSaveBookProgress
    with _$ParseArchiveSaveBookProgress {
  const factory ParseArchiveSaveBookProgress({
    @Default(SaveStep.generateCover) SaveStep step,
    @Default(0) int current,
    @Default(0) int total,
  }) = _ParseArchiveSaveBookProgress;

  const ParseArchiveSaveBookProgress._();

  String get stepText => switch (step) {
    SaveStep.generateCover => '生成封面图...',
    SaveStep.generatePreview => '生成预览图... ($current/$total)',
    SaveStep.saveOriginal => '保存原图... ($current/$total)',
    SaveStep.saveDatabase => '保存中...',
  };
}

final parseArchiveProgressProvider =
    StateProvider.family<(int current, int total), String>((_, __) => (0, 0));

final parseArchiveSaveBookProgressProvider =
    StateProvider<ParseArchiveSaveBookProgress>(
      (_) => const ParseArchiveSaveBookProgress(),
    );

@riverpod
class ParseArchive extends _$ParseArchive {
  ParseArchiveService get _parseArchiveService =>
      ref.read(parseArchiveServiceProvider);

  @override
  FutureOr<ParseArchiveState> build(String archivePath) async {
    final archiveName = archivePath.split(RegExp(r'[\\/]')).last;
    Future.microtask(() => _parseArchive(archivePath));
    return ParseArchiveState(archiveName: archiveName, tempPaths: const []);
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

  Future<void> _parseArchive(String archivePath) async {
    final hasPermission = await _requestStoragePermission();
    if (!ref.mounted) return;
    if (!hasPermission) {
      state = AsyncError('需要存储权限才能解析压缩包', StackTrace.current);
      return;
    }

    final archiveName = archivePath.split(RegExp(r'[\\/]')).last;

    ref.read(parseArchiveProgressProvider(archivePath).notifier).state = (0, 0);
    state = const AsyncLoading();

    final result = await _parseArchiveService.parseArchive(
      archivePath,
      onProgress: (current, total) {
        ref.read(parseArchiveProgressProvider(archivePath).notifier).state = (
          current,
          total,
        );
      },
    );

    if (!ref.mounted) return;
    result.fold(
      onSuccess: (data) {
        state = AsyncData(
          ParseArchiveState(archiveName: archiveName, tempPaths: data),
        );
      },
      onError: (error) {
        state = AsyncError(error.message, StackTrace.current);
      },
    );
  }
}

@riverpod
class ParseArchiveSaveBook extends _$ParseArchiveSaveBook {
  BookRepository get _bookRepository => ref.read(bookRepositoryProvider);

  @override
  FutureOr<void> build() => null;

  Future<void> submit(ParseArchiveSaveBookParam param) async {
    if (state.isLoading || param.tempPaths.isEmpty) return;

    state = const AsyncLoading();
    ref.read(parseArchiveSaveBookProgressProvider.notifier).state =
        ParseArchiveSaveBookProgress(
          step: SaveStep.generateCover,
          current: 0,
          total: param.tempPaths.length,
        );

    final result = await _bookRepository.saveAsBook(
      SaveAsBookDto(title: param.archiveName, paths: param.tempPaths),
      onStepProgress: (step, current, total) {
        ref.read(parseArchiveSaveBookProgressProvider.notifier).state =
            ParseArchiveSaveBookProgress(
              step: step,
              current: current,
              total: total,
            );
      },
    );

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
