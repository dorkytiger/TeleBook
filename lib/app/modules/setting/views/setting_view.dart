import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            controller: controller.videoPathController,
            decoration: const InputDecoration(
                icon: Icon(Icons.video_camera_front), labelText: "视频路径"),
          ),
          Row(
            children: [
              const Text(
                "下载自动刷新：",
                style: TextStyle(fontSize: 18),
              ),
              Obx(() => Switch(
                  value: controller.isRefresh.value,
                  onChanged: (value) {
                    controller.isRefresh.value = !controller.isRefresh.value;
                    controller.sharedPreferences.setBool("isRefresh", controller.isRefresh.value);
                  }))
            ],
          ),
          Row(
            children: [
              const Text(
                "书籍双行三行显示：",
                style: TextStyle(fontSize: 18),
              ),
              Obx(() => Switch(
                  value: controller.isDouble.value,
                  onChanged: (value) {
                    controller.isDouble.value = !controller.isDouble.value;
                    controller.sharedPreferences.setBool("isDouble", controller.isRefresh.value);
                  }))
            ],
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
                  children: [Icon(Icons.save), Text("保存",style: TextStyle(color: Colors.white),)],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
