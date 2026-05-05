import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/core/db/dao/collection/collection_book_dao.dart';
import 'package:tele_book/core/db/dao/collection/collection_dao.dart';
import 'package:tele_book/core/db/dao/mark/mark_book_dao.dart';
import 'package:tele_book/core/db/dao/mark/mark_dao.dart';
import 'package:tele_book/feature/book/datasource/local/book_local_datasource.dart';
import 'package:tele_book/feature/book/model/table/book_table.dart';
import 'package:tele_book/core/db/table/collection/collection_book_table.dart';
import 'package:tele_book/core/db/table/collection/collection_table.dart';
import 'package:tele_book/core/db/table/mark/mark_book_table.dart';
import 'package:tele_book/core/db/table/mark/mark_table.dart';

import 'converter/string_list_converter.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    BookTable,
    CollectionTable,
    CollectionBookTable,
    MarkTable,
    MarkBookTable,
  ],
  daos: [
    BookLocalDatasource,
    CollectionDao,
    CollectionBookDao,
    MarkDao,
    MarkBookDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  // Allow injecting a QueryExecutor for tests. If null, use the default on-disk executor.
  AppDatabase([QueryExecutor? executor])
    : super((executor ?? _openConnection()));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from <= 3) {
        // Add currentPage column to BookTable
        await migrator.addColumn(bookTable, bookTable.currentPage);
      }
    },
  );

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
