import 'dart:async';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:dk_util/state/dk_state_query_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/service/book_service.dart';
import 'package:tele_book/app/service/collection_servcie.dart';
import 'package:tele_book/app/service/mark_service.dart';
import 'package:tele_book/app/service/path_service.dart';
import 'package:tele_book/app/store/book_store.dart';
import 'package:tele_book/app/store/collection_store.dart';
import 'package:tele_book/app/store/mark_store.dart';

class BookFilterController extends ChangeNotifier {
  final BookStore bookStore;
  final MarkStore markStore;
  final CollectionStore collectionStore;
  final int? collectionId;

  BookLayoutSetting bookLayout = BookLayoutSetting.list;
  DKStateQuery<List<BookVo>> getBookState = DkStateQueryIdle();

  BookFilterController({
    required this.bookStore,
    this.collectionId,
    required this.markStore,
    required this.collectionStore,
  }) {
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    await DKStateQueryHelper.triggerQuery(
      onStateChange: (value) {
        getBookState = value;
        notifyListeners();
      },
      query: () async {
        final books = bookStore.items;
        final collections = collectionStore.collections;
        final collectionBooks = collectionStore.collectionBooks;
        final marks = markStore.marks;
        final markBooks = markStore.markBooks;

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
      final collection = collectionStore.collections.firstWhere(
        (c) => c.id == collectionId,
      );
      return collection.name;
    }
    return '书籍筛选';
  }
}
