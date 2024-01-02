import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
  RxString test="".obs;
  RxString sftpPath="".obs;
  @override
  void onInit() {
    getSetting();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future saveSetting() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('host', hostController.text);
    sharedPreferences.setString('port', portController.text);
    sharedPreferences.setString('user', userController.text);
    sharedPreferences.setString('pass', passController.text);
    sharedPreferences.setString('book', bookPathController.text);
  }

  Future getSetting() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    hostController.text = sharedPreferences.getString('host') ?? "";
    portController.text = sharedPreferences.getString('port') ?? "";
    userController.text = sharedPreferences.getString('user') ?? "";
    passController.text = sharedPreferences.getString('pass') ?? "";
    bookPathController.text = sharedPreferences.getString('book') ?? "";
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

  sftpTest() async{
    final client = SSHClient(
        await SSHSocket.connect(
            hostController.text,int.parse( portController.text)),
        username: userController.text,
        onPasswordRequest: () => passController.text);
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    final pathList= await client.run("ls ${sharedPreferences.getString('book') ??""}");
    sftpPath.value=utf8.decode(pathList);
    print(utf8.decode(pathList));
  }
}
