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
  late final String appDirectory;

  @override
  void onInit() {
    super.onInit();

    fetchBooks();
  }

  Future<void> fetchBooks() async {
    getBookState.value = Loading();
    try {
      final appDatabase = Get.find<AppDatabase>();
      appDirectory = (await getApplicationDocumentsDirectory()).path;
      final books = await appDatabase.bookTable.select().get();
      getBookState.value = Success(books);
    } catch (e) {
      getBookState.value = Error(e.toString());
    }
  }
}
