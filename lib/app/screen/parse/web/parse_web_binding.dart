import 'package:get/get.dart';
import 'package:tele_book/app/screen/parse/web/parse_web_controller.dart';

class ParseWebBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParseWebController());
  }
}
