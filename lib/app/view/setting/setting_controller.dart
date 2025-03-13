import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/request_state.dart';

class SettingController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();

  final _getSettingDataState = Rx<RequestState<SettingTableData>>(Idle());

  get getSettingDataState => _getSettingDataState.value;

  @override
  void onInit() {
    getSettingData();
    super.onInit();
  }

  Future<void> getSettingData() async {
    try {
      _getSettingDataState.value = Loading();
      final settingData =
          await appDatabase.select(appDatabase.settingTable).getSingle();
      _getSettingDataState.value = Success(settingData);
    } catch (e) {
      _getSettingDataState.value = Error(e.toString());
      debugPrint(e.toString());
    }
  }

  Future<void> updateSettingData(SettingTableData settingData) async {
    try {
      await appDatabase.update(appDatabase.settingTable).replace(settingData);
      getSettingData();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
