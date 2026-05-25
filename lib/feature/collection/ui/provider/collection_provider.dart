import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';
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
  final booksAsync = ref.watch(collectionBooksProvider);

  if (collectionsAsync.hasError) {
    return AsyncError(
      collectionsAsync.error!,
      collectionsAsync.stackTrace ?? StackTrace.current,
    );
  }
  if (booksAsync.hasError) {
    return AsyncError(
      booksAsync.error!,
      booksAsync.stackTrace ?? StackTrace.current,
    );
  }
  if (collectionsAsync.isLoading || booksAsync.isLoading) {
    return const AsyncLoading();
  }

  final collections = collectionsAsync.value ?? const <CollectionTableData>[];
  final books = booksAsync.value ?? const <CollectionBookTableData>[];

  final bookCountMap = <int, int>{};
  for (final cb in books) {
    bookCountMap[cb.collectionId] = (bookCountMap[cb.collectionId] ?? 0) + 1;
  }

  final list = collections.map((c) {
    final count = bookCountMap[c.id] ?? 0;
    return CollectionListItemVo(collection: c, count: count);
  }).toList();

  return AsyncData(list);
}

@riverpod
class CollectionController extends _$CollectionController {
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
