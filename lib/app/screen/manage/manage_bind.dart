import 'package:get/get.dart';
import 'manage_controller.dart';

class ManageBind extends Bindings {
  @override
  void dependencies() {
      Get.lazyPut<ManageController>(() => ManageController());
  }
}