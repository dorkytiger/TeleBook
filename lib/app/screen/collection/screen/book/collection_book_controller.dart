import 'dart:async';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
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
  final getCollectionBooksState = Rx<DKStateQuery<List<BookTableData>>>(
    DkStateQueryIdle(),
  );
  late final String appDirectory;

  @override
  void onInit() async {
    super.onInit();
    appDirectory = (await getApplicationDocumentsDirectory()).path;
    unawaited(getCollectionBooks());
  }

  Future<void> getCollectionBooks() async {
    await getCollectionBooksState.triggerQuery(
      query: () async {
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
      },
      isEmpty: (result) => result.isEmpty,
    );
  }
}
