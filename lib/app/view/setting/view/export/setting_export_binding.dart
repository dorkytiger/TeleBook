import 'package:get/get.dart';
import 'package:tele_book/app/view/setting/view/export/setting_export_controller.dart';

class SettingExportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingExportController());
  }
}
