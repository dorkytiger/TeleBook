import 'package:get/get.dart';
import 'package:tele_book/app/view/setting/view/upload/setting_upload_controller.dart';

class SettingUploadBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SettingUploadController());
  }

}