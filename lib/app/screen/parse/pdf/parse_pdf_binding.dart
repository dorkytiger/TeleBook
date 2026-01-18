import 'package:get/get.dart';

import 'parse_pdf_controller.dart';

class ParsePdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParsePdfController());
  }
}