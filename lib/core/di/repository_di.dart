import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/download/repository/download_repository.dart';

List<SingleChildWidget> createRepositoryDI() {
  return [
    Provider(create: (context) => BookRepository(context.read())),
    Provider(create: (context) => DownloadRepository(context.read())),
  ];
}
