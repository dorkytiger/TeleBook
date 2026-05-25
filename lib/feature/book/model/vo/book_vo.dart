import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';


class BookDetailVo {
  final BookTableData book;
  final List<String> imagePaths;

  BookDetailVo({required this.book, required this.imagePaths});
}
