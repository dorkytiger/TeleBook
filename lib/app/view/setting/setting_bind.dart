import 'package:get/get.dart';
import 'package:wo_nas/app/view/setting/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(() => SettingController());
  }
}
