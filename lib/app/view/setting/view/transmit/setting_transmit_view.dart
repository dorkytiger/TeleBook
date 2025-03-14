import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/setting/view/transmit/setting_transmit_controller.dart';
import 'package:tele_book/app/widget/custom_loading.dart';

class SettingTransmitView extends GetView<SettingTransmitController> {
  const SettingTransmitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TDNavBar(
        title: "局域网同步",
      ),
      body: Obx(() => DisplayResult(
          state: controller.initState.value,
          onLoading: () => const CustomLoading(),
          onSuccess: (value) {
            if (controller.transmitType == TransmitType.receive) {
              return _registrationWidget();
            } else {
              return _discoverDevice();
            }
          })),
    );
  }

  Widget _discoverDevice() {
    return Obx(() => ListView(
          children: [
            TDCellGroup(
                title: "发现设备",
                cells: controller.serviceList
                    .map((e) => TDCell(
                          title: e.name,
                          description: e.host,
                          note: e.port.toString(),
                        ))
                    .toList()),
          ],
        ));
  }

  Widget _registrationWidget() {
    return TDCellGroup(
      title: "注册服务",
      cells: [
        TDCell(
          title: controller.registration.service.name,
          description: controller.registration.service.host,
          note: controller.registration.service.port.toString(),
        )
      ],
    );
  }
}
