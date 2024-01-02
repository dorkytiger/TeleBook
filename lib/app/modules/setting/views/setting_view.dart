import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingView'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          TextFormField(
            controller: controller.hostController,
            decoration: const InputDecoration(
                icon: Icon(Icons.home_filled), labelText: "主机地址"),
          ),
          TextFormField(
            controller: controller.portController,
            decoration: const InputDecoration(
                icon: Icon(Icons.crop_portrait), labelText: "端口"),
          ),
          TextFormField(
            controller: controller.userController,
            decoration: const InputDecoration(
                icon: Icon(Icons.person), labelText: "用户名"),
          ),
          TextFormField(
            controller: controller.passController,
            decoration: const InputDecoration(
                icon: Icon(Icons.password), labelText: "密码"),
          ),
          TextFormField(
            controller: controller.bookPathController,
            decoration: const InputDecoration(
                icon: Icon(Icons.password), labelText: "书库路径"),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.saveSetting();
                  Fluttertoast.showToast(

                      msg: "保存成功",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black45,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.save), Text("保存")],
                ),

              ),
              ElevatedButton(
                onPressed: () {
                  controller.connectTest();
                  Fluttertoast.showToast(
                      msg: controller.test.value,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black45,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.save), Text("测试连接")],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.sftpTest();
                  Fluttertoast.showToast(
                      msg: controller.sftpPath.value,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black45,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.save), Text("测试连接")],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
