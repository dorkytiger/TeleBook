import 'package:get/get.dart';
import 'setting_controller.dart';

class SettingBind extends Bindings {
  @override
  void dependencies() {
      Get.lazyPut<SettingController>(() => SettingController());
  }
}