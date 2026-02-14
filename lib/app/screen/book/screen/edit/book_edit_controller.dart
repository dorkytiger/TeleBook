import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart' as drift hide Column;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/service/toast_service.dart';

class BookEditController extends GetxController {
  final int bookId = Get.arguments as int;
  final appDatabase = Get.find<AppDatabase>();

  late final String appDirectory;
  final bookName = TextEditingController();
  final imageList = <String>[].obs;
  final getBookState = Rx<DKStateQuery<BookTableData>>(DkStateQueryIdle());
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
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return;

      // 创建保存目录
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final saveDir = p.join(appDirectory, 'book_$bookId\_$timestamp');
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
      ToastService.showSuccess('已添加 ${newPaths.length} 张图片');
    } catch (e) {
      ToastService.showError('添加失败: $e');
    }
  }

  /// 重命名 书籍
  Future<void> renameBook() async {
    if (bookName.text.trim().isEmpty) {
      ToastService.showError('书籍名称不能为空');
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
          .write(BookTableCompanion(
        name: drift.Value(sanitizedName),
      ));

      // 更新书籍列表
      final bookController = Get.find<BookController>();
      await bookController.fetchBooks();

      ToastService.showSuccess('书籍名称已更新');
      DKLog.i('书籍重命名成功: $sanitizedName');
    } catch (e) {
      DKLog.e('重命名书籍失败: $e');
      ToastService.showError('重命名失败: $e');
    }
  }

  /// 删除图片
  Future<void> deleteImage(int index) async {
    if (imageList.length <= 1) {
      ToastService.showError('至少需要保留一张图片');
      return;
    }

    try {
      // 获取要删除的图片路径
      final imagePath = imageList[index];
      final fullPath = p.join(appDirectory, imagePath);
      final file = File(fullPath);

      // 删除物理文件
      if (await file.exists()) {
        await file.delete();
        DKLog.i('已删除物理文件: $fullPath');
      }

      // 从列表中移除
      imageList.removeAt(index);

      // 立即更新数据库
      await _updateDatabasePaths();

      ToastService.showSuccess('已删除');
    } catch (e) {
      DKLog.e('删除图片失败: $e');
      ToastService.showError('删除失败: $e');
    }
  }

  /// 更新数据库中的图片路径
  Future<void> _updateDatabasePaths() async {
    try {
      await (appDatabase.update(appDatabase.bookTable)
            ..where((tbl) => tbl.id.equals(bookId)))
          .write(BookTableCompanion(
        localPaths: drift.Value(imageList.toList()),
      ));
      DKLog.i('数据库图片路径已更新');
    } catch (e) {
      DKLog.e('更新数据库失败: $e');
    }
  }

  /// 移动图片（同步方法，用于ReorderableListView）
  void reorderImages(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = imageList.removeAt(oldIndex);
    imageList.insert(newIndex, item);

    // 异步更新数据库，不阻塞UI
    reorderImagesAsync(oldIndex, newIndex);
  }

  /// 移动图片（异步方法，用于更新数据库）
  Future<void> reorderImagesAsync(int oldIndex, int newIndex) async {
    try {
      // 更新数据库中的顺序
      await _updateDatabasePaths();
      DKLog.i('图片顺序已更新到数据库');
    } catch (e) {
      DKLog.e('更新图片顺序失败: $e');
    }
  }

  /// 保存修改
  Future<void> saveChanges() async {
    if (bookName.text.trim().isEmpty) {
      ToastService.showError('书籍名称不能为空');
      return;
    }

    if (imageList.isEmpty) {
      ToastService.showError('至少需要一张图片');
      return;
    }

    saveState.triggerEvent(
      event: () async {
        // 清理名称中的非法字符
        final sanitizedName = bookName.text.trim().replaceAll(
          RegExp(r'[<>:"/\\|?*]'),
          '_',
        );

        await appDatabase.bookTable.update().replace(
          BookTableData(
            id: bookId,
            name: sanitizedName,
            localPaths: imageList.toList(),
            readCount: 0,
            currentPage: 0,
            createdAt: DateTime.now(),
          ),
        );
      },
    );
  }
}
