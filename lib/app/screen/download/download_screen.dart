import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/download/download_controller.dart';
import 'package:tele_book/app/widget/td/td_action_sheet_item_icon_widget.dart';

class DownloadScreen extends GetView<DownloadController> {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: '下载管理',
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.edit,
            action: () {
              TDActionSheet.showGroupActionSheet(
                context,
                onSelected: (actionItem, actionIndex) {
                  if (actionIndex == 0) {
                    controller.downloadService.cancelAll();
                  }
                  if (actionIndex == 1) {
                    controller.downloadService.resumeAll();
                  }
                  if (actionIndex == 2) {
                    controller.downloadService.deleteAll();
                  }
                },
                items: [
                  TDActionSheetItem(
                    label: "取消全部",
                    icon: TDActionSheetItemIconWidget(iconData: Icons.cancel),
                    group: "操作",
                  ),
                  TDActionSheetItem(
                    label: "继续全部",
                    icon: TDActionSheetItemIconWidget(
                      iconData: Icons.play_arrow,
                      bgColor: TDTheme.of(context).successLightColor,
                      iconColor: TDTheme.of(context).successNormalColor,
                    ),
                    group: "操作",
                  ),
                  TDActionSheetItem(
                    label: "删除全部",
                    icon: TDActionSheetItemIconWidget(
                      iconData: Icons.delete,
                      bgColor: TDTheme.of(context).errorLightColor,
                      iconColor: TDTheme.of(context).errorNormalColor,
                    ),
                    group: "操作",
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.downloadService.groups.entries.isEmpty) {
          return Center(child: TDEmpty(emptyText: "暂无下载任务"));
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            final item = controller.downloadService.groups.entries.elementAt(
              index,
            );
            return Obx(
              () => TDCell(
                title: item.value.name,
                description:
                    '总数: ${item.value.totalCount.value} | 完成: ${item.value.completedCount.value} | 失败: ${item.value.failedCount.value}\n'
                    '进度: ${(item.value.groupProgress.value * 100).toStringAsFixed(1)}%',
                onClick: (TDCell cell) {
                  Get.toNamed('/download/task', arguments: item.key);
                },
                onLongPress: (TDCell cell) {
                  TDActionSheet(
                    context,
                    visible: true,
                    onSelected: (actionItem, actionIndex) {
                      if (actionIndex == 0) {
                        controller.downloadService.cancelGroup(item.key);
                      }
                      if (actionIndex == 1) {
                        // 删除下载组
                        controller.downloadService.resumeGroup(item.key);
                      }
                      if (actionIndex == 2) {
                        controller.downloadService.deleteGroup(item.key);
                      }
                      if (actionIndex == 3) {
                        controller.downloadService.retryGroup(item.key);
                      }
                      if (actionIndex == 4) {
                        controller.savaToBook(item.key);
                      }
                    },
                    items: [
                      TDActionSheetItem(label: "取消下载"),
                      TDActionSheetItem(label: "继续下载"),
                      TDActionSheetItem(label: "删除下载"),
                      TDActionSheetItem(label: "重新下载"),
                      TDActionSheetItem(label: "保存为书籍"),
                    ],
                  );
                },
              ),
            );
          },
          itemCount: controller.downloadService.groups.entries.length,
        );
      }),
    );
  }
}
