import 'package:get/get.dart';
import 'package:wo_nas/app/modules/book/controllers/book_controller.dart';
import 'package:wo_nas/app/modules/setting/controllers/setting_controller.dart';
import 'package:wo_nas/app/modules/video/controllers/video_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<SettingController>(() => SettingController());
    Get.lazyPut<BookController>(() => BookController());
    Get.lazyPut(() => VideoController());
  }
}
