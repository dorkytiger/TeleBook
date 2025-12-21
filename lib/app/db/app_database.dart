import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/dao/book/book_table.dart';
import 'package:tele_book/app/db/dao/download/download_task_table.dart';

import 'converter/string_list_converter.dart';
import 'dao/download/download_group_table.dart';
import 'package:path/path.dart' as p;

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


  static QueryExecutor _openConnection() {

    return driftDatabase(
      name: 'tele_book',
      native: DriftNativeOptions(
        databasePath: () async {
          final dir = await getApplicationDocumentsDirectory();
          return p.join(dir.path, 'telebook', 'tele_book.db');
        },
      ),
    );
  }
}
