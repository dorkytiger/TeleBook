import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:tele_book/common/widget/f_sheet_content.dart';

/// 双向同步冲突选择（§2.1.4/§7）：同 uuid 但文件不同，
/// 让用户选「保留服务器（下载覆盖本地）」或「保留本地（上传覆盖服务器）」。
/// 返回 true=保留服务器（下载），false=保留本地（上传），null=跳过。
Future<bool?> showConflictChooseSheet(
  BuildContext context, {
  required String bookName,
}) {
  return showFSheet(
    context: context,
    side: .btt,
    builder: (context) => FSheetContent(
      side: .btt,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FSheetContent.drag(),
          FSheetContent.title(context, '存在冲突'),
          FSheetContent.subTitle(
            context,
            '「$bookName」在本设备与服务器内容不一致，请选择保留哪一版：',
          ),
          const SizedBox(height: 8),
          FItem(
            title: const Text('保留服务器版本'),
            subtitle: const Text('下载服务器版本，覆盖本设备的这本书'),
            prefix: const Icon(FLucideIcons.download),
            onPress: () => Navigator.pop(context, true),
          ),
          const SizedBox(height: 4),
          FItem(
            title: const Text('保留本地版本'),
            subtitle: const Text('上传本设备版本，覆盖服务器'),
            prefix: const Icon(FLucideIcons.upload),
            onPress: () => Navigator.pop(context, false),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FButton(
              variant: .ghost,
              size: .sm,
              onPress: () => Navigator.pop(context, null),
              child: const Text('跳过'),
            ),
          ),
        ],
      ),
    ),
  );
}
