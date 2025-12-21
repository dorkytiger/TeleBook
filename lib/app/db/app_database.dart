import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:tele_book/app/db/dao/book/book_table.dart';
import 'package:tele_book/app/db/dao/download/download_task_table.dart';

import 'converter/string_list_converter.dart';
import 'dao/download/download_group_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  BookTable,
  DownloadTaskTable,
  DownloadGroupTable
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (details) async {
          await details.createAll();
        },
        onUpgrade: (migrator, from, to) async {
          if (from == 1) {
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'tele_book',
      native: const DriftNativeOptions(),
    );
  }
}
