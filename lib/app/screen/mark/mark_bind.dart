import 'package:get/get.dart';
import 'mark_controller.dart';

class MarkBind extends Bindings {
  @override
  void dependencies() {
      Get.lazyPut<MarkController>(() => MarkController());
  }
}