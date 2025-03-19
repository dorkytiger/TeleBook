import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/request_state.dart';

class SettingImportController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();

  final getDownloadBookState = Rx<RequestState<List<BookTableData>>>(Idle());

  Future<void> getDownloadBook() async {
    try {
      getDownloadBookState.value = Loading();
      final downloadBookList = await (appDatabase.select(appDatabase.bookTable)
            ..where((t) => t.isDownload.equals(true)))
          .get();
      if (downloadBookList.isEmpty) {
        getDownloadBookState.value = Empty();
        return;
      }
      getDownloadBookState.value = Success(downloadBookList);
    } catch (e) {
      debugPrint(e.toString());
      getDownloadBookState.value = Error(e.toString());
    }
  }
}
