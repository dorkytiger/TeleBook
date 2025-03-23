import 'package:get/get.dart';
import 'package:tele_book/app/view/setting/view/import/setting_import_controller.dart';

class SettingImportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingImportController());
  }
}
