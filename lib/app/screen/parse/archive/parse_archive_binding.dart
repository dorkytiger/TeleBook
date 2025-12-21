import 'package:get/get.dart';
import 'package:tele_book/app/screen/parse/archive/parse_archive_controller.dart';

class ParseArchiveBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ParseArchiveController());
  }
}