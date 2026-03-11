import 'dart:async';

import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/event/event_bus.dart';

class MarkService extends GetxService {
  final _eventBus = Get.find<EventBus>();
  final db = Get.find<AppDatabase>();
  final marks = <MarkTableData>[].obs;
  final markBooks = <MarkBookTableData>[].obs;
  StreamSubscription? _markSubscription;
  StreamSubscription? _markBookSubscription;

  @override
  void onInit() {
    super.onInit();
    _markSubscription = db.markTable.select().watch().listen((_) {
      getAllMarks();
      getAllMarkBooks();

    });
    _markBookSubscription = db.markBookTable.select().watch().listen((_) {
      getAllMarks();
      getAllMarkBooks();
    });
  }

  Future<void> getAllMarks() async {
    final markList = await db.markTable.select().get();
    marks.value = markList;
  }

  Future<void> getAllMarkBooks() async {
    final markBookList = await db.markBookTable.select().get();
    markBooks.value = markBookList;
  }

  Future<void> updateBookMarks(int bookId, List<int> markIds) async {
    await db.transaction(() async {
      await (db.markBookTable.delete()
            ..where((tbl) => tbl.bookId.equals(bookId)))
          .go();
      for (final markId in markIds) {
        await db.markBookTable.insertOnConflictUpdate(
          MarkBookTableCompanion(bookId: Value(bookId), markId: Value(markId)),
        );
      }
    });
  }

  Future<void> saveMark({
    int? id,
    required String name,
    required int color,
  }) async {
    await db.transaction(() async {
      if (id != null) {
        // 删除旧关联
        await (db.markBookTable.delete()..where((tbl) => tbl.markId.equals(id)))
            .go();
      }

      final markCompanion = MarkTableCompanion(
        id: id != null ? Value(id) : Value.absent(),
        name: Value(name),
        color: Value(color),
      );
      await db.markTable.insertOnConflictUpdate(markCompanion);
    });
  }

  Future<void> deleteMark(int id) async {
    await db.transaction(() async {
      await (db.markBookTable.delete()..where((tbl) => tbl.markId.equals(id)))
          .go();
      await (db.markTable.delete()..where((tbl) => tbl.id.equals(id))).go();
    });
  }

  @override
  void onClose() {
    _markSubscription?.cancel();
    _markBookSubscription?.cancel();
    super.onClose();
  }
}
