import 'package:drift/drift.dart';
import 'package:tele_book/app/enum/book_page_layout_enum.dart';

class SettingTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get pageLayout =>
      text().withDefault(Constant(BookPageLayout.row.name))();
}
