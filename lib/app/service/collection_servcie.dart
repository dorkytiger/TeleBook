import 'dart:async';

import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/event/event_bus.dart';

class CollectionService extends GetxService {
  final _eventBus = Get.find<EventBus>();
  final db = Get.find<AppDatabase>();
  final collections = <CollectionTableData>[].obs;
  final collectionBooks = <CollectionBookTableData>[].obs;

  StreamSubscription? _collectionSubscription;
  StreamSubscription? _collectionBookSubscription;

  @override
  void onInit() {
    super.onInit();
    getCollections();
    _collectionSubscription = db.collectionTable.select().watch().listen((
      event,
    ) {
      getCollections();
      getCollectionBooks();
    });
    _collectionBookSubscription = db.collectionBookTable
        .select()
        .watch()
        .listen((event) {
          getCollections();
          getCollectionBooks();
        });
  }

  Future<void> getCollections() async {
    final data = await db.collectionTable.select().get();
    collections.assignAll(data);
  }

  Future<void> getCollectionBooks() async {
    final data = await db.collectionBookTable.select().get();
    collectionBooks.assignAll(data);
  }

  Future<void> updateBookCollection(int collectionId, int bookId) async {
    await db.transaction(() async {
      await (db.collectionBookTable.delete()
            ..where((tbl) => tbl.bookId.equals(bookId)))
          .go();
      if (collectionId != 0) {
        await db.collectionBookTable.insertOnConflictUpdate(
          CollectionBookTableCompanion(
            bookId: Value(bookId),
            collectionId: Value(collectionId),
          ),
        );
      }
    });
  }

  Future<void> saveCollection({
    int? id,
    required String name,
    required int color,
    required int icon,
  }) async {
    await db.collectionTable.insertOnConflictUpdate(
      CollectionTableCompanion(
        id: id != null ? Value(id) : Value.absent(),
        name: Value(name),
        color: Value(color),
        icon: Value(icon),
      ),
    );
  }

  Future<void> deleteCollection(int collectionId) async {
    await db.transaction(() async {
      await (db.collectionTable.delete()
            ..where((tbl) => tbl.id.equals(collectionId)))
          .go();
      await (db.collectionBookTable.delete()
            ..where((tbl) => tbl.collectionId.equals(collectionId)))
          .go();
    });
  }

  @override
  void onClose() {
    _collectionSubscription?.cancel();
    _collectionBookSubscription?.cancel();
    super.onClose();
  }
}
