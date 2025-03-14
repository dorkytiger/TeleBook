import 'package:get/get.dart';
import 'package:tele_book/app/view/setting/view/transmit/setting_transmit_controller.dart';

class SettingTransmitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingTransmitController>(() => SettingTransmitController());
  }
}