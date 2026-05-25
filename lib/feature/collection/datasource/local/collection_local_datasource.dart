import 'package:drift/drift.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/collection/model/table/collection_table.dart';

part 'collection_local_datasource.g.dart';

@DriftAccessor(tables: [CollectionTable])
class CollectionLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$CollectionLocalDatasourceMixin {
  CollectionLocalDatasource(super.db);

  Stream<List<CollectionTableData>> watchCollections() {
    return (select(collectionTable).watch());
  }

  Future<List<CollectionTableData>> getCollectionsById(int id) {
    return (select(collectionTable)..where((tbl) => tbl.id.equals(id))).get();
  }

  Future<void> insertCollection(CollectionTableCompanion collection) {
    return into(collectionTable).insert(collection);
  }

  Future<void> deleteCollectionById(int id) {
    return (delete(collectionTable)..where((tbl) => tbl.id.equals(id))).go();
  }
}
