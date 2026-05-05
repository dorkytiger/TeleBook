import 'package:drift/drift.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/db/table/collection/collection_book_table.dart';

part 'collection_book_dao.g.dart';

@DriftAccessor(tables: [CollectionBookTable])
class CollectionBookDao extends DatabaseAccessor<AppDatabase>
    with _$CollectionBookDaoMixin {
  CollectionBookDao(super.attachedDatabase);

  Stream<List<CollectionBookTableData>> getBooksInCollection(int collectionId) {
    return (select(
      collectionBookTable,
    )..where((tbl) => tbl.collectionId.equals(collectionId))).watch();
  }

  Future<CollectionBookTableData?> getCollectionBook(
    int collectionId,
    int bookId,
  ) {
    return (select(
      collectionBookTable,
    )
          ..where((tbl) => tbl.collectionId.equals(collectionId))
          ..where((tbl) => tbl.bookId.equals(bookId)))
        .getSingleOrNull();
  }

  Future<int> insertCollectionBook(int collectionId, int bookId) {
    return into(collectionBookTable).insert(
      CollectionBookTableCompanion(
        collectionId: Value(collectionId),
        bookId: Value(bookId),
      ),
    );
  }

  Future<int> deleteCollectionBook(int bookId) {
    return (delete(
      collectionBookTable,
    )..where((tbl) => tbl.bookId.equals(bookId))).go();
  }
}
