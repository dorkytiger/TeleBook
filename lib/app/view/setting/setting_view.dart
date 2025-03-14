import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/book_page_layout_enum.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/setting/setting_controller.dart'
    show SettingController;
import 'package:tele_book/app/view/setting/view/transmit/setting_transmit_binding.dart';
import 'package:tele_book/app/view/setting/view/transmit/setting_transmit_controller.dart';
import 'package:tele_book/app/view/setting/view/transmit/setting_transmit_view.dart';
import 'package:tele_book/app/widget/custom_error.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<SettingController>(SettingController());
    return Scaffold(
      appBar: const TDNavBar(
        title: "设置",
        useDefaultBack: false,
      ),
      body: Obx(() => DisplayResult(
          state: controller.getSettingDataState,
          onError: (error) => CustomError(title: "获取设置失败", description: error),
          onSuccess: (SettingTableData value) => Column(
                children: [
                  _readSettingCellGroup(context, controller, value),
                  _transmitCellGroup(context, controller, value)
                ],
              ))),
    );
  }

  Widget _readSettingCellGroup(BuildContext context,
      SettingController controller, SettingTableData data) {
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
                  return _layoutSettingBottomSheet(context, controller, data);
                }));
          })
    ]);
  }

  Widget _transmitCellGroup(BuildContext context, SettingController controller,
      SettingTableData data) {
    return TDCellGroup(title: "传输设置", cells: [
      TDCell(
          leftIcon: TDIcons.file_import,
          title: "导入配置",
          onClick: (TDCell cell) {
            Navigator.of(context).push(TDSlidePopupRoute(
                modalBarrierColor: TDTheme.of(context).fontGyColor2,
                slideTransitionFrom: SlideTransitionFrom.bottom,
                builder: (context) {
                  return _importBottomSheet(context, controller);
                }));
          }),
      TDCell(
          leftIcon: TDIcons.file_export,
          title: "导出配置",
          onClick: (TDCell cell) {
            controller.exportBookData();
          }),
      TDCell(
          leftIcon: TDIcons.system_2,
          title: "局域网同步",
          onClick: (TDCell cell) {
            Navigator.of(context).push(TDSlidePopupRoute(
                modalBarrierColor: TDTheme.of(context).fontGyColor2,
                slideTransitionFrom: SlideTransitionFrom.bottom,
                builder: (context) {
                  return _transmitBottomSheet();
                }));
          })
    ]);
  }

  Widget _transmitBottomSheet() {
    return TDPopupBottomDisplayPanel(
        title: '局域网同步',
        child: TDCellGroup(cells: [
          TDCell(
              title: "接收数据",
              onClick: (TDCell cell) {
                Get.to(()=> SettingTransmitView(),
                    binding: SettingTransmitBinding(),
                    arguments: {"type": TransmitType.receive});
              }),
          TDCell(
              title: "发送数据",
              onClick: (TDCell cell) {
                Get.to(()=> SettingTransmitView(),
                    binding: SettingTransmitBinding(),
                    arguments: {"type": TransmitType.send});
              })
        ]));
  }

  Widget _importBottomSheet(
      BuildContext context, SettingController controller) {
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
              title: "选择文件导入",
              onClick: (TDCell cell) {
                controller.importBookData();
                Navigator.of(context).pop();
              },
            )
          ],
        )));
  }

  Widget _layoutSettingBottomSheet(BuildContext context,
      SettingController controller, SettingTableData data) {
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
