import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/service/book_service.dart';
import 'package:tele_book/app/service/download_service.dart';

class DownloadController extends GetxController {
  final downloadService = Get.find<DownloadService>();
  final bookService = Get.find<BookService>();
  final appDatabase = Get.find<AppDatabase>();
  final saveToBookState = Rx<DKStateEvent>(DKStateEventIdle());

  @override
  void onInit() {
    super.onInit();
    saveToBookState.listenEvent();
  }

  Future<void> savaToBook(String groupId) async {
    await saveToBookState.triggerEvent(
      event: () async {
        final group = downloadService.groups[groupId];
        if (group == null) {
          throw Exception("未找到下载组 $groupId");
        }
        if (group.completedCount != group.totalCount) {
          throw Exception("下载未完成，无法保存到书架");
        }
        final tasks = downloadService.getTasksByGroup(groupId);
        final appDir = await getApplicationDocumentsDirectory();

        debugPrint('💾 保存到书架: ${group.name} (${tasks.length} 个文件)');

        final validSavePaths = <String>[];
        int notFoundCount = 0;

        for (final task in tasks) {
          final relativePath = task.savePath.value;
          final fullPath = '${appDir.path}/$relativePath';
          final file = File(fullPath);
          final exists = await file.exists();

          if (exists) {
            validSavePaths.add(relativePath);
          } else {
            notFoundCount++;
            debugPrint('⚠️ 文件不存在: $fullPath');
          }
        }

        debugPrint(
          '📊 有效文件: ${validSavePaths.length}/${tasks.length}，缺失: $notFoundCount',
        );

        if (validSavePaths.isEmpty) {
          throw Exception('没有找到任何有效的下载文件');
        }

        await bookService.addBook(
          BookTableCompanion.insert(
            name: group.name,
            localPaths: validSavePaths,
          ),
        );
      },
    );
  }
}
