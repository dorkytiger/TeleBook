import 'package:get/get.dart';
import 'package:tele_book/app/screen/parse/parse_controller.dart';

class ParseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParseController());
  }
}
