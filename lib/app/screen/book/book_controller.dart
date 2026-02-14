import 'dart:async';
import 'dart:io' as io;

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/enum/setting/book_sort_setting.dart';
import 'package:tele_book/app/enum/setting/setting_key.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/service/book_service.dart';
import 'package:tele_book/app/service/collection_servcie.dart';
import 'package:tele_book/app/service/export_service.dart';
import 'package:tele_book/app/service/mark_service.dart';

class BookController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  final exportService = Get.find<ExportService>();
  final bookService = Get.find<BookService>();
  final collectionService = Get.find<CollectionService>();
  final markService = Get.find<MarkService>();
  final bookLayout = Rx<BookLayoutSetting>(BookLayoutSetting.list);
  final bookTitleSort = Rx<BookTitleSortSetting>(BookTitleSortSetting.titleAsc);
  final bookAddTimeSort = Rx<BookAddTimeSortSetting>(BookAddTimeSortSetting.addTimeAsc);
  final multiEditMode = false.obs;
  final searchBarController = TextEditingController();
  final selectedBookIds = <int>[].obs;
  final selectedCollectionId = Rxn<int>(); // null means show all
  final selectedMarkIds = <int>[].obs; // empty means show all
  final getBookState = Rx<DKStateQuery<List<BookUIData>>>(DkStateQueryIdle());
  final getCollectionState = Rx<DKStateQuery<List<CollectionTableData>>>(
    DkStateQueryIdle(),
  );
  final getMarkState = Rx<DKStateQuery<List<MarkTableData>>>(
    DkStateQueryIdle(),
  );
  final addBookToCollectionState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final addMultipleBooksToCollectionState = Rx<DKStateEvent<void>>(
    DKStateEventIdle(),
  );
  final deleteBookState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final deleteMultipleBookState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  late final String appDirectory;
  late final SharedPreferences prefs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    initBookLayout();
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
    appDirectory = (await getApplicationDocumentsDirectory()).path;
    searchBarController.addListener(() {
      fetchBooks();
    });
    await getCollections();
    await getMarks();
    await fetchBooks();
  }

  @override
  void onReady() {
    super.onReady();
    fetchBooks(); // 每次路由激活时自动刷新
  }

  Future<void> initBookLayout() async {
    final layoutValue =
        prefs.getInt(SettingKey.bookLayout) ?? BookLayoutSetting.list.value;
    bookLayout.value = BookLayoutSetting.fromValue(layoutValue);
  }
  
  Future<void> initBookSort() async {
    final sortValue =
        prefs.getString(SettingKey.bookTitleSort) ?? BookTitleSortSetting.titleAsc.value;
    bookTitleSort.value = BookTitleSortSetting.fromValue(sortValue);
  }

  Future<void> triggerBookLayoutChange(BookLayoutSetting layout) async {
    bookLayout.value = layout;
    await prefs.setInt(SettingKey.bookLayout, layout.value);
  }

  Future<void> triggerBookTitleSortChange(BookTitleSortSetting sort) async {
    bookTitleSort.value = sort;
    await prefs.setString(SettingKey.bookTitleSort, sort.value);
    fetchBooks(); // 切换排序后刷新书籍列表
  }

  Future<void> triggerBookAddTimeSortChange(BookAddTimeSortSetting sort) async {
    bookAddTimeSort.value = sort;
    await prefs.setString(SettingKey.bookAddTimeSort, sort.value);
    fetchBooks(); // 切换排序后刷新书籍列表
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

  /// ✅ 优化：利用 Service 缓存，按需组装 VO
  Future<void> fetchBooks() async {
    await getBookState.triggerQuery(
      query: () async {
        // 1. 使用 BookService 获取基础书籍数据（利用 Service 的过滤和排序）
        final bookData = bookService.books;

        if (bookData.isEmpty) {
          return <BookUIData>[];
        }

        final bookIds = bookData.map((e) => e.id).toList();

        // 2. 批量查询关联数据（一次查询，避免 N+1 问题）
        final markBookRelations = await (appDatabase.markBookTable.select()
              ..where((tbl) => tbl.bookId.isIn(bookIds)))
            .get();

        final markIds = markBookRelations.map((e) => e.markId).toSet().toList();
        final marks = markIds.isNotEmpty
            ? await (appDatabase.markTable.select()
                  ..where((tbl) => tbl.id.isIn(markIds)))
                .get()
            : <MarkTableData>[];

        final collectionBookRelations = await (appDatabase
                .collectionBookTable
                .select()
              ..where((tbl) => tbl.bookId.isIn(bookIds)))
            .get();

        final collectionIds =
            collectionBookRelations.map((e) => e.collectionId).toSet().toList();
        final collections = collectionIds.isNotEmpty
            ? await (appDatabase.collectionTable.select()
                  ..where((tbl) => tbl.id.isIn(collectionIds)))
                .get()
            : <CollectionTableData>[];

        // 3. 在内存中组装 VO（高效，只遍历一次）
        final List<BookUIData> result = bookData.map((book) {
          // 找到该书籍的所有标记
          final bookMarkIds = markBookRelations
              .where((mb) => mb.bookId == book.id)
              .map((mb) => mb.markId)
              .toSet();
          final marksForBook = marks
              .where((m) => bookMarkIds.contains(m.id))
              .toList();

          // 找到该书籍的收藏夹
          final collectionId = collectionBookRelations
              .firstWhereOrNull((cb) => cb.bookId == book.id)
              ?.collectionId;
          final collectionData = collectionId != null
              ? collections.firstWhereOrNull((c) => c.id == collectionId)
              : null;

          return BookUIData(
            book: book,
            marks: marksForBook,
            collection: collectionData,
          );
        }).toList();

        // Apply filters
        var filteredResult = result;

        // Filter by collection
        if (selectedCollectionId.value != null) {
          filteredResult = filteredResult.where((bookUI) {
            return bookUI.collection?.id == selectedCollectionId.value;
          }).toList();
        }

        // Filter by marks (if any marks are selected, show books that have at least one of them)
        if (selectedMarkIds.isNotEmpty) {
          filteredResult = filteredResult.where((bookUI) {
            return bookUI.marks.any(
              (mark) => selectedMarkIds.contains(mark.id),
            );
          }).toList();
        }

        if (searchBarController.text.isNotEmpty) {
          final query = searchBarController.text.toLowerCase();
          filteredResult = filteredResult.where((bookUI) {
            final titleMatch = bookUI.book.name.toLowerCase().contains(query);
            return titleMatch;
          }).toList();
        }

        return filteredResult;
      },
      isEmpty: (data) => data.isEmpty,
    );
  }

  /// 刷新书籍列表（用于阅读后返回时刷新阅读进度）
  Future<void> refreshBooks() async {
    await fetchBooks();
  }

  Future<void> getCollections() async {
    await getCollectionState.triggerQuery(
      query: () async {
        final query = appDatabase.collectionTable.select()
          ..orderBy([
            (t) => OrderingTerm(expression: t.order, mode: OrderingMode.asc),
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]);
        final collections = await query.get();
        return collections;
      },
      isEmpty: (data) => data.isEmpty,
    );
  }

  Future<void> getMarks() async {
    await getMarkState.triggerQuery(
      query: () async {
        final query = appDatabase.markTable.select();
        final marks = await query.get();
        return marks;
      },
      isEmpty: (data) => data.isEmpty,
    );
  }

  void toggleCollectionFilter(int? collectionId) {
    if (selectedCollectionId.value == collectionId) {
      selectedCollectionId.value = null; // Deselect if already selected
    } else {
      selectedCollectionId.value = collectionId;
    }
    fetchBooks(); // Refresh books with new filter
  }

  void toggleMarkFilter(int markId) {
    if (selectedMarkIds.contains(markId)) {
      selectedMarkIds.remove(markId);
    } else {
      selectedMarkIds.add(markId);
    }
    fetchBooks(); // Refresh books with new filter
  }

  void clearAllFilters() {
    selectedCollectionId.value = null;
    selectedMarkIds.clear();
    fetchBooks(); // Refresh books
  }

  Future<void> addBookToCollection(int bookId, int collectionId) async {
    await addBookToCollectionState.triggerEvent(
      event: () async {
        final appDatabase = Get.find<AppDatabase>();
        final existingEntry =
            await (appDatabase.collectionBookTable.select()..where(
                  (tbl) =>
                      tbl.bookId.equals(bookId) &
                      tbl.collectionId.equals(collectionId),
                ))
                .getSingleOrNull();

        if (existingEntry != null) {
          // 已存在，不需要重复添加
          return;
        }

        await appDatabase.collectionBookTable.insertOnConflictUpdate(
          CollectionBookTableCompanion.insert(
            bookId: bookId,
            collectionId: collectionId,
          ),
        );
      },
    );
  }

  Future<void> addMultipleBooksToCollection(int collectionId) async {
    await addMultipleBooksToCollectionState.triggerEvent(
      event: () async {
        final bookIds = selectedBookIds.toList();
        final appDatabase = Get.find<AppDatabase>();
        for (final bookId in bookIds) {
          final existingEntry =
              await (appDatabase.collectionBookTable.select()..where(
                    (tbl) =>
                        tbl.bookId.equals(bookId) &
                        tbl.collectionId.equals(collectionId),
                  ))
                  .getSingleOrNull();

          if (existingEntry != null) {
            // 已存在，不需要重复添加
            continue;
          }

          await appDatabase.collectionBookTable.insertOnConflictUpdate(
            CollectionBookTableCompanion.insert(
              bookId: bookId,
              collectionId: collectionId,
            ),
          );
        }
      },
    );
  }

  Future<void> exportBook(BookTableData data) async {
    // 添加到导出队列并立即跳转到导出页面查看进度
    final record = await exportService.exportBook(data);
    if (record != null) {
      // 立即跳转到导出页面，用户可以看到导出进度
      Get.toNamed(AppRoute.export);
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
      Get.toNamed(AppRoute.export);
    }
  }

  Future<void> deleteBook(int id) async {
    deleteBookState.triggerEvent(
      event: () async {
        final appDatabase = Get.find<AppDatabase>();
        final book =
            await (appDatabase.bookTable.select()
                  ..where((tbl) => tbl.id.equals(id)))
                .getSingle();

        // 删除本地文件
        for (final path in book.localPaths) {
          final file = io.File("$appDirectory/$path");
          if (await file.exists()) {
            await file.delete();
          }
        }

        await appDatabase.bookTable.deleteWhere((tbl) => tbl.id.equals(id));
        await fetchBooks();
      },
    );
  }

  Future<void> deleteMultipleBooks() async {
    deleteMultipleBookState.triggerEvent(
      event: () async {
        final ids = selectedBookIds.toList();
        final appDatabase = Get.find<AppDatabase>();
        final books =
            await (appDatabase.bookTable.select()
                  ..where((tbl) => tbl.id.isIn(ids)))
                .get();

        // 删除本地文件
        for (final book in books) {
          for (final path in book.localPaths) {
            final file = io.File("$appDirectory/$path");
            if (await file.exists()) {
              await file.delete();
            }
          }
        }

        await appDatabase.bookTable.deleteWhere((tbl) => tbl.id.isIn(ids));
        await fetchBooks();
        selectedBookIds.clear();
        multiEditMode.value = false;
      },
    );
  }
}

class BookUIData {
  final BookTableData book;
  final List<MarkTableData> marks;
  final CollectionTableData? collection;

  BookUIData({
    required this.book,
    required this.marks,
    required this.collection,
  });
}
