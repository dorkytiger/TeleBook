import 'package:get/get.dart';
import 'package:tele_book/app/view/setting/view/host/setting_host_controller.dart';


class SettingHostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingHostController());
  }
}
