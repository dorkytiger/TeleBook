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
      appBar: const TDNavBar(
        title: "导出到服务器",
      ),
      body: Obx(() => DisplayResult(
          state: controller.getDownloadBookState.value,
          onLoading: () => const CustomLoading(),
          onError: (error) => CustomError(title: "", description: error),
          onSuccess: (value) {
            return ListView(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Obx(() => TDCheckboxGroupContainer(
                    selectIds: controller.selectedExportIds.value,
                    onCheckBoxGroupChange: (value) {
                      controller.setSelectedExportIds(value);
                    },
                    cardMode: true,
                    direction: Axis.vertical,
                    directionalTdCheckboxes:
                        controller.exportBookList.value.values
                            .map((e) => TDCheckbox(
                                  id: e.data.id.toString(),
                                  title: e.data.name,
                                  titleMaxLine: 1,
                                  subTitleMaxLine: 2,
                                  subTitle: () {
                                    if (e.status == ExportBookStatus.idle) {
                                      return e.isExport ? "已导出" : "未导出";
                                    } else if (e.status ==
                                        ExportBookStatus.running) {
                                      return "正在导出${e.current}/${e.total}";
                                    } else if (e.status ==
                                        ExportBookStatus.complete) {
                                      return "导出成功";
                                    } else {
                                      return e.errorMessage;
                                    }
                                  }(),
                                  cardMode: true,
                                ))
                            .toList()))
              ],
            );
          })),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Obx(() => TDButton(
                  theme: TDButtonTheme.primary,
                  text: "导出",
                  onTap: () {
                    controller.exportBook();
                  },
                  disabled: controller.exportBookState.value.isLoading(),
                )),
          ),
        ),
      ),
    );
  }
}
