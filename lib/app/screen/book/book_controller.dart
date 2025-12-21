import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookController extends GetxController {
  late final WebViewController webViewController;

  final parseUrl = TextEditingController();
  final getBookState = Rx<RequestState<List<BookTableData>>>(Idle());
  final deleteBookState = Rx<RequestState<void>>(Idle());
  late final String appDirectory;

  @override
  void onInit() async {
    super.onInit();
    appDirectory = (await getApplicationDocumentsDirectory()).path;
    await fetchBooks();
  }

  @override
  void onReady() {
    super.onReady();
    fetchBooks();  // 每次路由激活时自动刷新
  }

  Future<void> fetchBooks() async {
    getBookState.value = Loading();
    try {
      debugPrint("Fetching books from database...");
      final appDatabase = Get.find<AppDatabase>();
      final books = await appDatabase.bookTable.select().get();
      if(books.isEmpty){
        getBookState.value =Empty();
        return;
      }
      getBookState.value = Success(books);
    } catch (e) {
      debugPrint(e.toString());
      getBookState.value = Error(e.toString());
    }
  }

  Future<void> deleteBook(int id) async {
    deleteBookState.value.handleFunction(
      function: () async {
        final appDatabase = Get.find<AppDatabase>();
        await appDatabase.bookTable.deleteWhere((tbl) => tbl.id.equals(id));
        await fetchBooks();
      },
      onStateChanged: (newState) {
        deleteBookState.value = newState;
      },
    );
  }
}
