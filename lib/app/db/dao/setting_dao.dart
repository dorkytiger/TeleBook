import 'package:drift/drift.dart';

class SettingTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get pageLayout => text().withDefault(const Constant('page'))();
}
