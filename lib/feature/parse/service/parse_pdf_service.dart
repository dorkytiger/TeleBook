import 'dart:io';
import 'dart:ui';

import 'package:path/path.dart' as p;
import 'package:pdf_image_renderer/pdf_image_renderer.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/util/failure_util.dart';
import 'package:tele_book/core/util/result_util.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:uuid/uuid.dart';

class ParsePdfService {
  /// 解析单个 PDF：逐页渲染为 PNG 并写入临时目录，返回临时图片路径列表
  Future<Result<List<String>>> parsePdf(
    String pdfPath, {
    void Function(int current, int total)? onProgress,
  }) async {
    final tempDir = p.join(GlobalConfig.appTempDir.path, const Uuid().v4());
    await Directory(tempDir).create(recursive: true);

    final renderer = PdfImageRenderer(path: pdfPath);
    try {
      await renderer.open();
      final pageCount = await renderer.getPageCount();
      final imagePaths = <String>[];

      for (var i = 0; i < pageCount; i++) {
        await renderer.openPage(pageIndex: i);
        final size = await renderer.getPageSize(pageIndex: i);
        final bytes = await renderer.renderPage(
          pageIndex: i,
          x: 0,
          y: 0,
          width: size.width,
          height: size.height,
          scale: 2,
          background: Color(0xFFFFFFFF),
        );
        await renderer.closePage(pageIndex: i);

        if (bytes != null && bytes.isNotEmpty) {
          final filePath = p.join(
            tempDir,
            '${i.toString().padLeft(7, '0')}.png',
          );
          await File(filePath).writeAsBytes(bytes);
          imagePaths.add(filePath);
        }

        onProgress?.call(i + 1, pageCount);
        // 每页让出事件循环，保持 UI 响应
        await Future.delayed(Duration.zero);
      }

      await renderer.close();
      return Result.success(imagePaths);
    } catch (e, st) {
      await renderer.close().catchError((_) {});
      return Result.failure(
        BusinessFailure(message: '解析 PDF 失败', details: e, stackTrace: st),
      );
    }
  }

  /// 批量解析：扫描目录中所有 PDF，逐一渲染，返回 ParseBatchArchiveVo 列表
  Future<Result<List<ParseBatchArchiveVo>>> parseBatchPdfs(
    String pdfDirPath,
    void Function(int total) onStart,
    void Function(int count) onProgress,
  ) async {
    try {
      final dir = Directory(pdfDirPath);
      if (!await dir.exists()) {
        throw FileSystemException('目录不存在', pdfDirPath);
      }

      final pdfPaths = await dir
          .list()
          .where((e) => e is File && e.path.toLowerCase().endsWith('.pdf'))
          .map((e) => e.path)
          .toList()
        ..sort();

      onStart(pdfPaths.length);

      final results = <ParseBatchArchiveVo>[];
      for (var i = 0; i < pdfPaths.length; i++) {
        await Future.delayed(Duration.zero);
        final path = pdfPaths[i];

        final result = await parsePdf(path);
        if (result.isSuccess) {
          results.add(
            ParseBatchArchiveVo(
              name: p.basenameWithoutExtension(path),
              tempPaths: result.data!,
            ),
          );
          onProgress(i + 1);
        } else {
          throw Exception(result.error?.message);
        }
      }

      return Result.success(results);
    } catch (e, st) {
      return Result.failure(
        BusinessFailure(
          message: '批量解析 PDF 失败',
          details: e,
          stackTrace: st,
        ),
      );
    }
  }
}

