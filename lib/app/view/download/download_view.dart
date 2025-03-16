import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/download/download_controller.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_error.dart';

class DownloadView extends GetView<DownloadController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TDNavBar(
        title: "下载列表",
        useDefaultBack: false,
      ),
      body: Obx(() => DisplayResult(
          state: controller.getDownloadListState.value,
          onError: (error) =>
              CustomError(title: "获取下载任务失败", description: error),
          onEmpty: () => const CustomEmpty(message: "暂无下载任务"),
          onSuccess: (value) {
            return _downloadTasks(context);
          })),
    );
  }

  Widget _downloadTasks(BuildContext context) {
    return Obx(() => ListView(
          children: [
            TDCellGroup(
                cells: controller.downloadTaskList
                    .map((e) => TDCell(
                          title: e.downloadTableData.name,
                          leftIconWidget: Image.network(
                            e.downloadTableData.imageUrls.firstOrNull ?? "",
                            height: 100,
                            width: 100,
                          ),
                          descriptionWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TDText(
                                  font: Font(size: 12, lineHeight: 24),
                                  style: const TextStyle(color: Colors.grey),
                                  "成功：${e.success}  失败：${e.fail}  总进度：${e.success + e.fail}/${e.downloadTableData.imageUrls.length}"),
                              LinearProgressIndicator(
                                color: TDTheme.of(context).brandNormalColor,
                                backgroundColor:TDTheme.of(context).brandColor1 ,
                                value: ((e.success + e.fail) /
                                    e.downloadTableData.imageUrls.length),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        controller.deleteDownload(
                                            e.downloadTableData);
                                      },
                                      icon: Icon(TDIcons.delete,color: TDTheme.of(context).brandClickColor,))
                                ],
                              )
                            ],
                          ),
                        ))
                    .toList())
          ],
        ));
  }
}
