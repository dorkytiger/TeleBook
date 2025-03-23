import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/setting/view/import/setting_import_controller.dart';
import 'package:tele_book/app/widget/custom_error.dart';
import 'package:tele_book/app/widget/custom_loading.dart';

class SettingImportView extends GetView<SettingImportController> {
  const SettingImportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TDNavBar(
        title: "从服务器导入数据",
      ),
      body: Obx(() => DisplayResult(
          state: controller.getImportBookListState.value,
          onLoading: () => const CustomLoading(),
          onError: (error) => CustomError(title: "", description: error),
          onSuccess: (value) {
            return ListView(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Obx(() => TDCheckboxGroupContainer(
                      selectIds: controller.selectImportBookIds.value,
                      onCheckBoxGroupChange: (value){
                        controller.setImportBookIds(value);
                      },
                      cardMode: true,
                      direction: Axis.vertical,
                      directionalTdCheckboxes:
                          controller.importBookMap.value.values
                              .map((e) => TDCheckbox(
                                    id: e.name,
                                    title: e.name,
                                    titleMaxLine: 1,
                                    subTitleMaxLine: 2,
                                    subTitle: () {
                                      if (e.status == ImportBookStatus.idle) {
                                        return e.isImport ? "已导入" : "未导入";
                                      } else if (e.status ==
                                          ImportBookStatus.running) {
                                        return "正在导入${e.current}/${e.total}";
                                      } else if (e.status ==
                                          ImportBookStatus.complete) {
                                        return "导入成功";
                                      } else {
                                        return e.errorMessage;
                                      }
                                    }(),
                                    cardMode: true,
                                  ))
                              .toList(),
                    ))
              ],
            );
          })),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Obx(() => TDButton(
                  theme: TDButtonTheme.primary,
                  text: "导入",
                  onTap: () {
                    controller.importBook();
                  },
                  disabled: controller.importBookState.value.isLoading(),
                )),
          ),
        ),
      ),
    );
  }
}
