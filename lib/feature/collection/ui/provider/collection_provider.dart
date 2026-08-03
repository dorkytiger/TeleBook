import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/ui/provider/book_provider.dart';
import 'package:tele_book/feature/collection/model/vo/collection_list_item_vo.dart';
import 'package:tele_book/feature/collection/repository/collection_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'collection_provider.g.dart';

final collectionsProvider =
    StreamProvider.autoDispose<List<CollectionTableData>>((ref) {
      final repo = ref.watch(collectionRepositoryProvider);
      return repo.watchCollections();
    });

final collectionBooksProvider =
    StreamProvider.autoDispose<List<CollectionBookTableData>>((ref) {
      final repo = ref.watch(collectionRepositoryProvider);
      return repo.watchAllCollectionBooks();
    });

@riverpod
AsyncValue<List<CollectionListItemVo>> collectionList(Ref ref) {
  final collectionsAsync = ref.watch(collectionsProvider);
  final collectionBooksAsync = ref.watch(collectionBooksProvider);
  final booksAsync = ref.watch(booksProvider);

  if (collectionsAsync.hasError) {
    return AsyncError(
      collectionsAsync.error!,
      collectionsAsync.stackTrace ?? StackTrace.current,
    );
  }
  if (collectionBooksAsync.hasError) {
    return AsyncError(
      collectionBooksAsync.error!,
      collectionBooksAsync.stackTrace ?? StackTrace.current,
    );
  }
  if (booksAsync.hasError) {
    return AsyncError(
      booksAsync.error!,
      booksAsync.stackTrace ?? StackTrace.current,
    );
  }
  if (collectionsAsync.isLoading ||
      collectionBooksAsync.isLoading ||
      booksAsync.isLoading) {
    return const AsyncLoading();
  }

  final collections = collectionsAsync.value ?? const <CollectionTableData>[];
  final collectionBooks =
      collectionBooksAsync.value ?? const <CollectionBookTableData>[];
  final books = booksAsync.value ?? const <BookTableData>[];

  final bookCountMap = <int, int>{};
  final bookIdsByCollectionId = <int, List<int>>{};
  for (final cb in collectionBooks) {
    bookCountMap[cb.collectionId] = (bookCountMap[cb.collectionId] ?? 0) + 1;
    bookIdsByCollectionId
        .putIfAbsent(cb.collectionId, () => <int>[])
        .add(cb.bookId);
  }

  final bookById = <int, BookTableData>{for (final b in books) b.id: b};

  final list = collections.map((c) {
    final count = bookCountMap[c.id] ?? 0;
    final coverImages = (bookIdsByCollectionId[c.id] ?? const <int>[])
        .map((bookId) => bookById[bookId])
        .whereType<BookTableData>()
        .where((book) => book.localSubPaths.isNotEmpty)
        .map((book) => book.coverSubPath != null
            ? GlobalConfig.resolveBookPath(book.coverSubPath!)
            : GlobalConfig.resolveBookPath(book.localSubPaths.first))
        .take(4)
        .toList();

    return CollectionListItemVo(
      collection: c,
      count: count,
      coverImages: coverImages,
    );
  }).toList();

  return AsyncData(list);
}

@riverpod
class CreateCollectionController extends _$CreateCollectionController {
  @override
  FutureOr<void> build() {
    // 可以在这里进行一些初始化操作
  }

  Future<void> createCollection({
    required String name,
    String? description,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      state = AsyncError('Collection name cannot be empty', StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(collectionRepositoryProvider);
      await repo.createCollection(name: name, description: description);
    });
  }
}

@riverpod
class UpdateCollectionController extends _$UpdateCollectionController {
  @override
  FutureOr<void> build() => null;

  Future<void> updateCollection({
    required int collectionId,
    required String name,
    String? description,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      state = AsyncError('Collection name cannot be empty', StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(collectionRepositoryProvider);
      await repo.updateCollection(
        CollectionTableData(
          id: collectionId,
          name: name,
          description: description,
        ),
      );
    });
  }
}

@riverpod
class DeleteCollectionController extends _$DeleteCollectionController {
  @override
  FutureOr<void> build() => null;

  Future<void> deleteCollection({required int collectionId}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(collectionRepositoryProvider);
      await repo.deleteCollection(collectionId);
    });
  }
}
