import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {


  TextEditingController videoPathController=TextEditingController();
  late SharedPreferences sharedPreferences;
  RxBool isRefresh=false.obs;
  RxBool isDouble=false.obs;

  @override
  void onInit() async {
    sharedPreferences=await SharedPreferences.getInstance();
    getSetting();
    super.onInit();
  }



  Future saveSetting() async {
    sharedPreferences.setString('video', videoPathController.text);
  }

  Future getSetting() async {
    videoPathController.text = sharedPreferences.getString('video') ?? "";
  }

}
