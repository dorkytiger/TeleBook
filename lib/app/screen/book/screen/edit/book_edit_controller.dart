import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart' as drift hide Column;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';

class BookEditController extends GetxController {
  final int bookId = Get.arguments as int;
  final appDatabase = Get.find<AppDatabase>();

  late final String appDirectory;
  final bookName = TextEditingController();
  final imageList = <String>[].obs;
  final getBookState = Rx<DKStateQuery<BookTableData>>(DkStateQueryIdle());
  final addImageState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final saveState = Rx<DKStateEvent<void>>(DKStateEventIdle());

  @override
  void onInit() async {
    super.onInit();
    appDirectory = (await getApplicationDocumentsDirectory()).path;
    saveState.listenEventToast(
      onSuccess: (data) {
        final bookController = Get.find<BookController>();
        bookController.fetchBooks();
        Get.back(result: true);
      },
    );
    await loadBook();
  }

  @override
  void onClose() {
    bookName.dispose();
    super.onClose();
  }

  /// 加载书籍数据
  Future<void> loadBook() async {
    getBookState.triggerQuery(
      query: () async {
        final book =
            await (appDatabase.bookTable.select()
                  ..where((tbl) => tbl.id.equals(bookId)))
                .getSingle();

        bookName.text = book.name;
        imageList.value = List.from(book.localPaths);
        return book;
      },
    );
  }

  /// 添加图片
  Future<void> addImages() async {
    await addImageState.triggerEvent(
      event: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: true,
        );

        if (result == null || result.files.isEmpty) return;

        // 创建保存目录
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final saveDir = p.join(appDirectory, 'book_${bookId}_$timestamp');
        await Directory(saveDir).create(recursive: true);

        final newPaths = <String>[];

        for (final file in result.files) {
          if (file.path == null) continue;

          // 生成文件名
          final extension = p.extension(file.path!);
          final fileName = '${DateTime.now().microsecondsSinceEpoch}$extension';
          final savePath = p.join(saveDir, fileName);

          // 复制文件
          await File(file.path!).copy(savePath);

          // 保存相对路径
          final relativePath = p.relative(savePath, from: appDirectory);
          newPaths.add(relativePath);
        }

        imageList.addAll(newPaths);
      },
    );
  }

  /// 重命名 书籍
  Future<void> renameBook() async {
    if (bookName.text.trim().isEmpty) {
      return;
    }

    try {
      // 清理名称中的非法字符
      final sanitizedName = bookName.text.trim().replaceAll(
        RegExp(r'[<>:"/\\|?*]'),
        '_',
      );

      // 立即更新数据库中的书籍名称
      await (appDatabase.update(appDatabase.bookTable)
            ..where((tbl) => tbl.id.equals(bookId)))
          .write(BookTableCompanion(name: drift.Value(sanitizedName)));

      // 更新书籍列表
      final bookController = Get.find<BookController>();
      await bookController.fetchBooks();

      DKLog.i('书籍重命名成功: $sanitizedName');
    } catch (e) {
      DKLog.e('重命名书籍失败: $e');
    }
  }

  /// 删除图片
  Future<void> deleteImage(int index) async {
    if (imageList.length <= 1) {
      DKLog.w('至少需要保留一张图片');
      return;
    }

    try {
      // 只从列表中移除，不删除物理文件，也不更新数据库
      // 物理文件的删除和数据库更新将在保存时进行
      imageList.removeAt(index);
      DKLog.i('图片已从列表中移除，等待保存');
    } catch (e) {
      DKLog.e('删除图片失败: $e');
    }
  }

  /// 移动图片（同步方法，用于ReorderableListView）
  void reorderImages(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = imageList.removeAt(oldIndex);
    imageList.insert(newIndex, item);
    DKLog.i('图片顺序已调整，等待保存');
  }

  /// 保存修改
  Future<void> saveChanges() async {
    if (bookName.text.trim().isEmpty) {
      Get.snackbar('错误', '书籍名称不能为空');
      return;
    }

    if (imageList.isEmpty) {
      Get.snackbar('错误', '至少需要一张图片');
      return;
    }

    await saveState.triggerEvent(
      event: () async {
        // 清理名称中的非法字符
        final sanitizedName = bookName.text.trim().replaceAll(
          RegExp(r'[<>:"/\\|?*]'),
          '_',
        );

        // 更新数据库
        await (appDatabase.update(
          appDatabase.bookTable,
        )..where((tbl) => tbl.id.equals(bookId))).write(
          BookTableCompanion(
            name: drift.Value(sanitizedName),
            localPaths: drift.Value(imageList.toList()),
          ),
        );

        DKLog.i('书籍已保存: $sanitizedName');
      },
    );
  }
}
