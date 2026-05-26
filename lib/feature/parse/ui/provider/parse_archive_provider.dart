import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
abstract class ParseArchiveSaveBookProgress with _$ParseArchiveSaveBookProgress {
  const factory ParseArchiveSaveBookProgress({
    @Default(0) int current,
    @Default(0) int total,
  }) = _ParseArchiveSaveBookProgress;
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

  Future<void> _parseArchive(String archivePath) async {
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

    result.fold(
      onSuccess: (data) {
        state =
            AsyncData(ParseArchiveState(archiveName: archiveName, tempPaths: data));
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
        ParseArchiveSaveBookProgress(current: 0, total: param.tempPaths.length);

    final result = await _bookRepository.saveAsBook(
      SaveAsBookDto(title: param.archiveName, paths: param.tempPaths),
      onProgress: (current, total) {
        ref.read(parseArchiveSaveBookProgressProvider.notifier).state =
            ParseArchiveSaveBookProgress(current: current, total: total);
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

