import 'dart:async';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/service/book_service.dart';
import 'package:tele_book/app/service/collection_servcie.dart';
import 'package:tele_book/app/service/mark_service.dart';
import 'package:tele_book/app/service/path_service.dart';

class BookFilterController extends GetxController {
  final bookService = Get.find<BookService>();
  final collectionService = Get.find<CollectionService>();
  final markService = Get.find<MarkService>();
  final pathService = Get.find<PathService>();

  final bookLayout = Rx<BookLayoutSetting>(BookLayoutSetting.list);
  final getBookState = Rx<DKStateQuery<List<BookVo>>>(DkStateQueryIdle());

  // 过滤条件
  int? collectionId;

  StreamSubscription? booksSubscription;
  StreamSubscription? collectionsSubscription;
  StreamSubscription? collectionBooksSubscription;
  StreamSubscription? marksSubscription;
  StreamSubscription? markBooksSubscription;

  @override
  void onInit() async {
    super.onInit();

    // 从参数中获取过滤条件
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      collectionId = arguments['collectionId'] as int?;
    }

    _initListen();
    await fetchBooks();
  }

  void _initListen() {
    booksSubscription = bookService.books.listen((_) => fetchBooks());
    collectionsSubscription = collectionService.collections.listen(
      (_) => fetchBooks(),
    );
    collectionBooksSubscription = collectionService.collectionBooks.listen(
      (_) => fetchBooks(),
    );
    marksSubscription = markService.marks.listen((_) => fetchBooks());
    markBooksSubscription = markService.markBooks.listen((_) => fetchBooks());
  }

  Future<void> fetchBooks() async {
    await getBookState.triggerQuery(
      query: () async {
        final books = bookService.books;
        final collections = collectionService.collections;
        final collectionBooks = collectionService.collectionBooks;
        final marks = markService.marks;
        final markBooks = markService.markBooks;

        List<BookVo> bookVos = [];

        for (var book in books) {
          // 根据收藏夹过滤
          if (collectionId != null) {
            final isInCollection = collectionBooks.any(
              (cb) => cb.bookId == book.id && cb.collectionId == collectionId,
            );
            if (!isInCollection) {
              continue;
            }
          }

          final bookMarks = markBooks
              .where((mb) => mb.bookId == book.id)
              .map((mb) => marks.firstWhere((m) => m.id == mb.markId))
              .toList();
          final bookCollection = collectionBooks
              .where((cb) => cb.bookId == book.id)
              .map(
                (cb) => collections.firstWhere((c) => c.id == cb.collectionId),
              )
              .firstOrNull;

          bookVos.add(
            BookVo(book: book, marks: bookMarks, collection: bookCollection),
          );
        }

        return bookVos;
      },
      isEmpty: (data) => data.isEmpty,
    );
  }

  String getTitle() {
    if (collectionId != null) {
      final collection = collectionService.collections.firstWhereOrNull(
        (c) => c.id == collectionId,
      );
      return collection?.name ?? '书籍筛选';
    }
    return '书籍筛选';
  }

  @override
  void onClose() {
    booksSubscription?.cancel();
    collectionsSubscription?.cancel();
    collectionBooksSubscription?.cancel();
    marksSubscription?.cancel();
    markBooksSubscription?.cancel();
    super.onClose();
  }
}

