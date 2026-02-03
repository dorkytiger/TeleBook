import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/service/download_service.dart';
import 'package:tele_book/app/util/request_state.dart';

class DownloadController extends GetxController {
  final downloadService = Get.find<DownloadService>();
  final appDatabase = Get.find<AppDatabase>();
  final saveToBookState = Rx<DKStateEvent>(DKStateEventIdle());

  @override
  void onInit() {
    super.onInit();
    saveToBookState.listenEvent(
      onSuccess: (_) {
        final bookController = Get.find<BookController>();
        bookController.fetchBooks();
      },
    );
  }

  Future<void> savaToBook(String groupId) async {
    saveToBookState.triggerEvent(
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

        await appDatabase.bookTable.insertOnConflictUpdate(
          BookTableCompanion(
            name: Value(group.name),
            localPaths: Value(validSavePaths),
          ),
        );
      },
    );
  }
}
