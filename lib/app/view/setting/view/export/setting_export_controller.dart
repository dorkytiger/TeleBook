import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/request_state.dart';

class SettingExportController extends GetxController{
  final appDatabase = Get.find<AppDatabase>();

  final getDownloadBookState = Rx<RequestState<List<BookTableData>>>(Idle());

  Future<void> getDownloadBook() async {
    try {

    } catch (e) {
      debugPrint(e.toString());
      getDownloadBookState.value = Error(e.toString());
    }
  }
}