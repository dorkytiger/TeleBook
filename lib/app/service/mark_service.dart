import 'dart:async';

import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/event/event_bus.dart';

class MarkService extends GetxService {
  final _eventBus = Get.find<EventBus>();
  final db = Get.find<AppDatabase>();
  final marks = <MarkTableData>[].obs;
  StreamSubscription? _markSubscription;
  StreamSubscription? _markBookSubscription;

  @override
  void onInit() {
    super.onInit();
    _markSubscription = db.markTable.select().watch().listen((_) {
      getAllMarks();
      _eventBus.fire(BookRefreshedEvent());
    });
    _markBookSubscription = db.markBookTable.select().watch().listen((_) {
      getAllMarks();
      _eventBus.fire(BookRefreshedEvent());
    });
  }

  Future<void> getAllMarks() async {
    final markList = await db.markTable.select().get();
    marks.value = markList;
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

  @override
  void onClose() {
    _markSubscription?.cancel();
    _markBookSubscription?.cancel();
    super.onClose();
  }
}
