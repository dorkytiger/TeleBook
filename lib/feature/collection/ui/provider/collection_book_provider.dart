import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/feature/book/model/state/book_list_state.dart';
import 'package:tele_book/feature/book/ui/provider/book_provider.dart';
import 'package:tele_book/feature/collection/ui/provider/collection_provider.dart';

part 'collection_book_provider.freezed.dart';

part 'collection_book_provider.g.dart';

@freezed
abstract class CollectionBookState with _$CollectionBookState {
  const factory CollectionBookState({@Default([]) List<BookListItemVo> books}) =
      _CollectionBookState;
}

@riverpod
AsyncValue<CollectionBookState> collectionBookView(Ref ref,int collectionId) {

  final collectionsBooksAsync = ref.watch(collectionBooksProvider);
  final booksAsync = ref.watch(booksProvider);

  if (collectionsBooksAsync.hasError) {
    return AsyncValue.error(collectionsBooksAsync.error!, StackTrace.current);
  }
  if (booksAsync.hasError) {
    return AsyncValue.error(booksAsync.error!, StackTrace.current);
  }

  if (collectionsBooksAsync.isLoading || booksAsync.isLoading) {
    return const AsyncValue.loading();
  }

  final collectionsBooks = collectionsBooksAsync.value!.where((e) => e.collectionId == collectionId).toList();
  final books = booksAsync.value!;

  final collectionBookIds = collectionsBooks.map((e) => e.bookId).toSet();
  final collectionBooks = books
      .where((book) => collectionBookIds.contains(book.id))
      .toList();

  final items = collectionBooks.map((book) {
    final coverImagePath = GlobalConfig.resolveBookPath(
      book.localSubPaths.first,
    );
    return BookListItemVo(book: book, coverImagePath: coverImagePath);
  }).toList();

  return AsyncValue.data(CollectionBookState(books: items));
}
