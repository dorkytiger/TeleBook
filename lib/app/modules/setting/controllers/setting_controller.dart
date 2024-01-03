import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  //TODO: Implement SettingController
  TextEditingController hostController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController bookPathController = TextEditingController();
  TextEditingController videoPathController=TextEditingController();
  RxString test="".obs;
  RxString sftpPath="".obs;
  @override
  void onInit() {
    getSetting();
    super.onInit();
  }



  Future saveSetting() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('host', hostController.text);
    sharedPreferences.setString('port', portController.text);
    sharedPreferences.setString('user', userController.text);
    sharedPreferences.setString('pass', passController.text);
    sharedPreferences.setString('book', bookPathController.text);
    sharedPreferences.setString('video', videoPathController.text);
  }

  Future getSetting() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    hostController.text = sharedPreferences.getString('host') ?? "";
    portController.text = sharedPreferences.getString('port') ?? "";
    userController.text = sharedPreferences.getString('user') ?? "";
    passController.text = sharedPreferences.getString('pass') ?? "";
    bookPathController.text = sharedPreferences.getString('book') ?? "";
    videoPathController.text = sharedPreferences.getString('video') ?? "";
  }

  connectTest() async {
    final client = SSHClient(
        await SSHSocket.connect(
            hostController.text,int.parse( portController.text)),
        username: userController.text,
        onPasswordRequest: () => passController.text);
    final uptime = await client.run('uptime');
    test.value=utf8.decode(uptime);
    print(utf8.decode(uptime));
  }

}
