import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/util/request_state.dart';

class BookEditController extends GetxController {
  final int bookId = Get.arguments as int;
  final appDatabase = Get.find<AppDatabase>();

  late final String appDirectory;
  final bookName = TextEditingController();
  final imageList = <String>[].obs;
  final getBookState = Rx<RequestState<BookTableData>>(Idle());
  final saveState = Rx<RequestState<void>>(Idle());

  @override
  void onInit() async {
    super.onInit();
    appDirectory = (await getApplicationDocumentsDirectory()).path;
    saveState.listenWithSuccess(
      onSuccess: () {
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
    getBookState.value.handleFunction(
      function: () async {
        final book =
            await (appDatabase.bookTable.select()
                  ..where((tbl) => tbl.id.equals(bookId)))
                .getSingle();

        bookName.text = book.name;
        imageList.value = List.from(book.localPaths);
        return book;
      },
      onStateChanged: (newState) {
        getBookState.value = newState;
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

  /// 删除图片
  void deleteImage(int index) {
    if (imageList.length <= 1) {
      ToastService.showError('至少需要保留一张图片');
      return;
    }
    imageList.removeAt(index);
    ToastService.showSuccess('已删除');
  }

  /// 移动图片
  void reorderImages(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = imageList.removeAt(oldIndex);
    imageList.insert(newIndex, item);
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

    saveState.value.handleFunction(
      function: () async {
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
            createdAt: DateTime.now(),
          ),
        );
      },
      onStateChanged: (newState) {
        saveState.value = newState;
      },
    );
  }
}
