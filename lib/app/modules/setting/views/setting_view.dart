import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          TextFormField(
            controller: controller.bookPathController,
            decoration: const InputDecoration(
                icon: Icon(Icons.password), labelText: "书库路径"),
          ),
          TextFormField(
            controller: controller.videoPathController,
            decoration: const InputDecoration(
                icon: Icon(Icons.password), labelText: "视频路径"),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.saveSetting();
                  Get.snackbar("提示", "保存成功");
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.save), Text("保存")],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
