import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {

  TextEditingController bookPathController = TextEditingController();
  TextEditingController videoPathController=TextEditingController();
  @override
  void onInit() {
    getSetting();
    super.onInit();
  }



  Future saveSetting() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('book', bookPathController.text);
    sharedPreferences.setString('video', videoPathController.text);
  }

  Future getSetting() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bookPathController.text = sharedPreferences.getString('book') ?? "";
    videoPathController.text = sharedPreferences.getString('video') ?? "";
  }

}
