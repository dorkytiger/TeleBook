import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/setting/book_sort_setting.dart';
import 'package:tele_book/app/event/event_bus.dart';
import 'package:tele_book/app/service/path_service.dart';

/// BookService 只负责管理 Book 基础数据
/// UI 需要的复合数据(VO)由 Controller 按需组装
class BookService extends GetxService {
  final _eventBus = Get.find<EventBus>();
  final db = Get.find<AppDatabase>();
  final books = <BookTableData>[].obs;
  final PathService _pathService = Get.find<PathService>();

  StreamSubscription? _addSubscription;
  StreamSubscription? _refreshSubscription;

  @override
  void onInit() {
    super.onInit();
    _addSubscription = _eventBus.on<BookAddedEvent>().listen((event) {
      addBook(event.data);
    });
    _refreshSubscription = _eventBus.on<BookRefreshedEvent>().listen((_) {
      getAllBooks();
    });
    db.bookTable.select().watch().listen((_) {
      getAllBooks();
    });
  }

  // ✅ Service 只负责查询和管理基础数据
  Future<void> getAllBooks() async {
    final bookList = await db.bookTable.select().get();
    books.value = bookList;
  }

  Future<void> addBook(BookTableCompanion data) async {
    await db.bookTable.insertOnConflictUpdate(data);
  }

  Future<void> updateBook(BookTableData data) async {
    await db.bookTable.insertOnConflictUpdate(data);
  }

  Future<void> deleteBook(int bookId) async {
    // 先查询书籍信息，获取文件路径
    final book =
        await (db.bookTable.select()..where((tbl) => tbl.id.equals(bookId)))
            .getSingleOrNull();

    if (book != null) {
      // 删除本地文件
      final appDir = await getApplicationDocumentsDirectory();
      for (final path in book.localPaths) {
        final file = File('${appDir.path}/$path');
        if (await file.exists()) {
          await file.delete();
        }
      }
    }

    // 删除数据库记录
    await db.bookTable.deleteWhere((tbl) => tbl.id.equals(bookId));
  }

  Future<void> deleteBooks(List<int> bookIds) async {
    // 先查询所有书籍信息
    final books =
        await (db.bookTable.select()..where((tbl) => tbl.id.isIn(bookIds)))
            .get();

    // 删除所有书籍的本地文件
    for (final book in books) {
      for (final path in book.localPaths) {
        final file = File(_pathService.getBookFilePath(path));
        if (await file.exists()) {
          await file.delete();
        }
      }
    }

    // 删除数据库记录
    await db.bookTable.deleteWhere((tbl) => tbl.id.isIn(bookIds));
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
