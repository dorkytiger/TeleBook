import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/service/import_service.dart';

class ImportController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final tabController = TabController(length: 3, vsync: this);
  final importService = Get.find<ImportService>();
  final appDocPath = RxnString(); // null 表示还未初始化

  @override
  void onInit() async {
    super.onInit();
    appDocPath.value = await getApplicationDocumentsDirectory().then(
      (dir) => dir.path,
    );
  }
}
