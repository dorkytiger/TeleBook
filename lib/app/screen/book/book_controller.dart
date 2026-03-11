import 'dart:async';
import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/home/home_controller.dart';
import 'package:tele_book/app/screen/task/task_controller.dart';
import 'package:tele_book/app/service/book_service.dart';
import 'package:tele_book/app/service/collection_servcie.dart';
import 'package:tele_book/app/service/export_service.dart';
import 'package:tele_book/app/service/mark_service.dart';
import 'package:tele_book/app/service/path_service.dart';

class BookController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  final exportService = Get.find<ExportService>();
  final bookService = Get.find<BookService>();
  final collectionService = Get.find<CollectionService>();
  final markService = Get.find<MarkService>();
  final pathService = Get.find<PathService>();

  final multiEditMode = false.obs;
  final selectedBookIds = <int>[].obs;
  final bookLayout = Rx<BookLayoutSetting>(BookLayoutSetting.list);
  final sortBy = Rx<BookSort>(
    BookSort(type: BookSortType.title, order: BookSortOrder.asc),
  );
  final getBookState = Rx<DKStateQuery<List<BookVo>>>(DkStateQueryIdle());

  final addBookToCollectionState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final addMultipleBooksToCollectionState = Rx<DKStateEvent<void>>(
    DKStateEventIdle(),
  );
  final deleteBookState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final deleteMultipleBookState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final sharedPreferences = Get.find<SharedPreferences>();
  StreamSubscription? booksSubscription;
  StreamSubscription? collectionsSubscription;
  StreamSubscription? collectionBooksSubscription;
  StreamSubscription? marksSubscription;
  StreamSubscription? markBooksSubscription;

  @override
  void onInit() async {
    super.onInit();
    _initListen();

    sortBy.listen((_) => fetchBooks());

    deleteBookState.listenEventToast();
    deleteMultipleBookState.listenEventToast(
      onSuccess: (_) {
        selectedBookIds.clear();
        multiEditMode.value = false;
      },
    );
    addBookToCollectionState.listenEventToast();
    addMultipleBooksToCollectionState.listenEventToast(
      onSuccess: (_) {
        selectedBookIds.clear();
        multiEditMode.value = false;
      },
    );
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

  void toggleSelectBook(int bookId) {
    if (selectedBookIds.contains(bookId)) {
      selectedBookIds.remove(bookId);
    } else {
      selectedBookIds.add(bookId);
    }
  }

  void toggleSelectAllBooks() {
    if (!getBookState.value.isSuccess) {
      return;
    }
    final currentBooks = getBookState.value.data;
    final allBookIds = currentBooks.map((bookUI) => bookUI.book.id).toList();
    selectedBookIds.clear();
    selectedBookIds.addAll(allBookIds);
  }

  void toggleDeselectAllBooks() {
    selectedBookIds.clear();
  }

  bool get isAllBooksSelected {
    if (!getBookState.value.isSuccess) {
      return false;
    }

    final currentBooks = getBookState.value.data;
    if (currentBooks.isEmpty) {
      return false;
    }
    final allBookIds = currentBooks.map((bookUI) => bookUI.book.id).toSet();
    final selectedIds = selectedBookIds.toSet();
    return selectedIds.length == allBookIds.length &&
        allBookIds.every((id) => selectedIds.contains(id));
  }

  void triggerMultiEditMode(bool enable) {
    multiEditMode.value = enable;
    if (!multiEditMode.value) {
      selectedBookIds.clear();
    }
  }

  void changeSortBy(BookSortType type, BookSortOrder order) {
    sortBy.value = BookSort(type: type, order: order);
    fetchBooks();
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

        // 进行排序
        bookVos.sort((a, b) {
          int compareResult = 0;

          // 根据排序类型进行比较
          switch (sortBy.value.type) {
            case BookSortType.title:
              compareResult = a.book.name.compareTo(b.book.name);
              break;
            case BookSortType.addTime:
              compareResult = a.book.createdAt.compareTo(b.book.createdAt);
              break;
          }

          // 根据排序顺序调整结果
          return sortBy.value.order == BookSortOrder.asc
              ? compareResult
              : -compareResult;
        });

        return bookVos;
      },
      isEmpty: (data) => data.isEmpty,
    );
  }

  Future<List<Widget>> fetchSearchBook(String searchText) async {
    if (!getBookState.value.isSuccess) {
      return [];
    }
    final currentBooks = getBookState.value.data;
    if (searchText.isEmpty) {
      return [];
    }
    final matchedBooks = currentBooks
        .where((bookUI) => bookUI.book.name.contains(searchText))
        .toList();
    return matchedBooks
        .map(
          (bookUI) => Row(
            children: [
              Image.file(
                File(pathService.getBookFilePath(bookUI.book.localPaths.first)),
              ),
              Expanded(
                child: ListTile(
                  title: Text(bookUI.book.name),
                  subtitle: Text(
                    '创建于 ${bookUI.book.createdAt.toIso8601String()}',
                  ),
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  Future<void> exportBook(BookTableData data) async {
    // 添加到导出队列并立即跳转到导出页面查看进度
    final record = await exportService.exportBook(data);
    if (record != null) {
      final homeController = Get.find<HomeController>();
      homeController.selectedIndex.value = 1;
      final taskController = Get.find<TaskController>();
      taskController.tabController.animateTo(2);
    }
  }

  Future<void> exportMultipleBooks() async {

    final ids = selectedBookIds.toList();
    final books =
        await (appDatabase.bookTable.select()..where((tbl) => tbl.id.isIn(ids)))
            .get();

    // 添加所有书籍到导出队列
    final records = await exportService.exportMultiple(books);

    // 清除选择状态
    selectedBookIds.clear();
    multiEditMode.value = false;

    // 立即跳转到导出页面查看进度
    if (records.isNotEmpty) {
      final homeController = Get.find<HomeController>();
      homeController.selectedIndex.value = 1;
      final taskController = Get.find<TaskController>();
      taskController.tabController.animateTo(2);
    }
  }

  Future<void> deleteBook(int id) async {
    await deleteBookState.triggerEvent(
      event: () async {
        await bookService.deleteBook(id);
      },
    );
  }

  Future<void> deleteMultipleBooks() async {
    deleteMultipleBookState.triggerEvent(
      event: () async {
        final ids = selectedBookIds.toList();
        await bookService.deleteBooks(ids);
        await fetchBooks();
        selectedBookIds.clear();
        multiEditMode.value = false;
      },
    );
  }
}

class BookVo {
  final BookTableData book;
  final List<MarkTableData> marks;
  final CollectionTableData? collection;

  BookVo({required this.book, required this.marks, required this.collection});
}

class BookSort {
  final BookSortType type;
  final BookSortOrder order;

  BookSort({required this.type, required this.order});
}

enum BookSortOrder { asc, desc }

enum BookSortType { title, addTime }
