import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/book_page_layout_enum.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/setting/setting_controller.dart'
    show SettingController;
import 'package:tele_book/app/widget/custom_error.dart';

class SettingView extends StatelessWidget {
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
          onSuccess: (SettingTableData value) => TDCellGroup(cells: [
                TDCell(
                    leftIcon: TDIcons.component_layout,
                    title: "阅读布局",
                    note: value.pageLayout,
                    onClick: (TDCell cell) {
                      Navigator.of(context).push(TDSlidePopupRoute(
                          modalBarrierColor: TDTheme.of(context).fontGyColor2,
                          slideTransitionFrom: SlideTransitionFrom.bottom,
                          builder: (context) {
                            return _layoutSettingBottomSheet(
                                context, controller, value);
                          }));
                    })
              ]))),
    );
  }

  Widget _layoutSettingBottomSheet(BuildContext context,
      SettingController controller, SettingTableData data) {
    return TDPopupBottomDisplayPanel(
        title: '布局设置',
        child: TDCellGroup(cells: [
          TDCell(
            title: "翻页布局",
            leftIcon: TDIcons.page_head,
            onClick: (TDCell cell) {
              final newSettingData =
                  data.copyWith(pageLayout: BookPageLayout.page.name);
              controller.updateSettingData(newSettingData);
              Navigator.of(context).pop();
            },
          ),
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
            leftIcon: TDIcons.view_column,
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
