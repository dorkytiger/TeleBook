import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/setting/view/export/setting_export_controller.dart';
import 'package:tele_book/app/widget/custom_error.dart';
import 'package:tele_book/app/widget/custom_loading.dart';

class SettingExportView extends GetView<SettingExportController> {
  const SettingExportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(()=>DisplayResult(
          state: controller.getDownloadBookState.value,
          onLoading: ()=>const CustomLoading(),
          onError: (error)=>CustomError(title: "", description: error),
          onSuccess: (value) {
            return ListView(
              children: [
                TDCheckboxGroupContainer(
                  selectIds: const ['index:1'],
                  cardMode: true,
                  direction: Axis.vertical,
                  directionalTdCheckboxes: [
                    TDCheckbox(
                      id: 'index:0',
                      title: '多选',
                      titleMaxLine: 2,
                      subTitleMaxLine: 2,
                      subTitle: '描述信息',
                      cardMode: true,
                    ),
                    TDCheckbox(
                      id: 'index:1',
                      title: '多选',
                      titleMaxLine: 2,
                      subTitleMaxLine: 2,
                      subTitle: '描述信息',
                      cardMode: true,
                    ),
                    TDCheckbox(
                      id: 'index:2',
                      title: '多选',
                      titleMaxLine: 2,
                      subTitleMaxLine: 2,
                      subTitle: '描述信息',
                      cardMode: true,
                    ),
                    TDCheckbox(
                      id: 'index:3',
                      title: '多选',
                      titleMaxLine: 2,
                      subTitleMaxLine: 2,
                      subTitle: '描述信息',
                      cardMode: true,
                    ),
                  ],
                )
              ],
            );
          }))
    );
  }
}