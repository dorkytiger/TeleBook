import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/core/db/app_database.dart';

List<SingleChildWidget> createCoreDI() {
  return [Provider(create: (_) => AppDatabase())];
}
