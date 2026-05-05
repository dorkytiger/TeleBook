import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tele_book/feature/book/store/book_store.dart';
import 'package:tele_book/feature/home/store/home_store.dart';
import 'package:tele_book/feature/task/store/task_store.dart';

List<SingleChildWidget> createStoreDI() {
  return [
    Provider(create: (context) => BookStore(context.read())),
    // Home
    ChangeNotifierProvider(create: (context) => HomeStore(context.read())),
    ChangeNotifierProvider(create: (context) => TaskStore(context.read())),
  ];
}
