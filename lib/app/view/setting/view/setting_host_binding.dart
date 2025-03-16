import 'package:get/get.dart';
import 'package:tele_book/app/view/setting/setting_controller.dart';

class SettingHostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}
