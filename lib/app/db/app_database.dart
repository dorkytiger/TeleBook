import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:wo_nas/app/db/dao/book_dao.dart';

import 'converter/string_list_converter.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [BookTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'tele_book',
      native: const DriftNativeOptions(),
    );
  }
}
