import 'package:get/get.dart';
import 'package:tele_book/app/nav/nav_controller.dart';
import 'package:tele_book/app/view/book/book_controller.dart';
import 'package:tele_book/app/view/download/download_controller.dart';
import 'package:tele_book/app/view/setting/setting_controller.dart';

class NavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavController>(
      () => NavController(),
    );
    Get.lazyPut<DownloadController>(
          () => DownloadController(),
    );
    Get.lazyPut<BookController>(
          () => BookController(),
    );
    Get.lazyPut<SettingController>(
          () => SettingController(),
    );
  }
}