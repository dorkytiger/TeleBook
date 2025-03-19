import 'package:background_downloader/background_downloader.dart';
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
                cells: controller.downloadTaskMap.value.entries.map((entry) {
              final task = entry.value;
              if(task.status==TaskStatus.running){
                return  TDCell(
                  title: task.downloadTableData.name,
                  leftIconWidget: Image.network(
                    task.downloadTableData.imageUrls.firstOrNull ?? "",
                    height: 100,
                    width: 100,
                  ),
                  descriptionWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TDText(
                          font: Font(size: 12, lineHeight: 24),
                          style: const TextStyle(color: Colors.grey),
                          "总进度：${(task.totalProgress * 100).toInt()}%"),
                      LinearProgressIndicator(
                        color: TDTheme.of(context).brandNormalColor,
                        backgroundColor: TDTheme.of(context).brandColor1,
                        value: (task.totalProgress),
                      ),
                      TDText(
                          font: Font(size: 12, lineHeight: 24),
                          style: const TextStyle(color: Colors.grey),
                          "当前进度：${(task.currentProgress * 100).toInt()}%"),
                      LinearProgressIndicator(
                        color: TDTheme.of(context).brandNormalColor,
                        backgroundColor: TDTheme.of(context).brandColor1,
                        value: (task.currentProgress),
                      ),
                    ],
                  ),
                );
              }else{
                return TDCell(
                  title: task.downloadTableData.name,
                  leftIconWidget: Image.network(
                    task.downloadTableData.imageUrls.firstOrNull ?? "",
                    height: 100,
                    width: 100,
                  ),
                  description: "下载失败：${task.errorMessage}",
                  rightIconWidget: IconButton(onPressed: (){
                    //TODO
                  }, icon: const Icon(TDIcons.refresh)),
                );
              }
            }).toList())
          ],
        ));
  }
}
