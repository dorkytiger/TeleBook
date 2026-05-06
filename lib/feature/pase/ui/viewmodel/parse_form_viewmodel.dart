import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/route/app_route.dart';

class ParseFormViewmodel extends ChangeNotifier {
  ParseFormType type = ParseFormType.web;
  final TextEditingController urlController = TextEditingController();
  final TextEditingController archivePathController = TextEditingController();

  void setType(ParseFormType? newType) {
    if (newType != null) {
      type = newType;
      notifyListeners();
    }
  }

  void onParse(BuildContext context) {
    switch (type) {
      case ParseFormType.web:
        context.push(AppRoute.parseWeb, extra: urlController.text);
        break;
      case ParseFormType.archive:
        context.push(
          AppRoute.parseArchiveSingle,
          extra: archivePathController.text,
        );
        break;
      default:
        break;
    }
  }

  Future<void> getClipboardUrl() async {
    final clipboardData = await Clipboard.getData('text/plain');
    final text = clipboardData?.text ?? '';
    if (Uri.tryParse(text)?.hasAbsolutePath == true) {
      urlController.text = text;
      notifyListeners();
    }
  }

  Future<void> pickerArchive(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "选择 TeleBook 导出的书籍归档文件",
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      archivePathController.text = path;
      notifyListeners();
    }
  }
}

enum ParseFormType { web, archive, batchArchive }
