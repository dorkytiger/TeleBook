import 'dart:async';

import 'package:drift/drift.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/util/request_state.dart';

class CollectionBookController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  final collectionId = Get.arguments['collectionId'] as int;
  final collectionName = Get.arguments['collectionName'] as String;
  final getCollectionBooksState = Rx<RequestState<List<BookTableData>>>(Idle());
  late final String appDirectory;

  @override
  void onInit() async {
    super.onInit();
    appDirectory = (await getApplicationDocumentsDirectory()).path;
    unawaited(getCollectionBooks());
  }

  Future<void> getCollectionBooks() async {
    await getCollectionBooksState.runFuture(() async {
      final collectionBooks =
          await (appDatabase.collectionBookTable.select()
                ..where((tbl) => tbl.collectionId.equals(collectionId)))
              .get();
      final bookIds = collectionBooks.map((e) => e.bookId).toList();
      if (bookIds.isEmpty) {
        return <BookTableData>[];
      } else {
        final booksQuery = appDatabase.bookTable.select()
          ..where((tbl) => tbl.id.isIn(bookIds));
        final books = await booksQuery.get();
        return books;
      }
    }, isEmpty: (result) => result.isEmpty);
  }
}
