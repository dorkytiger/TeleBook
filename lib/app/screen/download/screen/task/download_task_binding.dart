import 'package:get/get.dart';
import 'package:tele_book/app/screen/download/screen/task/download_task_controller.dart';

class DownloadTaskBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<DownloadTaskController>(
      () => DownloadTaskController(),
    );
  }

}