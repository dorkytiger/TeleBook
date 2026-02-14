import 'dart:async';

import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/setting/book_sort_setting.dart';
import 'package:tele_book/app/event/event_bus.dart';

/// BookService 只负责管理 Book 基础数据
/// UI 需要的复合数据(VO)由 Controller 按需组装
class BookService extends GetxService {
  final _eventBus = Get.find<EventBus>();
  final db = Get.find<AppDatabase>();

  // ✅ 只存储基础数据
  final books = <BookTableData>[].obs;
  final filter = Rx<BookFilter>(BookFilter());
  final sort = Rx<BookSort>(
    BookSort(
      addTimeSort: BookAddTimeSortSetting.addTimeDesc,
      titleSort: BookTitleSortSetting.titleAsc,
    ),
  );
  StreamSubscription? _addSubscription;
  StreamSubscription? _refreshSubscription;

  @override
  void onInit() {
    super.onInit();
    _addSubscription = _eventBus.on<BookAddedEvent>().listen((event) {
      addBook(event.data);
    });
    _refreshSubscription = _eventBus.on<BookRefreshedEvent>().listen((_) {
      getBooksByFilter();
    });

    filter.listen((_) {
      getBooksByFilter();
    });
    sort.listen((_) {
      getBooksByFilter();
    });
    db.bookTable.select().watch().listen((_) {
      getBooksByFilter();
    });
  }

  // ✅ Service 只负责查询和管理基础数据
  Future<void> getAllBooks() async {
    final bookList = await db.bookTable.select().get();
    books.value = bookList;
  }

  Future<void> getBooksByFilter() async {
    var query = db.bookTable.select();

    if (filter.value.title != null && filter.value.title!.isNotEmpty) {
      query = query..where((tbl) => tbl.name.like('%${filter.value.title!}%'));
    }

    if (filter.value.collection != null) {
      final bookCollectionRelations =
          await (db.collectionBookTable.select()..where(
                (tbl) => tbl.collectionId.equals(filter.value.collection!.id),
              ))
              .get();
      final bookIds = bookCollectionRelations.map((e) => e.bookId).toList();
      query = query..where((tbl) => tbl.id.isIn(bookIds));
    }

    if (filter.value.marks != null && filter.value.marks!.isNotEmpty) {
      final bookMarkRelations =
          await (db.markBookTable.select()..where(
                (tbl) => tbl.markId.isIn(
                  filter.value.marks!.map((e) => e.id).toList(),
                ),
              ))
              .get();
      final bookIds = bookMarkRelations.map((e) => e.bookId).toList();
      query = query..where((tbl) => tbl.id.isIn(bookIds));
    }

    if (sort.value.addTimeSort == BookAddTimeSortSetting.addTimeAsc) {
      query = query
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt)]);
    } else {
      query = query
        ..orderBy([
          (tbl) =>
              OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
        ]);
    }

    if (sort.value.titleSort == BookTitleSortSetting.titleAsc) {
      query = query..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]);
    } else {
      query = query
        ..orderBy([
          (tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.desc),
        ]);
    }

    final bookList = await query.get();
    books.value = bookList;
  }

  // ✅ 提供根据 bookId 查询关联数据的方法（供 Controller 使用）
  Future<List<MarkTableData>> getBookMarks(int bookId) async {
    return await (db.markBookTable.select()
          ..where((tbl) => tbl.bookId.equals(bookId)))
        .join([
          innerJoin(
            db.markTable,
            db.markTable.id.equalsExp(db.markBookTable.markId),
          ),
        ])
        .map((row) => row.readTable(db.markTable))
        .get();
  }

  Future<CollectionTableData?> getBookCollection(int bookId) async {
    return await (db.collectionBookTable.select()
          ..where((tbl) => tbl.bookId.equals(bookId)))
        .join([
          innerJoin(
            db.collectionTable,
            db.collectionTable.id.equalsExp(
              db.collectionBookTable.collectionId,
            ),
          ),
        ])
        .map((row) => row.readTableOrNull(db.collectionTable))
        .getSingleOrNull();
  }

  Future<void> addBook(BookTableCompanion data) async {
    await db.bookTable.insertOnConflictUpdate(data);
  }

  Future<void> updateBook(BookTableData data) async {
    await db.bookTable.insertOnConflictUpdate(data);
  }

  Future<void> deleteBook(int bookId) async {
    await db.bookTable.deleteWhere((tbl) => tbl.id.equals(bookId));
  }

  Future<void> updateFilter(BookFilter newFilter) async {
    filter.value = newFilter;
  }

  Future<void> updateSort(BookSort newSort) async {
    sort.value = newSort;
  }

  @override
  void onClose() {
    _addSubscription?.cancel();
    _refreshSubscription?.cancel();
    super.onClose();
  }
}

class BookFilter {
  final String? title;
  final CollectionTableData? collection;
  final List<MarkTableData>? marks;

  BookFilter({this.title, this.collection, this.marks});
}

class BookSort {
  final BookAddTimeSortSetting addTimeSort;
  final BookTitleSortSetting titleSort;

  BookSort({required this.addTimeSort, required this.titleSort});
}

class BookVO {
  final BookTableData book;
  final List<MarkTableData> marks;
  final CollectionTableData? collection;

  BookVO({required this.book, required this.marks, required this.collection});

  // 可以添加 UI 专用的计算属性
  String get displayTitle => book.name.isEmpty ? '未命名书籍' : book.name;

  bool get hasMarks => marks.isNotEmpty;

  String get collectionName => collection?.name ?? '未分类';
}
