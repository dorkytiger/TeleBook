import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/parse/archive/screen/single/parse_single_archive_controller.dart';

import 'package:tele_book/app/widget/custom_image_loader.dart';

class ParseSingleArchiveScreen extends GetView<ParseSingleArchiveController> {
  const ParseSingleArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: '解析归档',
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.save,
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
      body: controller.extractArchiveState.displaySuccess(
        successBuilder: (data){
          return ListView.builder(
            itemBuilder: (context, index) {
              final archive = controller.archives[index];
              return TDCell(
                title: archive.path.split('/').last,
                description: '路径: ${archive.path}',
                leftIconWidget: CustomImageLoader(localUrl: archive.path,),
                onClick: (cell) {},
                onLongPress: (cell) {},
              );
            },
            itemCount: controller.archives.length,
          );
        }
      )
    );
  }
}
