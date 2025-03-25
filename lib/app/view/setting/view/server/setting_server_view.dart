import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/setting/view/server/setting_server_controller.dart';

class SettingServerView extends GetView<SettingServerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: "服务器设置",
      ),
      body: Obx(()=>DisplayResult(
          state: controller.getSettingTableState.value,
          onSuccess: (value) => (ListView(
            children: [
              TDInput(
                needClear: false,
                controller: controller.hostTextController,
                leftIcon: Icon(TDIcons.system_application,
                    color: TDTheme.of(context).brandNormalColor),
                leftLabel: "地址",
                backgroundColor: Colors.white,
              ),
              TDInput(
                needClear: false,
                controller: controller.portTextController,
                leftLabel: "端口",
                leftIcon: Icon(TDIcons.system_interface,
                    color: TDTheme.of(context).brandNormalColor),
                backgroundColor: Colors.white,
              ),
            ],
          )))),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: TDButton(
            theme: TDButtonTheme.primary,
            text: "保存",
            onTap: (){
              controller.saveSettingTable();
            },
          ),
        ),
      ),
    );
  }
}
