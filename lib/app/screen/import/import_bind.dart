import 'package:get/get.dart';
import 'import_controller.dart';

class ImportBind extends Bindings {
  @override
  void dependencies() {
      Get.lazyPut<ImportController>(() => ImportController());
  }
}