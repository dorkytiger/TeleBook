import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:tele_book/feature/book/datasource/local/book_local_datasource.dart';
import 'package:tele_book/feature/book/model/table/book_table.dart';

import 'converter/string_list_converter.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [BookTable], daos: [BookLocalDatasource])
class AppDatabase extends _$AppDatabase {
  // Allow injecting a QueryExecutor for tests. If null, use the default on-disk executor.
  AppDatabase([QueryExecutor? executor])
    : super((executor ?? _openConnection()));

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'tele_book');
  }
}
