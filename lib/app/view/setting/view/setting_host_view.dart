import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/view/setting/setting_controller.dart';

class SettingHostView extends GetView<SettingController> {
  const SettingHostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: "远程主机设置",
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_hostInfo(context), _buttonLayout(context)],
      ),
    );
  }

  Widget _hostInfo(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftIcon: Icon(TDIcons.system_application,
              color: TDTheme.of(context).brandNormalColor),
          leftLabel: "地址",
          backgroundColor: Colors.white,
        ),
        TDInput(
          leftLabel: "端口",
          leftIcon: Icon(TDIcons.system_interface,
              color: TDTheme.of(context).brandNormalColor),
          backgroundColor: Colors.white,
        ),
        TDInput(
          leftIcon:
              Icon(TDIcons.user, color: TDTheme.of(context).brandNormalColor),
          leftLabel: "用户",
          backgroundColor: Colors.white,
        ),
        TDInput(
          leftIcon: Icon(TDIcons.user_password,
              color: TDTheme.of(context).brandNormalColor),
          leftLabel: "密码",
          backgroundColor: Colors.white,
        ),
        TDCell(
          title: "导出配置目录",
          arrow: true,
          description: "11",
          leftIcon: TDIcons.file,
        ),
        TDCell(
          title: "导出图片目录",
          arrow: true,
          description: "11",
          leftIcon: TDIcons.image,
        )
      ],
    );
  }

  Widget _buttonLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
              width: double.infinity,
              child: TDButton(
                theme: TDButtonTheme.primary,
                text: "测试链接",
              )),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            child: TDButton(
              theme: TDButtonTheme.primary,
              text: "保存",
            ),
          )
        ],
      ),
    );
  }
}
