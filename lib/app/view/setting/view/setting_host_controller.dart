import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/request_state.dart';

class SettingHostController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  final getSettingState = Rx<RequestState<SettingTableData>>(Idle());
  final testConnectState = Rx<RequestState<void>>(Idle());
  final testDataPathState = Rx<RequestState<void>>(Idle());
  final saveSettingState = Rx<RequestState<void>>(Idle());
  final hostTextController = TextEditingController();
  final portTextController = TextEditingController();
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final dataPathTextController = TextEditingController();
  final imagePathTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getSetting();
    ever(testConnectState, (state) {
      if (state.isSuccess()) {
        Get.showSnackbar(GetSnackBar(
          title: "测速链接成功",
          message: hostTextController.text,
          duration: const Duration(seconds: 3),
        ));
        return;
      }
      if (state.isError()) {
        Get.showSnackbar(GetSnackBar(
          title: "测速链接失败",
          message: state.getErrorMessage(),
          duration: const Duration(seconds: 3),
        ));
        return;
      }
      ever(testDataPathState, (state) {
        if (state.isSuccess()) {
          Get.showSnackbar(GetSnackBar(
            title: "检查数据目录成功",
            message: dataPathTextController.text,
            duration: const Duration(seconds: 3),
          ));
          return;
        }
        if (state.isError()) {
          Get.showSnackbar(GetSnackBar(
            title: "检查数据目录失败",
            message: state.getErrorMessage(),
            duration: const Duration(seconds: 3),
          ));
          return;
        }
      });
      ever(saveSettingState, (state) {
        if (state.isSuccess()) {
          Get.showSnackbar(GetSnackBar(
            title: "保存成功",
            message: hostTextController.text,
            duration: const Duration(seconds: 3),
          ));
          getSetting();
          getSettingState.value = Idle();
          return;
        }
        if (state.isError()) {
          Get.showSnackbar(GetSnackBar(
            title: "保存失败",
            message: state.getErrorMessage(),
            duration: const Duration(seconds: 3),
          ));
          getSettingState.value = Idle();
          return;
        }
      });
    });
  }

  Future<void> getSetting() async {
    try {
      getSettingState.value = Loading();
      final settingData =
          await appDatabase.select(appDatabase.settingTable).getSingle();
      hostTextController.text = settingData.host;
      portTextController.text = settingData.port.toString();
      usernameTextController.text = settingData.username;
      passwordTextController.text = settingData.password;
      dataPathTextController.text = settingData.dataPath;
      imagePathTextController.text = settingData.imagePath;
      getSettingState.value = Success(settingData);
    } catch (e) {
      debugPrint(e.toString());
      getSettingState.value = Error("获取设置失败：${e.toString()}");
    }
  }

  Future<void> saveSetting() async {
    try {
      saveSettingState.value = Loading();
      if (int.tryParse(portTextController.text) == null) {
        throw Exception("端口号必须为数字");
      }
      final settingData = getSettingState.value.getSuccessData().copyWith(
            host: hostTextController.text,
            port: int.parse(portTextController.text),
            username: usernameTextController.text,
            password: passwordTextController.text,
            dataPath: dataPathTextController.text,
            imagePath: imagePathTextController.text,
          );
      await appDatabase.update(appDatabase.settingTable).replace(settingData);
      saveSettingState.value = const Success(null);
    } catch (e) {
      debugPrint(e.toString());
      saveSettingState.value = Error("保存设置失败：${e.toString()}");
    }
  }

  Future<void> testConnect() async {
    try {
      testConnectState.value = Loading();
      if (int.tryParse(portTextController.text) == null) {
        throw Exception("端口号必须为数字");
      }
      final socket = await SSHSocket.connect(
          hostTextController.text, int.parse(portTextController.text),
          timeout: const Duration(seconds: 5));
      final client = SSHClient(
        socket,
        username: usernameTextController.text,
        onPasswordRequest: () => passwordTextController.text,
      );
      await client.authenticated;
      await client.ping();
      client.close();
      await socket.close();
      testConnectState.value = Success(null);
    } catch (e) {
      debugPrint(e.toString());
      testConnectState.value = Error("连接失败：${e.toString()}");
    }
  }

  Future<void> testDataPath() async {
    try {
      testDataPathState.value = Loading();
      if (int.tryParse(portTextController.text) == null) {
        throw Exception("端口号必须为数字");
      }
      final socket = await SSHSocket.connect(
          hostTextController.text, int.parse(portTextController.text),
          timeout: const Duration(seconds: 5));
      final client = SSHClient(
        socket,
        username: usernameTextController.text,
        onPasswordRequest: () => passwordTextController.text,
      );
      final sftp = await client.sftp();
      final file = await sftp.stat(dataPathTextController.text);
      if (!file.isDirectory) {
        throw Exception("数据目录不是文件夹");
      }
      sftp.close();
      client.close();
      await socket.close();
      testDataPathState.value = const Success(null);
    } catch (e) {
      debugPrint(e.toString());
      testDataPathState.value = Error("检查数据目录失败：${e.toString()}");
    }
  }


}
