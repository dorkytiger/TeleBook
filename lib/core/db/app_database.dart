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
import 'package:tele_book/feature/sync/datasource/sync_down_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_op_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_state_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_task_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_upload_local_datasource.dart';
import 'package:tele_book/feature/sync/model/table/entity_sync_state_table.dart';
import 'package:tele_book/feature/sync/model/table/sync_down_file_table.dart';
import 'package:tele_book/feature/sync/model/table/sync_down_table.dart';
import 'package:tele_book/feature/sync/model/table/sync_op_table.dart';
import 'package:tele_book/feature/sync/model/table/sync_task_table.dart';
import 'package:tele_book/feature/sync/model/table/sync_upload_table.dart';

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
    SyncOpTable,
    SyncDownTable,
    SyncDownFileTable,
    SyncUploadTable,
  ],
  daos: [
    BookLocalDatasource,
    CollectionLocalDatasource,
    CollectionBookLocalDatasource,
    SettingLocalDatasource,
    SyncStateLocalDatasource,
    SyncTaskLocalDatasource,
    SyncOpLocalDatasource,
    SyncDownLocalDatasource,
    SyncUploadLocalDatasource,
  ],
)
class AppDatabase extends _$AppDatabase {
  // Allow injecting a QueryExecutor for tests. If null, use the default on-disk executor.
  AppDatabase([QueryExecutor? executor])
    : super((executor ?? _openConnection()));

  /// 数据库版本。main 分支当前为 v2（仅 book/collection/collection_book 三表，
  /// 无 uuid 列、无任何同步表）；本分支 v3 在其上新增设置表与同步系列表，
  /// 并给 book_table 加 uuid。每次 schema 变更 +1。
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        // v1 及更早：从未发布、结构不可考（main v2 自身也采用破坏性重建），
        // 这里保持一致：删全部表后按当前定义重建。
        await customStatement('PRAGMA foreign_keys = OFF');
        for (final table in allTables) {
          await customStatement(
            'DROP TABLE IF EXISTS "${table.actualTableName}"',
          );
        }
        await migrator.createAll();
        await customStatement('PRAGMA foreign_keys = ON');
      } else if (from < 3) {
        // v2（main）→ v3：**保留书库/收藏数据**，只做真实差异的增量升级：
        //  ① book_table 加 uuid（SQLite 不支持 ALTER 直接加 NOT NULL UNIQUE 列
        //     → 加可空列 → 回填 UUID → 建唯一索引，与 v3 定义一致）
        //  ② 新增设置表 + 同步系列表（entity_sync_state/sync_task/sync_op/
        //     sync_down/sync_down_file/sync_upload）
        await customStatement('ALTER TABLE "book_table" ADD COLUMN "uuid" TEXT');
        await customStatement('''
          UPDATE "book_table" SET uuid =
            lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-' ||
            lower(hex(randomblob(2))) || '-' || lower(hex(randomblob(2))) || '-' ||
            lower(hex(randomblob(6)))
          WHERE uuid IS NULL
        ''');
        await customStatement(
          'CREATE UNIQUE INDEX IF NOT EXISTS "book_table_uuid_key" '
          'ON "book_table" ("uuid")',
        );
        await migrator.createTable(settingTable);
        await migrator.createTable(entitySyncStateTable);
        await migrator.createTable(syncTaskTable);
        await migrator.createTable(syncOpTable);
        await migrator.createTable(syncDownTable);
        await migrator.createTable(syncDownFileTable);
        await migrator.createTable(syncUploadTable);
      }
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
