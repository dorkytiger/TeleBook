import 'package:drift/drift.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/db/table/collection/collection_table.dart';

part 'collection_dao.g.dart';

@DriftAccessor(tables: [CollectionTable])
class CollectionDao extends DatabaseAccessor<AppDatabase>
    with _$CollectionDaoMixin {
  CollectionDao(super.attachedDatabase);

  Stream<List<CollectionTableData>> getCollections(String? name) {
    final query = select(collectionTable);
    if (name != null && name.isNotEmpty) {
      query.where((tbl) => tbl.name.like('%$name%'));
    }
    return query.watch();
  }

  Future<int> insertCollection(CollectionTableCompanion companion) {
    return into(collectionTable).insert(companion);
  }

  Future<bool> updateCollection(CollectionTableCompanion companion) {
    return update(collectionTable).replace(companion);
  }

  Future<int> deleteById(int id) {
    return (delete(collectionTable)..where((tbl) => tbl.id.equals(id))).go();
  }
}
