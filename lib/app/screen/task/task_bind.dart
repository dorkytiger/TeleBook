import 'package:get/get.dart';
import 'package:tele_book/app/screen/download/download_binding.dart';
import 'package:tele_book/app/screen/export/export_binding.dart';
import 'package:tele_book/app/screen/import/import_bind.dart';
import 'task_controller.dart';

class TaskBind extends Bindings {
  @override
  void dependencies() {
      Get.lazyPut<TaskController>(() => TaskController());

      DownloadBinding().dependencies();
      ExportBinding().dependencies();
      ImportBind().dependencies();
  }
}