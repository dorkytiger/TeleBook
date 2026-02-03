import 'package:get/get.dart';
import 'export_controller.dart';
import 'package:tele_book/app/service/export_service.dart';

class ExportBinding extends Bindings {
  @override
  void dependencies() {
    // ensure ExportService exists when opening export screen directly
    Get.put<ExportService>(ExportService());
    Get.lazyPut<ExportController>(() => ExportController());
  }
}
