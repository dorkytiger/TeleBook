import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wo_nas/app/view/setting/widget/setting_cell_widget.dart';
import 'setting_controller.dart';

class SettingPageView extends GetView<SettingController> {
  const SettingPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(()=>SettingCellWidget(
              title: '是否一行显示两列',
              child: Switch(
                activeColor: Colors.blue,
                value: controller.gridCount.value,
                onChanged: (value) {
                  controller.setGridCount(value);
                },
              ))),
          Obx(()=>SettingCellWidget(
              title: '是否显示标题',
              child: Switch(
                activeColor: Colors.blue,
                value: controller.showTitle.value,
                onChanged: (value) {
                  controller.setShowTitle(value);
                },
          )))
        ],
      ),
    );
  }
}
