import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class FileUtil {
  FileUtil._();

  static final FileUtil instance = FileUtil._();

  static final Uuid _uuid = Uuid();
  static final String allSaveDir = 'books';

  static late String _appDocDir;
  static late String _tempDir;

  /// 必须在 main() 中调用一次
  static Future<void> init() async {
    _appDocDir = (await getApplicationDocumentsDirectory()).path;
    _tempDir = (await getTemporaryDirectory()).path;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 文件名处理
  // ═══════════════════════════════════════════════════════════════════════════

  /// 清理文件名中的非法字符
  static String sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }

  /// 处理页码，确保能按顺序保存（补齐到4位）
  /// 用于下载文件命名：0001, 0010, 0100, 1000
  static String formatPageNumber(int pageNumber) {
    return pageNumber.toString().padLeft(4, '0');
  }

  /// 格式化导出文件序号（补齐到8位）
  /// 用于导出 ZIP 文件内的图片：00000001, 00000010, 00000100
  static String formatExportIndex(int index) {
    return index.toString().padLeft(8, '0');
  }

  /// 生成唯一的文件名（带时间戳和UUID）
  static String generateUniqueFileName(String baseName, String extension) {
    final sanitized = sanitizeFileName(baseName);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uuid = _uuid.v4().substring(0, 8);
    return '${sanitized}_${timestamp}_$uuid$extension';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 路径相关
  // ═══════════════════════════════════════════════════════════════════════════

  /// 获取应用文档目录的绝对路径
  static String getAppDocumentsPath() => _appDocDir;

  /// 获取应用临时目录的绝对路径
  static String getAppTempPath() => _tempDir;

  /// 将相对路径转换为完整路径
  static String getFullPath(String relativePath) => '$_appDocDir/$relativePath';

  /// 从绝对路径中提取相对路径（相对于应用文档目录）
  static String getRelativePath(String fullPath) =>
      fullPath.replaceFirst('$_appDocDir/', '');

  // ═══════════════════════════════════════════════════════════════════════════
  // 文件存在性检查
  // ═══════════════════════════════════════════════════════════════════════════

  /// 检查文件是否存在（相对路径）
  static Future<bool> fileExistsRelative(String relativePath) async {
    final fullPath = await getFullPath(relativePath);
    return File(fullPath).exists();
  }

  /// 检查文件是否存在（绝对路径）
  static Future<bool> fileExistsAbsolute(String fullPath) async {
    return File(fullPath).exists();
  }

  /// 验证多个文件是否存在，返回 (有效路径列表, 缺失文件数量)
  static Future<(List<String>, int)> validateFiles(
    List<String> relativePaths,
  ) async {
    final validPaths = <String>[];
    int notFoundCount = 0;

    for (final relativePath in relativePaths) {
      final fullPath = '$_appDocDir/$relativePath';
      if (await File(fullPath).exists()) {
        validPaths.add(relativePath);
      } else {
        notFoundCount++;
      }
    }

    return (validPaths, notFoundCount);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 文件复制和移动
  // ═══════════════════════════════════════════════════════════════════════════

  /// 复制文件到指定目录，返回相对路径
  /// [sourceFile] 源文件
  /// [destDir] 目标目录（相对于应用文档目录）
  /// [newFileName] 可选的新文件名，不提供则使用原文件名
  static Future<String> copyFileToDir(
    File sourceFile,
    String destDir, {
    String? newFileName,
  }) async {
    final destDirectory = Directory('$_appDocDir/$destDir');
    if (!await destDirectory.exists()) {
      await destDirectory.create(recursive: true);
    }
    final fileName = newFileName ?? p.basename(sourceFile.path);
    final destPath = '${destDirectory.path}/$fileName';
    await sourceFile.copy(destPath);
    return '$destDir/$fileName';
  }

  /// 将文件复制到临时目录，返回完整路径
  static Future<String> copyFileToTempDir(String sourcePath) async {
    final fileName = p.basename(sourcePath);
    final destPath = '$_tempDir/${fileName}_${_uuid.v4()}';
    await File(sourcePath).copy(destPath);
    return destPath;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 文件读写
  // ═══════════════════════════════════════════════════════════════════════════

  /// 读取文件内容（相对路径）
  static Future<List<int>> readFileBytes(String relativePath) {
    return File('$_appDocDir/$relativePath').readAsBytes();
  }

  /// 写入文件内容（相对路径），返回相对路径
  static Future<String> writeFileBytes(
    String relativePath,
    List<int> bytes,
  ) async {
    final file = File('$_appDocDir/$relativePath');
    final dir = file.parent;
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    await file.writeAsBytes(bytes);
    return relativePath;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 书籍业务
  // ═══════════════════════════════════════════════════════════════════════════

  /// 保存书籍图片（用于下载）
  /// 返回 SavedImageResult 包含相对路径和完整路径
  static Future<SavedImageResult> saveBookImage(
    String bookTitle,
    List<int> data,
    int pageNumber,
  ) async {
    final safeTitle = "${sanitizeFileName(bookTitle)}${_uuid.v4()}";
    final handledPageNumber = formatPageNumber(pageNumber);
    final relativePath = '$allSaveDir/$safeTitle/$handledPageNumber.jpg';
    final saveDir = '$_appDocDir/$allSaveDir/$safeTitle';

    if (!await Directory(saveDir).exists()) {
      await Directory(saveDir).create(recursive: true);
    }

    final file = File('$_appDocDir/$relativePath');
    await file.writeAsBytes(data);
    return SavedImageResult(relativePath: relativePath, fullPath: file.path);
  }

  static String getBookImageFullPath(String relativePath) =>
      getFullPath(relativePath);

  static List<String> getBookImageFullPaths(List<String> relativePaths) =>
      relativePaths.map(getFullPath).toList();

  // ═══════════════════════════════════════════════════════════════════════════
  // 文件删除
  // ═══════════════════════════════════════════════════════════════════════════

  /// 删除文件（相对路径）
  static Future<void> deleteFile(String relativePath) async {
    final file = File('$_appDocDir/$relativePath');
    if (await file.exists()) await file.delete();
  }

  /// 删除目录及其内容（相对路径）
  static Future<void> deleteDirectory(String relativePath) async {
    final dir = Directory('$_appDocDir/$relativePath');
    if (await dir.exists()) await dir.delete(recursive: true);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 重命名文件（导出时避免冲突）
  // ═══════════════════════════════════════════════════════════════════════════

  /// 在指定目录中生成不冲突的文件名
  /// 如果文件存在，会自动添加后缀 (1), (2) 等
  static Future<String> generateNonConflictingPath(
    String directory,
    String baseFileName,
  ) async {
    String fileName = baseFileName;
    String fullPath = p.join(directory, fileName);
    int suffix = 1;

    while (await File(fullPath).exists()) {
      final ext = p.extension(baseFileName);
      final nameWithoutExt = p.basenameWithoutExtension(baseFileName);
      fileName = '$nameWithoutExt($suffix)$ext';
      fullPath = p.join(directory, fileName);
      suffix++;
    }

    return fullPath;
  }

}

/// 保存图片结果（包含相对路径和完整路径）
class SavedImageResult {
  final String relativePath;
  final String fullPath;

  SavedImageResult({required this.relativePath, required this.fullPath});
}
