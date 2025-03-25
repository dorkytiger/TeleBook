import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/book_page_layout_enum.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/setting/setting_controller.dart'
    show SettingController;
import 'package:tele_book/app/view/setting/view/download/setting_download_binding.dart';
import 'package:tele_book/app/view/setting/view/download/setting_download_view.dart';
import 'package:tele_book/app/view/setting/view/export/setting_export_binding.dart';
import 'package:tele_book/app/view/setting/view/export/setting_export_view.dart';
import 'package:tele_book/app/view/setting/view/host/setting_host_binding.dart';
import 'package:tele_book/app/view/setting/view/host/setting_host_view.dart';
import 'package:tele_book/app/view/setting/view/import/setting_import_binding.dart';
import 'package:tele_book/app/view/setting/view/import/setting_import_view.dart';
import 'package:tele_book/app/view/setting/view/server/setting_server_binding.dart';
import 'package:tele_book/app/view/setting/view/server/setting_server_view.dart';
import 'package:tele_book/app/view/setting/view/upload/setting_upload_binding.dart';
import 'package:tele_book/app/view/setting/view/upload/setting_upload_view.dart';
import 'package:tele_book/app/widget/custom_error.dart';

class SettingView extends GetView<SettingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TDNavBar(
        title: "设置",
        useDefaultBack: false,
      ),
      body: Obx(() => DisplayResult(
          state: controller.getSettingDataState,
          onError: (error) => CustomError(title: "获取设置失败", description: error),
          onSuccess: (SettingTableData value) => ListView(
                children: [
                  _readSettingCellGroup(context, value),
                  _transmitCellGroup(context, value),
                  _sshSettingCellGroup(context, value),
                  _serverSettingCellGroup(context,value)
                ],
              ))),
    );
  }

  Widget _readSettingCellGroup(BuildContext context, SettingTableData data) {
    return TDCellGroup(title: "阅读设置", cells: [
      TDCell(
          leftIcon: TDIcons.component_layout,
          title: "阅读布局",
          note: data.pageLayout == "row" ? "横向布局" : "纵向布局",
          onClick: (TDCell cell) {
            Navigator.of(context).push(TDSlidePopupRoute(
                modalBarrierColor: TDTheme.of(context).fontGyColor2,
                slideTransitionFrom: SlideTransitionFrom.bottom,
                builder: (context) {
                  return _layoutSettingBottomSheet(context, data);
                }));
          })
    ]);
  }

  Widget _transmitCellGroup(BuildContext context, SettingTableData data) {
    return TDCellGroup(title: "传输设置", cells: [
      TDCell(
          leftIcon: TDIcons.file_import,
          title: "导入配置",
          onClick: (TDCell cell) {
            Navigator.of(context).push(TDSlidePopupRoute(
                modalBarrierColor: TDTheme.of(context).fontGyColor2,
                slideTransitionFrom: SlideTransitionFrom.bottom,
                builder: (context) {
                  return _importBottomSheet(
                      context, controller.importBookData, "选择文件导入");
                }));
          }),
      TDCell(
          leftIcon: TDIcons.file_export,
          title: "导出配置",
          onClick: (TDCell cell) {
            controller.exportBookData();
          })
    ]);
  }

  Widget _sshSettingCellGroup(BuildContext context, SettingTableData data) {
    return Obx(() => TDCellGroup(title: "远程设置", cells: [
          TDCell(
              leftIcon: TDIcons.terminal,
              title: "远程主机设置",
              arrow: true,
              onClick: (TDCell cell) {
                Get.to(() => const SettingHostView(),
                    binding: SettingHostBinding());
              }),
          TDCell(
              leftIcon: TDIcons.file_import,
              title: "从远程主机导入配置",
              rightIconWidget: controller.importHostBookDataState.isLoading()
                  ? const TDLoading(size: TDLoadingSize.small)
                  : null,
              disabled: controller.importHostBookDataState.isLoading(),
              onClick: (TDCell cell) {
                Navigator.of(context).push(TDSlidePopupRoute(
                    modalBarrierColor: TDTheme.of(context).fontGyColor2,
                    slideTransitionFrom: SlideTransitionFrom.bottom,
                    builder: (context) {
                      return _importBottomSheet(
                          context, controller.importHostBookData, "从远程主机导入");
                    }));
              }),
          TDCell(
              leftIcon: TDIcons.file_export,
              title: "导出配置到远程主机",
              rightIconWidget: controller.exportHostBookDataState.isLoading()
                  ? const TDLoading(size: TDLoadingSize.small)
                  : null,
              disabled: controller.exportHostBookDataState.isLoading(),
              onClick: (TDCell cell) {
                controller.exportHostBookData();
              }),
          TDCell(
              leftIcon: TDIcons.image_1,
              title: "从远程主机导入图片",
              onClick: (TDCell cell) {
                Get.to(() => const SettingImportView(),
                    binding: SettingImportBinding());
              }),
          TDCell(
              leftIcon: TDIcons.image_1_filled,
              title: "导出图片到远程主机",
              onClick: (TDCell cell) {
                Get.to(() => const SettingExportView(),
                    binding: SettingExportBinding());
              }),
        ]));
  }

  Widget _serverSettingCellGroup(BuildContext context, SettingTableData data) {
    return TDCellGroup(title: "服务器设置", cells: [
      TDCell(
          leftIcon: TDIcons.terminal,
          title: "服务器设置",
          arrow: true,
          onClick: (TDCell cell) {
            Get.to(() =>  SettingServerView(),
                binding: SettingServerBinding());
          }),
      TDCell(
          leftIcon: TDIcons.cloud_download,
          title: "从服务器下载",
          onClick: (TDCell cell) {
            Get.to(() => const SettingDownloadView(),
                binding: SettingDownloadBinding());
          }),
      TDCell(
          leftIcon: TDIcons.cloud_upload,
          title: "上传到服务器",
          onClick: (TDCell cell) {
            Get.to(() => const SettingUploadView(),
                binding: SettingUploadBinding());
          }),
    ]);
  }

  Widget _importBottomSheet(
      BuildContext context, Function import, String importText) {
    return Obx(() => TDPopupBottomDisplayPanel(
        title: '导入配置',
        child: TDCellGroup(
          cells: [
            TDCell(
              title: "跳过重复链接",
              rightIconWidget: TDSwitch(
                isOn: controller.skipDuplicate,
                onChanged: (value) {
                  final newSkipDuplicate = !controller.skipDuplicate;
                  controller.onSkipDuplicatesChanged(newSkipDuplicate);
                  return !newSkipDuplicate;
                },
              ),
            ),
            TDCell(
              title: importText,
              onClick: (TDCell cell) {
                import();
                Navigator.of(context).pop();
              },
            )
          ],
        )));
  }

  Widget _layoutSettingBottomSheet(
      BuildContext context, SettingTableData data) {
    return TDPopupBottomDisplayPanel(
        title: '布局设置',
        child: TDCellGroup(cells: [
          TDCell(
            title: "横向布局",
            leftIcon: TDIcons.horizontal,
            onClick: (TDCell cell) {
              final newSettingData =
                  data.copyWith(pageLayout: BookPageLayout.row.name);
              controller.updateSettingData(newSettingData);
              Navigator.of(context).pop();
            },
          ),
          TDCell(
            title: "纵向布局",
            leftIcon: TDIcons.vertical,
            onClick: (TDCell cell) {
              final newSettingData =
                  data.copyWith(pageLayout: BookPageLayout.column.name);
              controller.updateSettingData(newSettingData);
              Navigator.of(context).pop();
            },
          ),
        ]));
  }
}
