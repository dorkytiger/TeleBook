import 'package:get/get.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/screen/manage/manage_bind.dart';
import 'package:tele_book/app/screen/manage/manage_controller.dart';
import 'package:tele_book/app/screen/setting/setting_controller.dart';
import 'home_controller.dart';

class HomeBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<BookController>(() => BookController());
    Get.lazyPut<ManageController>(() => ManageController());
    Get.lazyPut<SettingController>(() => SettingController());
  }
}
