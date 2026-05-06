import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
}
