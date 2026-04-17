import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_query_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/store/book_store.dart';
import 'package:tele_book/app/util/file_util.dart';

class BookEditController extends ChangeNotifier {
  final int bookId;
  final BookStore bookStore;

  final bookName = TextEditingController();
  List<String> imageList = <String>[];
  List<String> tempImageList = <String>[];
  DKStateQuery<BookTableData> getBookState = DkStateQueryIdle();
  DKStateEvent<void> addImageState = DKStateEventIdle();
  DKStateEvent<void> saveState = DKStateEventIdle();

  BookEditController({required this.bookId, required this.bookStore}) {
    loadBook();
  }

  /// 加载书籍数据
  Future<void> loadBook() async {
    DKStateQueryHelper.triggerQuery(
      onStateChange: (value) {
        getBookState = value;
        notifyListeners();
      },
      query: () async {
        final book = await bookStore.getBookById(bookId);
        if (book == null) {
          throw Exception('书籍未找到');
        }
        bookName.text = book.name;
        imageList = await FileUtil.getBookImageFullPaths(book.localPaths);
        return book;
      },
    );
  }

  /// 添加图片
  Future<void> addImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result == null) {
      DKLog.i('用户取消了图片选择');
      return;
    }
    // 先拷贝文件到临时路径，避免直接操作原文件
    final tempPaths = <String>[];
    for (final path in result.paths.whereType<String>()) {
      final tempPath = await FileUtil.copyFileToTempDir(path);
      tempPaths.add(tempPath);
    }
    tempImageList.addAll(tempPaths);
    imageList.addAll(tempPaths);
    DKLog.i('已添加 ${result.paths.length} 张图片，等待保存');
    notifyListeners();
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
      notifyListeners();
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
    notifyListeners();
    DKLog.i('图片顺序已调整，等待保存');
  }

  /// 保存修改
  Future<void> saveChanges(BuildContext context) async {
    if (bookName.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('书籍名称不能为空')));
      return;
    }

    if (imageList.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('至少需要保留一张图片')));
      return;
    }

    await DKStateEventHelper.triggerEvent(
      onStateChange: (value) {
        saveState = value;
        notifyListeners();
      },
      event: () async {
        // 清理名称中的非法字符
        final sanitizedName = bookName.text.trim().replaceAll(
          RegExp(r'[<>:"/\\|?*]'),
          '_',
        );

        final book = await bookStore.getBookById(bookId);
        if (book == null) {
          throw Exception('书籍未找到');
        }

        final tempLocalPaths = <String>[];
        for (final imagePath in imageList) {
          //先拷贝全部图片到临时路径，避免直接操作原文件
          final tempPath = await FileUtil.copyFileToTempDir(imagePath);
          tempLocalPaths.add(tempPath);
        }
        // 新建新的保存地址
        final localRelativePaths = <String>[];
        for (int i = 0; i < tempLocalPaths.length; i++) {
          final tempLocalPath = tempLocalPaths[i];
          final file = File(tempLocalPath);
          final saveImageResult = await FileUtil.saveBookImage(
            book.name,
            file.readAsBytesSync(),
            i,
          );
          localRelativePaths.add(saveImageResult.relativePath);
        }

        // 更新数据库记录
        await bookStore.updateBook(
          book.copyWith(name: sanitizedName, localPaths: localRelativePaths),
        );

        DKLog.i('书籍已保存: $sanitizedName');
      },
    );
  }

  Future<void> clearTempFiles() async {
    for (final tempPath in tempImageList) {
      try {
        final file = File(tempPath);
        if (await file.exists()) {
          await file.delete();
          DKLog.i('已删除临时文件: $tempPath');
        }
      } catch (e) {
        DKLog.e('删除临时文件失败: $e');
      }
    }
    tempImageList.clear();
  }

  @override
  void dispose() {
    bookName.dispose();
    clearTempFiles();
    super.dispose();
  }
}
