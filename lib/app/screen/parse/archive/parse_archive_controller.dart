import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide Value;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/util/request_state.dart';

class ParseArchiveController extends GetxController {
  final file = Get.arguments as String;
  final extractArchiveState = Rx<RequestState<void>>(Idle());
  final saveToBookState = Rx<RequestState<void>>(Idle());
  final archives = <File>[].obs;
  final appDatabase = Get.find<AppDatabase>();

  @override
  void onInit() {
    super.onInit();
    extractArchiveState.listenWithSuccess();
    saveToBookState.listenWithSuccess(onSuccess: () {
      final bookController = Get.find<BookController>();
      bookController.fetchBooks();
      Get.offAndToNamed("/book");
    });
  }

  @override
  void onReady() {
    super.onReady();
    // 确保在帧渲染完成后再执行解压操作
    WidgetsBinding.instance.addPostFrameCallback((_) {
      extractArchive();
    });
  }

  Future<void> extractArchive() async {
    extractArchiveState.value = Loading();
    try {
      final bytes = File(file).readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);
      final tmpDir =
          '${(await getTemporaryDirectory()).path}/${DateTime.now().microsecondsSinceEpoch}';
      for (final entry in archive) {
        if (entry.isFile) {
          final fileBytes = entry.readBytes();
          debugPrint('Extracting ${entry.name}, size: ${fileBytes?.length}');
          File('$tmpDir/${entry.name}')
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileBytes!);
          archives.add(File('$tmpDir/${entry.name}'));
        }
      }
      extractArchiveState.value = Success(null);
    } catch (e) {
      extractArchiveState.value = Error(e.toString());
    }
  }

  Future<void> saveToBook() async {
    try {
      saveToBookState.value = Loading();
      final title = file.split('/').last.replaceAll('.zip', '');
      final groupPath = "$title-${DateTime.now().microsecondsSinceEpoch}";
      final saveDir =
          '${(await getApplicationDocumentsDirectory()).path}/$groupPath';

      final localPaths = <String>[];
      for (final archive in archives) {
        // 获取文件在压缩包中的相对路径（只取文件名）
        final fileName = archive.path.split('/').last;
        final savePath = '$saveDir/$fileName';

        // 确保父目录存在
        final saveFile = File(savePath);
        await saveFile.parent.create(recursive: true);

        // 复制文件
        await archive.copy(savePath);
        localPaths.add("$groupPath/$fileName");
      }

      await appDatabase.bookTable.insertOnConflictUpdate(
        BookTableCompanion(name: Value(title), localPaths: Value(localPaths)),
      );
      saveToBookState.value = Success(null);
    } catch (e) {
      debugPrint("保存书籍失败：$e");
      saveToBookState.value = Error(e.toString());
    }
  }
}
