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

import 'converter/string_list_converter.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [BookTable, CollectionTable, CollectionBookTable],
  daos: [
    BookLocalDatasource,
    CollectionLocalDatasource,
    CollectionBookLocalDatasource,
  ],
)
class AppDatabase extends _$AppDatabase {
  // Allow injecting a QueryExecutor for tests. If null, use the default on-disk executor.
  AppDatabase([QueryExecutor? executor])
    : super((executor ?? _openConnection()));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      // 破坏性更新：删除所有表并重建
      await customStatement('PRAGMA foreign_keys = OFF');
      final tableNames = allTables.map((t) => t.actualTableName).toList();
      for (final name in tableNames) {
        await customStatement('DROP TABLE IF EXISTS "$name"');
      }
      await migrator.createAll();
      await customStatement('PRAGMA foreign_keys = ON');
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
