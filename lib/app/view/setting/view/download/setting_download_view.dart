import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/setting/view/download/setting_download_controller.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_error.dart';
import 'package:tele_book/app/widget/custom_loading.dart';

class SettingDownloadView extends GetView<SettingDownloadController> {
  const SettingDownloadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TDNavBar(
        title: "从服务器下载",
      ),
      body: Obx(() => DisplayResult(
          state: controller.getDownloadBookState.value,
          onEmpty: ()=>const CustomEmpty(message: "服务器暂无可下载书籍"),
          onLoading: () => const CustomLoading(),
          onError: (error) => CustomError(title: "", description: error),
          onSuccess: (value) {
            return ListView(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Obx(() => TDCheckboxGroupContainer(
                    selectIds: controller.selectedDownloadIds.value,
                    onCheckBoxGroupChange: (value) {
                      controller.setSelectedDownloadIds(value);
                    },
                    cardMode: true,
                    direction: Axis.vertical,
                    directionalTdCheckboxes:
                        controller.downloadBookMap.value.values
                            .map((e) => TDCheckbox(
                                  id: e.data.id.toString(),
                                  title: e.data.name,
                                  titleMaxLine: 1,
                                  subTitleMaxLine: 2,
                                  subTitle: () {
                                    if (e.status == DownloadBookStatus.idle) {
                                      return e.isDownload ? "已下载" : "未下载";
                                    } else if (e.status ==
                                        DownloadBookStatus.downloading) {
                                      return "正在下载${e.progress}/${e.total}";
                                    } else if (e.status ==
                                        DownloadBookStatus.success) {
                                      return "下载成功";
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
                    text: "下载",
                    onTap: () {
                      controller.downloadBook();
                    },
                    disabled: controller.downloadBookState.value.isLoading(),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
