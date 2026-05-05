import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/home/repository/home_repository.dart';
import 'package:tele_book/feature/task/repository/task_repository.dart';

List<SingleChildWidget> createRepositoryDI() {
  return [
    // Book
    Provider(create: (context) => BookRepository(context.read())),
    // Home
    Provider(create: (context) => HomeRepository(context.read())),
    Provider(create: (context) => TaskRepository(context.read())),
  ];
}
