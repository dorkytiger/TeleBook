import 'package:get/get.dart';
import 'export_controller.dart';

class ExportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExportController>(() => ExportController());
  }
}
