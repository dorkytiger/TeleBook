import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/widget/td/td_cell_group_title_widge.dart';
import 'setting_controller.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(title: '设置', useDefaultBack: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TDCellGroup(
              titleWidget: TdCellGroupTitleWidget(title: '通用'),
              theme: TDCellGroupTheme.cardTheme,
              cells: [
                TDCell(
                  title: '书籍列表样式',
                  arrow: true,
                  onClick: (cell) {
                    TDActionSheet.showListActionSheet(
                      context,
                      onSelected: (item, index) {
                        index == 0
                            ? controller.setBookLayout(BookLayoutSetting.list)
                            : controller.setBookLayout(BookLayoutSetting.grid);
                      },
                      items: [
                        TDActionSheetItem(label: '列表视图'),
                        TDActionSheetItem(label: '网格视图'),
                      ],
                    );
                  },
                ),
                TDCell(title: '通知设置'),
                TDCell(title: '隐私政策'),
                TDCell(title: '关于我们'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
