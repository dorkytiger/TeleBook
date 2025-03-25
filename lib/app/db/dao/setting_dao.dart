import 'package:drift/drift.dart';
import 'package:tele_book/app/enum/book_page_layout_enum.dart';

class SettingTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get pageLayout =>
      text().withDefault(Constant(BookPageLayout.row.name))();

  TextColumn get host => text().withDefault(const Constant("192.168.1.1"))();

  IntColumn get port => integer().withDefault(const Constant(22))();

  TextColumn get username => text().withDefault(const Constant("root"))();

  TextColumn get password => text().withDefault(const Constant("root"))();

  TextColumn get dataPath => text().withDefault(const Constant("~/data"))();

  TextColumn get imagePath => text().withDefault(const Constant("~/image"))();

  TextColumn get serverHost => text().withDefault(const Constant(""))();

  IntColumn get serverPort => integer().withDefault(const Constant(8080))();
}
