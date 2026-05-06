import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tele_book/feature/book/store/book_store.dart';
import 'package:tele_book/feature/download/store/download_store.dart';
import 'package:tele_book/feature/home/store/home_store.dart';
import 'package:tele_book/feature/task/store/task_store.dart';

List<SingleChildWidget> createStoreDI() {
  return [
    ChangeNotifierProvider(create: (context) => HomeStore(context.read())),
    ChangeNotifierProvider(create: (context) => BookStore(context.read())),
    ChangeNotifierProvider(create: (context) => TaskStore(context.read())),
    ChangeNotifierProvider(create: (context) => DownloadStore(context.read())),
  ];
}
