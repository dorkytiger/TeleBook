import 'package:get/get.dart';
import 'package:tele_book/app/screen/parse/archive/screen/single/parse_single_archive_controller.dart';


class ParseSingleArchiveBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ParseSingleArchiveController());
  }
}