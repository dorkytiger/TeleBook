import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/request_state.dart';

class SettingServerController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  final getSettingTableState = Rx<RequestState<SettingTableData>>(Idle());
  final saveSettingTableState = Rx<RequestState<void>>(Idle());
  final hostTextController = TextEditingController();
  final portTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    ever(saveSettingTableState, (state) {
      if (state.isSuccess()) {
        Get.showSnackbar(const GetSnackBar(
          message: "保存成功",
          duration: Duration(seconds: 2),
        ));
        getSettingTable();
        return;
      }
      if (state.isError()) {
        Get.showSnackbar(GetSnackBar(
          message: "保存失败${state.getErrorMessage()}",
          duration: const Duration(seconds: 2),
        ));
      }
    });
    getSettingTable();
  }

  Future<void> getSettingTable() async {
    try {
      getSettingTableState.value = Loading();
      final settingTable =
          await appDatabase.select(appDatabase.settingTable).getSingle();
      hostTextController.text = settingTable.serverHost;
      portTextController.text = settingTable.serverPort.toString();
      getSettingTableState.value = Success(settingTable);
    } catch (e) {
      getSettingTableState.value = Error(e.toString());
    }
  }

  Future<void> saveSettingTable() async {
    try {
      saveSettingTableState.value = Loading();
      final newSettingTable = getSettingTableState.value
          .getSuccessData()
          .copyWith(
              serverHost: hostTextController.text,
              serverPort: int.parse(portTextController.text));
      await appDatabase
          .update(appDatabase.settingTable)
          .replace(newSettingTable);
      saveSettingTableState.value = const Success(null);
    } catch (e) {
      saveSettingTableState.value = Error(e.toString());
    }
  }
}
