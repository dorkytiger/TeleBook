import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';
import 'package:tele_book/feature/book/model/vo/book_vo.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';

class BookService {
  final BookRepository _bookRepository;

  BookService(this._bookRepository);

  Stream<BookListVo> watchBooks({
    int? page,
    int? pageSize,
    DateTime? lastCreatedAt,
    String? name,
    BookSort? sort,
  }) {
    return _bookRepository
        .watchBooks(
          page: page,
          pageSize: pageSize,
          lastCreatedAt: lastCreatedAt,
          name: name,
          sort: sort,
        )
        .map((books) {
          final bookVos = books.map((book) {
            // 用 GlobalConfig 解析封面路径，避免 async/await
            final coverPath = book.localSubPaths.isNotEmpty
                ? GlobalConfig.resolveBookPath(book.localSubPaths.first)
                : '';
            return BookListItemVo(book: book, coverImagePath: coverPath);
          }).toList();
          return BookListVo(bookVos: bookVos);
        });
  }
}
