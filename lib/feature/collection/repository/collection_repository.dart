import 'package:drift/drift.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';

final collectionRepositoryProvider = Provider<CollectionRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return CollectionRepository(database);
});

class CollectionRepository {
  final AppDatabase _db;

  CollectionRepository(this._db);

  Stream<List<CollectionTableData>> watchCollections() =>
      _db.collectionLocalDatasource.watchCollections();

  Stream<List<CollectionBookTableData>> watchAllCollectionBooks() =>
      _db.collectionBookLocalDatasource.watchAllCollectionBooks();

  Future<void> createCollection({
    required String name,
    String? description,
  }) async {
    await _db.collectionLocalDatasource.insertCollection(
      CollectionTableCompanion.insert(
        name: name,
        description: Value(description),
      ),
    );
  }

  Future<void> addBooksToCollection({
    required int collectionId,
    required List<int> bookIds,
  }) async {
    final entries = bookIds.map((bookId) => CollectionBookTableCompanion.insert(
      collectionId: collectionId,
      bookId: bookId,
    )).toList();
    await _db.collectionBookLocalDatasource.insertCollectionBooks(entries);
  }

  Future<void> removeBookFromCollection({
    required int collectionId,
    required int bookId,
  }) async {
    await _db.collectionBookLocalDatasource.removeBookFromCollection(
      collectionId,
      bookId,
    );
  }

  Future<void> updateCollection(CollectionTableData collection) async {
    await _db.collectionLocalDatasource.updateCollection(collection);
  }

  Future<void> deleteCollection(int id) async {
    await _db.collectionLocalDatasource.deleteCollectionById(id);
  }
}
