import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:tele_book/app/db/dao/book_dao.dart';
import 'package:tele_book/app/db/dao/download_dao.dart';

import '../enum/book_page_layout_enum.dart';
import 'converter/string_list_converter.dart';
import 'dao/setting_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [BookTable, SettingTable, DownloadTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (details) async {
          await details.createAll();
          await into(settingTable).insert(
            SettingTableCompanion.insert(),
          );
        },
        onUpgrade: (migrator, from, to) async {
          if (from == 1) {
            await migrator.addColumn(settingTable, settingTable.serverHost);
            await migrator.addColumn(settingTable, settingTable.serverPort);
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
