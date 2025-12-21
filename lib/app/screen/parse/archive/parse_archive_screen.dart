import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/parse/archive/parse_archive_controller.dart';

class ParseArchiveScreen extends GetView<ParseArchiveController> {
  const ParseArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: '解析归档',
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.edit,
            action: () {
              TDActionSheet(
                context,
                visible: true,
                onSelected: (actionItem, actionIndex) {
                  if (actionIndex == 0) {
                    controller.saveToBook();
                  }
                },
                items: [
                  TDActionSheetItem(
                    label: '添加到书库',
                  ),
                ],
              ).show();
            },
          ),
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          itemBuilder: (context, index) {
            final archive = controller.archives[index];
            return TDCell(
              title: archive.path.split('/').last,
              description: '路径: ${archive.path}',
              leftIconWidget: SizedBox(
                height: 100,
                width: 80,
                child: Image.file(archive),
              ),
              onClick: (cell) {},
              onLongPress: (cell) {},
            );
          },
          itemCount: controller.archives.length,
        );
      }),
    );
  }
}
