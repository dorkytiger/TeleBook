import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/setting/view/upload/setting_upload_controller.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_error.dart';
import 'package:tele_book/app/widget/custom_loading.dart';

class SettingUploadView extends GetView<SettingUploadController> {
  const SettingUploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TDNavBar(
        title: "上传到服务器",
      ),
      body: Obx(() => DisplayResult(
          state: controller.getDownloadBookState.value,
          onEmpty: ()=>const CustomEmpty(message: "暂无可上传书籍"),
          onLoading: () => const CustomLoading(),
          onError: (error) => CustomError(title: "", description: error),
          onSuccess: (value) {
            return ListView(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Obx(() => TDCheckboxGroupContainer(
                    selectIds: controller.selectedUploadIds.value,
                    onCheckBoxGroupChange: (value) {
                      controller.setSelectedUploadIds(value);
                    },
                    cardMode: true,
                    direction: Axis.vertical,
                    directionalTdCheckboxes:
                        controller.uploadBookMap.value.values
                            .map((e) => TDCheckbox(
                                  id: e.data.id.toString(),
                                  title: e.data.name,
                                  titleMaxLine: 1,
                                  subTitleMaxLine: 2,
                                  subTitle: () {
                                    if (e.status == UploadBookStatus.idle) {
                                      return e.isUpload ? "已上传" : "未上传";
                                    } else if (e.status ==
                                        UploadBookStatus.uploading) {
                                      return "正在上传${e.progress}/${e.total}";
                                    } else if (e.status ==
                                        UploadBookStatus.success) {
                                      return "上传成功";
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
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: Obx(() => TDButton(
                theme: TDButtonTheme.primary,
                text: "上传",
                onTap: () {
                  controller.uploadBook();
                },
                disabled: controller.uploadBookState.value.isLoading(),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
