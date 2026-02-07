import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide Value;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/util/request_state.dart';

class ParseSingleArchiveController extends GetxController {
  final file = Get.arguments as String;
  final extractArchiveState = Rx<DKStateQuery<void>>(DkStateQueryIdle());
  final saveToBookState = Rx<DKStateEventIdle<void>>(DKStateEventIdle());
  final archives = <File>[].obs;
  final appDatabase = Get.find<AppDatabase>();

  @override
  void onInit() {
    super.onInit();
    saveToBookState.listenEvent(
      onSuccess: (_) {
        final bookController = Get.find<BookController>();
        bookController.fetchBooks();
        Get.offAndToNamed(AppRoute.book);
      },
    );
    unawaited(extractArchive());
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> extractArchive() async {
    await extractArchiveState.triggerQuery(
      query: () async {
        final bytes = await File(file).readAsBytes();
        final tmpDir = p.join(
          (await getTemporaryDirectory()).path,
          DateTime.now().microsecondsSinceEpoch.toString(),
        );

        // 在后台线程中解压 zip 文件，避免阻塞 UI
        final extractedFiles = await compute(
          _extractZipInBackground,
          _ExtractParams(bytes, tmpDir),
        );

        // 将解压后的文件路径添加到列表
        archives.addAll(extractedFiles.map((path) => File(path)));
      },
    );
  }

  // 静态方法，用于在 Isolate 中执行解压操作
  static List<String> _extractZipInBackground(_ExtractParams params) {
    final archive = ZipDecoder().decodeBytes(params.bytes);
    final extractedPaths = <String>[];

    for (final entry in archive) {
      if (entry.isFile) {
        final fileBytes = entry.readBytes();
        debugPrint('Extracting ${entry.name}, size: ${fileBytes?.length}');
        final filePath = p.join(params.tmpDir, entry.name);
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);
        extractedPaths.add(filePath);
      }
    }

    return extractedPaths;
  }

  Future<void> saveToBook() async {
    saveToBookState.triggerEvent(
      event: () async {
        final title = p.basenameWithoutExtension(file);
        final groupPath = "$title-${DateTime.now().microsecondsSinceEpoch}";
        final appDocDir = await getApplicationDocumentsDirectory();
        final saveDir = p.join(appDocDir.path, groupPath);

        final localPaths = <String>[];
        int index = 1;
        for (final archive in archives) {
          // 重命名为统一格式：00000001.jpg, 00000002.jpg, ...
          final fileName = "${index.toString().padLeft(8, '0')}.jpg";
          final savePath = p.join(saveDir, fileName);

          // 确保父目录存在
          final saveFile = File(savePath);
          await saveFile.parent.create(recursive: true);

          // 复制文件
          await archive.copy(savePath);
          localPaths.add(p.join(groupPath, fileName));
          index++;
        }

        await appDatabase.bookTable.insertOnConflictUpdate(
          BookTableCompanion(
            name: Value(title),
            localPaths: Value(localPaths),
            currentPage: Value(0),
          ),
        );
      },
    );
  }
}

// 用于传递参数到 compute 的辅助类
class _ExtractParams {
  final Uint8List bytes;
  final String tmpDir;

  _ExtractParams(this.bytes, this.tmpDir);
}
