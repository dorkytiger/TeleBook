import 'dart:async';
import 'dart:io' as io;

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/enum/setting/setting_key.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/service/export_service.dart';

class BookController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  final exportService = Get.find<ExportService>();
  final bookLayout = Rx<BookLayoutSetting>(BookLayoutSetting.list);
  final multiEditMode = false.obs;
  final selectedBookIds = <int>[].obs;
  final getBookState = Rx<DKStateQuery<List<BookTableData>>>(
    DkStateQueryIdle(),
  );
  final getCollectionState = Rx<DKStateQuery<List<CollectionTableData>>>(
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

  Future<void> triggerBookLayoutChange() async {
    if (bookLayout.value == BookLayoutSetting.list) {
      bookLayout.value = BookLayoutSetting.grid;
    } else {
      bookLayout.value = BookLayoutSetting.list;
    }
    final layout = bookLayout.value;
    await prefs.setInt(SettingKey.bookLayout, layout.value);
  }

  void toggleSelectBook(int bookId) {
    if (selectedBookIds.contains(bookId)) {
      selectedBookIds.remove(bookId);
    } else {
      selectedBookIds.add(bookId);
    }
  }

  void triggerMultiEditMode() {
    multiEditMode.value = !multiEditMode.value;
    if (!multiEditMode.value) {
      selectedBookIds.clear();
    }
  }

  Future<void> fetchBooks() async {
    getBookState.triggerQuery(
      query: () => appDatabase.bookTable.select().get(),
      isEmpty: (data) => data.isEmpty,
    );
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
    await exportService.exportBook(data);
    await Future.delayed(Duration(milliseconds: 100), () {
      Get.toNamed(AppRoute.export);
    });
  }

  Future<void> exportMultipleBooks() async {
    final ids = selectedBookIds.toList();
    final books =
        await (appDatabase.bookTable.select()..where((tbl) => tbl.id.isIn(ids)))
            .get();
    await exportService.exportMultiple(books);
    selectedBookIds.clear();
    multiEditMode.value = false;
    await Future.delayed(Duration(milliseconds: 100), () {
      Get.toNamed(AppRoute.export);
    });
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
