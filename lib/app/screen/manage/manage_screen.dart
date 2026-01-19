import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/service/download_service.dart';
import 'package:tele_book/app/widget/td/td_cell_group_title_widge.dart';
import 'manage_controller.dart';

class ManageScreen extends GetView<ManageController> {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(title: '管理', useDefaultBack: false),
      body: Column(
        children: [
          TDCellGroup(
            titleWidget: TdCellGroupTitleWidget(title: '导航'),
            theme: TDCellGroupTheme.cardTheme,
            cells: [
              TDCell(
                title: '下载列表',
                arrow: true,
                noteWidget: Obx(
                  () => DownloadService.instance.tasks.isNotEmpty
                      ? TDBadge(
                          TDBadgeType.message,
                          count: DownloadService.instance.tasks.length
                              .toString(),
                        )
                      : SizedBox.shrink(),
                ),

                onClick: (cell) {
                  Get.toNamed("/download");
                },
              ),
              TDCell(
                title: '收藏夹管理',
                arrow: true,
                onClick: (cell) {
                  Get.toNamed(AppRoute.collection);
                },
              ),
              TDCell(title: '书签管理'),
            ],
          ),
          TDCellGroup(
            titleWidget: TDText(
              '书籍管理',
              font: TDTheme.of(context).fontBodyMedium,
              textColor: TDTheme.of(context).fontGyColor3,
            ),
            theme: TDCellGroupTheme.cardTheme,
            cells: [
              TDCell(
                title: '添加书籍',
                onClick: (cell) {
                  Get.toNamed("/book/form");
                },
                arrow: true,
              ),
              TDCell(title: '导出全部书籍'),
            ],
          ),
        ],
      ),
    );
  }
}
