import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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

  @override
  FutureOr<ParsePdfState> build(String pdfPath) async {
    final pdfName = pdfPath.split(RegExp(r'[\\/]')).last.replaceAll('.pdf', '');
    Future.microtask(() => _parsePdf(pdfPath));
    return ParsePdfState(tempPaths: const [], pdfName: pdfName);
  }

  Future<void> _parsePdf(String pdfPath) async {
    final pdfName = pdfPath.split(RegExp(r'[\\/]')).last.replaceAll('.pdf', '');

    ref.read(parsePdfProgressProvider(pdfPath).notifier).state = (0, 0);

    state = AsyncValue.loading();
    final result = await _service.parsePdf(
      pdfName,
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

final parsePdfSaveBookProgressProvider = StateProvider<(int current, int total)>(
  (_) => (0, 0),
);

@riverpod
class ParsePdfSaveBook extends _$ParsePdfSaveBook {
  BookRepository get _repository => ref.read(bookRepositoryProvider);

  @override
  FutureOr<void> build() async => null;

  Future<void> onSave(
    WidgetRef ref,
    List<String> tempPaths,
    String pdfName,
  ) async {
    state = AsyncValue.loading();

    ref.read(parsePdfSaveBookProgressProvider.notifier).state = (0, tempPaths.length);

    final result = await _repository.saveAsBook(
      SaveAsBookDto(title: pdfName, paths: tempPaths),
      onProgress: (current, total) {
        ref.read(parsePdfSaveBookProgressProvider.notifier).state = (current, total);
      },
    );

    result.fold(
      onSuccess: (_) {
        state = AsyncValue.data(null);
      },
      onError: (e) {
        state = AsyncValue.error(e.message, StackTrace.current);
      },
    );
  }
}
