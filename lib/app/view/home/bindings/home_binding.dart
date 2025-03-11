import 'package:get/get.dart';

import '../../book/book_controller.dart';
import '../../download/controllers/download_controller.dart';
import '../../setting/setting_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
