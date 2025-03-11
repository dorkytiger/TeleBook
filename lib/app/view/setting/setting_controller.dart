import 'package:get/get.dart';

class SettingController extends GetxController {
  RxBool gridCount = false.obs;
  RxBool showTitle = false.obs;

  @override
  void onInit() async {

    super.onInit();
  }

  setGridCount(bool value) {
    gridCount.value = value;
    update();
  }

  setShowTitle(bool value) {
    showTitle.value = value;
    update();
  }
}
