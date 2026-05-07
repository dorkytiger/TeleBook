import 'package:flutter/material.dart';
import 'package:tele_book/core/db/app_database.dart';

/// 单个导出项（书籍 + 用户可自定义的导出文件名）
class ExportItem {
  final BookTableData book;
  final TextEditingController nameController;
  final String coverPath;

  ExportItem({required this.book, required this.coverPath})
    : nameController = TextEditingController(text: book.name);

  void dispose() => nameController.dispose();
}
