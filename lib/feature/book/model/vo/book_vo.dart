import 'package:tele_book/core/db/app_database.dart';

class BookListVo {
  final List<BookListItemVo> bookVos;

  BookListVo({required this.bookVos});
}


class BookListItemVo {
  final BookTableData book;
  final String coverImagePath;

  BookListItemVo({required this.book, required this.coverImagePath});
}

class BookDetailVo {
  final BookTableData book;
  final List<String> imagePaths;

  BookDetailVo({required this.book, required this.imagePaths});
}