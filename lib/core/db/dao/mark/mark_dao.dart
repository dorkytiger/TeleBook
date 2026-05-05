import 'package:drift/drift.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/db/table/mark/mark_table.dart';

part 'mark_dao.g.dart';

@DriftAccessor(tables: [MarkTable])
class MarkDao extends DatabaseAccessor<AppDatabase>
    with _$MarkDaoMixin {
  MarkDao(super.attachedDatabase);

  Stream<List<MarkTableData>> getMarks(String? name) {
    final query = select(markTable);
    if (name != null && name.isNotEmpty) {
      query.where((tbl) => tbl.name.like('%$name%'));
    }
    return query.watch();
  }

  Future<int> insertMark(MarkTableCompanion companion) {
    return into(markTable).insert(companion);
  }

  Future<bool> updateMark(MarkTableCompanion companion) {
    return update(markTable).replace(companion);
  }

  Future<int> deleteById(int id) {
    return (delete(markTable)..where((tbl) => tbl.id.equals(id))).go();
  }
}