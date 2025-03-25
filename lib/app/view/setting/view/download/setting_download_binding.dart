import 'package:get/get.dart';
import 'package:tele_book/app/view/setting/view/download/setting_download_controller.dart';
import 'package:tele_book/app/view/setting/view/upload/setting_upload_controller.dart';

class SettingDownloadBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SettingDownloadController());
  }

}