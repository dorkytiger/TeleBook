import 'package:drift/drift.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/collection/model/table/collection_book_table.dart';

part 'collection_book_local_datasource.g.dart';

@DriftAccessor(tables: [CollectionBookTable])
class CollectionBookLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$CollectionBookLocalDatasourceMixin {
  CollectionBookLocalDatasource(super.db);

  Stream<List<CollectionBookTableData>> watchAllCollectionBooks() {
    return select(collectionBookTable).watch();
  }

  Future<List<CollectionBookTableData>> getAllCollectionBooks() {
    return select(collectionBookTable).get();
  }

  Future<void> insertCollectionBook(CollectionBookTableCompanion entry) {
    return into(collectionBookTable).insert(entry);
  }

  Future<void> updateCollectionBook(CollectionBookTableData entry) {
    return update(collectionBookTable).replace(entry);
  }

  Future<void> insertCollectionBooks(List<CollectionBookTableCompanion> entries) {
    return batch((batch) {
      batch.insertAll(collectionBookTable, entries);
    });
  }

  Future<void> removeBookFromCollection(int collection, int bookId) {
    return (delete(
      collectionBookTable,
    )
      ..where((tbl) => tbl.collectionId.equals(collection) & tbl.bookId.equals(bookId)))
        .go();
  }


  Future<void> deleteCollectionBook(int id) {
    return (delete(
      collectionBookTable,
    )..where((tbl) => tbl.id.equals(id))).go();
  }
}
