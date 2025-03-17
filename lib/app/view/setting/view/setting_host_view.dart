import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/util/request_state.dart';

import 'package:tele_book/app/view/setting/view/setting_host_controller.dart';
import 'package:tele_book/app/widget/custom_error.dart';
import 'package:tele_book/app/widget/custom_loading.dart';

class SettingHostView extends GetView<SettingHostController> {
  const SettingHostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: "远程主机设置",
      ),
      body: Obx(() => DisplayResult(
          state: controller.getSettingState.value,
          onError: (error) => CustomError(title: "获取设置失败", description: error),
          onLoading: () => const CustomLoading(),
          onSuccess: (value) => _hostInfo(context))),
      bottomNavigationBar: _buttonLayout(context),
    );
  }

  Widget _hostInfo(BuildContext context) {
    return ListView(
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
        TDInput(
          needClear: false,
          controller: controller.usernameTextController,
          leftIcon:
              Icon(TDIcons.user, color: TDTheme.of(context).brandNormalColor),
          leftLabel: "用户",
          backgroundColor: Colors.white,
        ),
        TDInput(
          needClear: false,
          controller: controller.passwordTextController,
          leftIcon: Icon(TDIcons.user_password,
              color: TDTheme.of(context).brandNormalColor),
          leftLabel: "密码",
          backgroundColor: Colors.white,
        ),
        TDInput(
          needClear: false,
          controller: controller.dataPathTextController,
          leftIcon:
              Icon(TDIcons.data, color: TDTheme.of(context).brandNormalColor),
          leftLabel: "数据目录",
          backgroundColor: Colors.white,
        ),
        TDInput(
          needClear: false,
          controller: controller.imagePathTextController,
          leftIcon:
              Icon(TDIcons.image, color: TDTheme.of(context).brandNormalColor),
          leftLabel: "图片目录",
          backgroundColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buttonLayout(BuildContext context) {
    return Obx(() => SizedBox(
          height: 200,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: TDButton(
                      disabled: controller.testConnectState.value.isLoading(),
                      theme: TDButtonTheme.primary,
                      text: "测试链接",
                      onTap: () {
                        controller.testConnect();
                      },
                    )),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                    width: double.infinity,
                    child: TDButton(
                      disabled: controller.testDataPathState.value.isLoading(),
                      theme: TDButtonTheme.primary,
                      text: "测试数据目录",
                      onTap: () {
                        controller.testDataPath();
                      },
                    )),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TDButton(
                    theme: TDButtonTheme.primary,
                    text: "保存",
                    onTap: () {
                      controller.saveSetting();
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
