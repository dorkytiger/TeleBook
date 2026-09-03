import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/sync/model/table/sync_upload_table.dart';

part 'sync_upload_local_datasource.g.dart';

final syncUploadLocalDatasourceProvider = Provider<SyncUploadLocalDatasource>((
  ref,
) {
  return SyncUploadLocalDatasource(ref.watch(databaseProvider));
});

/// 待上传书籍数据访问（§8.2：文件级断点）。
@DriftAccessor(tables: [SyncUploadTable])
class SyncUploadLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$SyncUploadLocalDatasourceMixin {
  SyncUploadLocalDatasource(super.attachedDatabase);

  /// 落库一本书的上传任务。
  Future<void> insertBook(SyncUploadTableCompanion book) {
    return into(syncUploadTable).insertOnConflictUpdate(book);
  }

  /// 全部待上传书。
  Future<List<SyncUploadTableData>> listAll() {
    return (select(syncUploadTable)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .get();
  }

  /// 监听全部待上传书（实时刷新）。
  Stream<List<SyncUploadTableData>> watchAll() {
    return (select(syncUploadTable)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .watch();
  }

  /// 更新整书状态 + 已上传计数。
  Future<void> updateBook(
    String uuid, {
    String? status,
    String? bookStatus,
    int? doneFiles,
    String? dataVersion,
  }) {
    return (update(syncUploadTable)..where((t) => t.uuid.equals(uuid))).write(
      SyncUploadTableCompanion(
        status: status != null ? Value(status) : const Value.absent(),
        bookStatus: bookStatus != null ? Value(bookStatus) : const Value.absent(),
        doneFiles: doneFiles != null ? Value(doneFiles) : const Value.absent(),
        dataVersion: dataVersion != null ? Value(dataVersion) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 删除一本书（上传完成/失败清理）。
  Future<void> deleteBook(String uuid) {
    return (delete(syncUploadTable)..where((t) => t.uuid.equals(uuid))).go();
  }
}
