import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../book/controllers/book_controller.dart';

class SettingController extends GetxController {
  RxBool gridCount = false.obs;
  RxBool showTitle = false.obs;
  late SharedPreferences sharedPreferences;

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    gridCount.value = sharedPreferences.getBool("gridCount") ?? false;
    showTitle.value = sharedPreferences.getBool("showTitle") ?? false;
    super.onInit();
  }

  setGridCount(bool value) {
    gridCount.value = value;
    sharedPreferences.setBool("gridCount", value);
    update();
  }

  setShowTitle(bool value) {
    showTitle.value = value;
    sharedPreferences.setBool("showTitle", value);
    update();
  }
}
