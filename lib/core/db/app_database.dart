import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tele_book/feature/book/datasource/local/book_local_datasource.dart';
import 'package:tele_book/feature/book/model/table/book_table.dart';
import 'package:tele_book/feature/collection/datasource/local/collection_book_local_datasource.dart';
import 'package:tele_book/feature/collection/datasource/local/collection_local_datasource.dart';
import 'package:tele_book/feature/collection/model/table/collection_book_table.dart';
import 'package:tele_book/feature/collection/model/table/collection_table.dart';
import 'package:tele_book/feature/setting/datasource/setting_local_datasource.dart';
import 'package:tele_book/feature/setting/model/table/setting_table.dart';
import 'package:tele_book/feature/sync/datasource/sync_log_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_state_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_task_local_datasource.dart';
import 'package:tele_book/feature/sync/model/table/entity_sync_state_table.dart';
import 'package:tele_book/feature/sync/model/table/sync_log_table.dart';
import 'package:tele_book/feature/sync/model/table/sync_task_table.dart';

import 'converter/string_list_converter.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    BookTable,
    CollectionTable,
    CollectionBookTable,
    SettingTable,
    EntitySyncStateTable,
    SyncTaskTable,
    SyncLogTable,
  ],
  daos: [
    BookLocalDatasource,
    CollectionLocalDatasource,
    CollectionBookLocalDatasource,
    SettingLocalDatasource,
    SyncStateLocalDatasource,
    SyncTaskLocalDatasource,
    SyncLogLocalDatasource,
  ],
)
class AppDatabase extends _$AppDatabase {
  // Allow injecting a QueryExecutor for tests. If null, use the default on-disk executor.
  AppDatabase([QueryExecutor? executor])
    : super((executor ?? _openConnection()));

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      // 逐版本增量迁移，尽量保留用户数据
      if (from < 2) {
        // v1 → v2：早期版本表结构不可考，删除全部表并重建
        for (final table in allTables) {
          await migrator.deleteTable(table.actualTableName);
        }
        await migrator.createAll();
      }
      if (from < 3) {
        // v2 → v3：新增设置表（书籍/收藏数据保留）
        await migrator.createTable(settingTable);
      }
      if (from < 4) {
        // v3 → v4：书籍加同步 uuid 列 + 新增实体同步状态表
        // SQLite 的 ALTER TABLE 不支持添加 NOT NULL UNIQUE 列，
        // 因此分三步：加可空列 → 回填 uuid → 建唯一索引。
        await customStatement('ALTER TABLE "book_table" ADD COLUMN "uuid" TEXT');
        // 回填已有书籍的 uuid（SQLite 无 uuid 函数，用 randomblob 拼）
        await customStatement('''
          UPDATE "book_table" SET uuid =
            lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-' ||
            lower(hex(randomblob(2))) || '-' || lower(hex(randomblob(2))) || '-' ||
            lower(hex(randomblob(6)))
          WHERE uuid IS NULL
        ''');
        await customStatement(
          'CREATE UNIQUE INDEX IF NOT EXISTS "book_table_uuid_key" ON "book_table" ("uuid")',
        );
        await migrator.createTable(entitySyncStateTable);
      }
      if (from < 5) {
        // v4 → v5：新增待同步任务表（outbox，本地优先 + 后台同步）
        await migrator.createTable(syncTaskTable);
      }
      if (from < 6) {
        // v5 → v6：新增本地同步记录表（每次同步会话）
        await migrator.createTable(syncLogTable);
      }
      // 未来版本在这里追加：
      // if (from < 6) { ... }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'tele_book',
      native: DriftNativeOptions(
        databaseDirectory: () async {
          if (Platform.isIOS || Platform.isAndroid) {
            final dbFolder = await getApplicationDocumentsDirectory();
            print('Database path: ${dbFolder.path}');
            return dbFolder.path;
          } else {
            // For desktop platforms, use the current directory
            return Directory.current.path;
          }
        },
      ),
    );
  }
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
