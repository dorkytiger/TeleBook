import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/export/enum/export_format.dart';

// ── 顶层函数供 compute 调用 ──────────────────────────────────

class _FolderExportArgs {
  final List<String> srcPaths;
  final String destDir;
  _FolderExportArgs({required this.srcPaths, required this.destDir});
}

Future<void> _exportToFolderIsolate(_FolderExportArgs args) async {
  final dir = Directory(args.destDir);
  await dir.create(recursive: true);
  for (var i = 0; i < args.srcPaths.length; i++) {
    final src = File(args.srcPaths[i]);
    final bytes = await src.readAsBytes();
    final ext = _guessExtension(bytes);
    final dstName = '${i.toString().padLeft(7, '0')}$ext';
    await src.copy(p.join(args.destDir, dstName));
  }
}

class _ZipExportArgs {
  final List<String> srcPaths;
  final String destFile;
  _ZipExportArgs({required this.srcPaths, required this.destFile});
}

Future<void> _exportToZipIsolate(_ZipExportArgs args) async {
  final encoder = ZipFileEncoder();
  encoder.create(args.destFile);
  for (var i = 0; i < args.srcPaths.length; i++) {
    final src = File(args.srcPaths[i]);
    final bytes = await src.readAsBytes();
    final ext = _guessExtension(bytes);
    final entryName = '${i.toString().padLeft(7, '0')}$ext';
    encoder.addFile(src, entryName);
  }
  encoder.close();
}

class _PdfExportArgs {
  final List<String> srcPaths;
  final String destFile;
  _PdfExportArgs({required this.srcPaths, required this.destFile});
}

Future<void> _exportToPdfIsolate(_PdfExportArgs args) async {
  final doc = pw.Document();
  for (final srcPath in args.srcPaths) {
    final bytes = await File(srcPath).readAsBytes();
    final image = pw.MemoryImage(bytes);
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (_) => pw.Center(
          child: pw.Image(image, fit: pw.BoxFit.contain),
        ),
      ),
    );
  }
  final pdfBytes = await doc.save();
  await File(args.destFile).writeAsBytes(pdfBytes);
}

// ── 工具函数 ────────────────────────────────────────────────

String _guessExtension(Uint8List bytes) {
  if (bytes.length >= 3 &&
      bytes[0] == 0xFF &&
      bytes[1] == 0xD8 &&
      bytes[2] == 0xFF) {
    return '.jpg';
  }
  if (bytes.length >= 4 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47) {
    return '.png';
  }
  return '.bin';
}

// ── 导出服务 ─────────────────────────────────────────────────

class ExportService {
  /// 获取书籍所有图片的绝对路径列表
  List<String> resolveImagePaths(BookTableData book) {
    return book.localSubPaths
        .map((sub) => GlobalConfig.resolveBookPath(sub))
        .toList();
  }

  /// 单本导出
  Future<void> exportSingle({
    required BookTableData book,
    required String outputDirPath,
    required String fileName,
    required ExportFormat format,
  }) async {
    final imagePaths = resolveImagePaths(book);
    await _doExport(
      imagePaths: imagePaths,
      outputDirPath: outputDirPath,
      fileName: fileName,
      format: format,
    );
  }

  /// 批量导出（逐本导出，同一格式同一目标目录）
  Future<void> exportBatch({
    required List<({BookTableData book, String fileName})> items,
    required String outputDirPath,
    required ExportFormat format,
    void Function(int current, int total)? onProgress,
  }) async {
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final imagePaths = resolveImagePaths(item.book);
      await _doExport(
        imagePaths: imagePaths,
        outputDirPath: outputDirPath,
        fileName: item.fileName,
        format: format,
      );
      onProgress?.call(i + 1, items.length);
    }
  }

  Future<void> _doExport({
    required List<String> imagePaths,
    required String outputDirPath,
    required String fileName,
    required ExportFormat format,
  }) async {
    switch (format) {
      case ExportFormat.folder:
        final destDir = p.join(outputDirPath, fileName);
        await compute(
          _exportToFolderIsolate,
          _FolderExportArgs(srcPaths: imagePaths, destDir: destDir),
        );
      case ExportFormat.zip:
        final destFile = p.join(outputDirPath, '$fileName.zip');
        await compute(
          _exportToZipIsolate,
          _ZipExportArgs(srcPaths: imagePaths, destFile: destFile),
        );
      case ExportFormat.pdf:
        final destFile = p.join(outputDirPath, '$fileName.pdf');
        await compute(
          _exportToPdfIsolate,
          _PdfExportArgs(srcPaths: imagePaths, destFile: destFile),
        );
    }
  }
}

