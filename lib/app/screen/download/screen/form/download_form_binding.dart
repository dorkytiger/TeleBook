import 'package:get/get.dart';
import 'package:tele_book/app/screen/download/screen/form/download_form_controller.dart';

class DownloadFormBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<DownloadFormController>(
      () => DownloadFormController(),
    );
  }
}