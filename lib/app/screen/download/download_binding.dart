import 'package:get/get.dart';
import 'package:tele_book/app/screen/download/download_controller.dart';



class DownloadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DownloadController>(
      () => DownloadController(),
    );
  }
}
