import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/sync/model/table/sync_down_file_table.dart';
import 'package:tele_book/feature/sync/model/table/sync_down_table.dart';

part 'sync_down_local_datasource.g.dart';

final syncDownLocalDatasourceProvider = Provider<SyncDownLocalDatasource>((
  ref,
) {
  return SyncDownLocalDatasource(ref.watch(databaseProvider));
});

/// 待下载书籍数据访问（§8.1：页级断点）。
@DriftAccessor(tables: [SyncDownTable, SyncDownFileTable])
class SyncDownLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$SyncDownLocalDatasourceMixin {
  SyncDownLocalDatasource(super.attachedDatabase);

  /// 落库一本书及其文件清单（初始化同步拉元数据后）。
  Future<void> insertBook(
    SyncDownTableCompanion book,
    List<SyncDownFileTableCompanion> files,
  ) async {
    await into(syncDownTable).insertOnConflictUpdate(book);
    for (final f in files) {
      await into(syncDownFileTable).insertOnConflictUpdate(f);
    }
  }

  /// 全部待下载书（明细面板/队列用）。
  Future<List<SyncDownTableData>> listAll() {
    return (select(syncDownTable)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .get();
  }

  /// 监听全部待下载书（实时刷新）。
  Stream<List<SyncDownTableData>> watchAll() {
    return (select(syncDownTable)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .watch();
  }

  /// 某书的全部文件。
  Future<List<SyncDownFileTableData>> filesOf(String uuid) {
    return (select(syncDownFileTable)..where((t) => t.uuid.equals(uuid))).get();
  }

  /// 标记单个文件状态。
  Future<void> markFile(String uuid, String relPath, String status) {
    return (update(syncDownFileTable)
          ..where((t) => t.uuid.equals(uuid) & t.relPath.equals(relPath)))
        .write(SyncDownFileTableCompanion(status: Value(status)));
  }

  /// 更新整书状态 + 已下载计数。
  Future<void> updateBook(
    String uuid, {
    String? status,
    String? bookStatus,
    int? doneFiles,
  }) {
    return (update(syncDownTable)..where((t) => t.uuid.equals(uuid))).write(
      SyncDownTableCompanion(
        status: status != null ? Value(status) : const Value.absent(),
        bookStatus: bookStatus != null ? Value(bookStatus) : const Value.absent(),
        doneFiles: doneFiles != null ? Value(doneFiles) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 删除一本书（同步完成/失败清理）。
  Future<void> deleteBook(String uuid) async {
    await (delete(syncDownFileTable)..where((t) => t.uuid.equals(uuid))).go();
    await (delete(syncDownTable)..where((t) => t.uuid.equals(uuid))).go();
  }
}
