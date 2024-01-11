import 'package:get/get.dart';
import 'package:wo_nas/app/modules/book/controllers/book_controller.dart';
import 'package:wo_nas/app/modules/download/controllers/download_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<BookController>(() => BookController());
    Get.lazyPut(() => DownloadController());
  }
}
