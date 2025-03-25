import 'package:get/get.dart';
import 'package:tele_book/app/view/setting/view/server/setting_server_controller.dart';

class SettingServerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingServerController>(() => SettingServerController());
  }
}