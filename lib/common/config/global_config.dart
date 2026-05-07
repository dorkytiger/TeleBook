import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// 顶层函数供 compute() 在后台 Isolate 中调用
Future<void> _cleanDirsInBackground(List<String> dirPaths) async {
  for (final dirPath in dirPaths) {
    final dir = Directory(dirPath);
    if (!await dir.exists()) continue;
    try {
      // 只删目录内的子项，保留目录本身
      await for (final entity in dir.list()) {
        try {
          if (entity is Directory) {
            await entity.delete(recursive: true);
          } else {
            await entity.delete();
          }
        } catch (_) {}
      }
    } catch (_) {}
  }
}

class GlobalConfig {
  static Directory? _appDocDir;
  static Directory? _appTempDir;

  static Directory get appDocDir => _appDocDir!;
  static Directory get appTempDir => _appTempDir!;

  /// 书籍存储目录（appDocDir/books），存书籍图片
  static Directory get booksDir => Directory(p.join(_appDocDir!.path, 'books'));

  /// 下载缓存目录（tempDir/downloads），存临时下载文件
  static Directory get downloadCacheDir =>
      Directory(p.join(_appTempDir!.path, 'downloads'));

  /// 把相对子路径（bookId/0000000）解析为完整绝对路径
  static String resolveBookPath(String relPath) =>
      p.join(booksDir.path, relPath);

  static Future<void> init() async {
    _appDocDir = await getApplicationDocumentsDirectory();
    _appTempDir = await getTemporaryDirectory();
    // 确保这两个目录存在
    await booksDir.create(recursive: true);
    await downloadCacheDir.create(recursive: true);
  }

  /// 启动时清理缓存目录（后台执行，不阻塞启动）。
  /// 清理范围：appTempDir（临时解压残留）、downloadCacheDir（中断的下载缓存）
  static void cleanCacheOnStartup() {
    compute(_cleanDirsInBackground, [
      _appTempDir!.path,
      downloadCacheDir.path,
    ]).catchError((e) {
      debugPrint('[GlobalConfig] 缓存清理失败: $e');
    });
  }
}
