import 'package:get/get.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_controller.dart';

class ParseBatchArchiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParseBatchArchiveController());
  }
}

