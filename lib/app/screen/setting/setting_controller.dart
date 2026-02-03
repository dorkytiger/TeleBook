import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/enum/setting/setting_key.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/service/export_service.dart';

class SettingController extends GetxController {
  final SharedPreferences prefs = Get.find<SharedPreferences>();
  final settingDataState = SettingData().obs;
  final exportService = Get.find<ExportService>();

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> initSettingData() async {
    final layoutValue =
        prefs.getInt(SettingKey.bookLayout) ?? BookLayoutSetting.list.value;
    settingDataState.update((val) {
      val?.bookLayoutSetting = BookLayoutSetting.fromValue(layoutValue);
    });
    final bookController = Get.find<BookController>();
    bookController.bookLayout.value = BookLayoutSetting.fromValue(layoutValue);
  }

  Future<void> setBookLayout(BookLayoutSetting layout) async {
    await prefs.setInt(SettingKey.bookLayout, layout.value);
    final bookController = Get.find<BookController>();
    bookController.bookLayout.value = layout;
  }
}

class SettingData {
  BookLayoutSetting bookLayoutSetting = BookLayoutSetting.list;
}
