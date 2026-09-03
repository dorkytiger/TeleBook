import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// 书籍图片处理服务：生成封面缩略图和预览图。
///
/// 不依赖 flutter_image_compress（其 Android 实现触发 Kotlin Gradle Plugin
/// 警告）：解码 + 缩放走 dart:ui 原生（instantiateImageCodec 支持目标尺寸，
/// 原生解码高效省内存），仅 JPEG 编码用纯 Dart 的 image 包。
class BookImageService {
  /// 封面缩略图宽度
  static const int coverWidth = 300;

  /// 预览图宽度
  static const int previewWidth = 1080;

  /// JPEG 压缩质量 (0-100)
  static const int jpegQuality = 80;

  /// 解码并缩放到目标宽度（等比），返回 RGBA 字节 + 尺寸。
  ///
  /// 用 dart:ui 原生编解码：支持 JPEG/PNG/WebP/GIF 等常见格式，
  /// 且 targetWidth 让解码阶段直接降采样，内存占用远小于先全尺寸解码。
  /// 解码是 engine 异步（不占主 isolate 计算），后续 [encodeJpegToFile]
  /// 的 JPEG 编码才真正吃 CPU → 放 compute isolate，UI 不卡。
  static Future<(Uint8List rgba, int width, int height)> _decodeScaled(
    String srcPath,
    int targetWidth,
  ) async {
    final bytes = await File(srcPath).readAsBytes();
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: targetWidth,
    );
    final frame = await codec.getNextFrame();
    final image = frame.image;
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (data == null) {
        throw Exception('图片像素读取失败: $srcPath');
      }
      return (
        data.buffer.asUint8List(),
        image.width,
        image.height,
      );
    } finally {
      image.dispose();
      codec.dispose();
    }
  }

  /// RGBA 像素 → JPEG 写入目标路径（在后台 isolate 执行编码，不卡 UI）。
  /// ⚠️ 先确保父目录存在（缺失会抛 PathNotFoundException）。
  static Future<void> encodeJpegToFile(
    Uint8List rgba,
    int width,
    int height,
    String destPath, {
    int quality = jpegQuality,
  }) {
    return compute(
      _encodeJpegIsolate,
      (rgba: rgba, width: width, height: height, quality: quality, dest: destPath),
    );
  }

  /// 从原图生成封面缩略图
  /// [srcPath] 原图绝对路径
  /// [destPath] 封面输出绝对路径 (如 books/{bookId}/cover.jpg)
  static Future<void> generateCover(String srcPath, String destPath) async {
    final (rgba, w, h) = await _decodeScaled(srcPath, coverWidth);
    await encodeJpegToFile(rgba, w, h, destPath);
  }

  /// 从原图生成单张预览图
  /// [srcPath] 原图绝对路径
  /// [destPath] 预览图输出绝对路径
  static Future<void> generatePreview(String srcPath, String destPath) async {
    final (rgba, w, h) = await _decodeScaled(srcPath, previewWidth);
    await encodeJpegToFile(rgba, w, h, destPath);
  }

  /// 批量生成预览图
  /// [srcPaths] 原图绝对路径列表
  /// [destDir] 预览图输出目录
  /// [onProgress] 逐张完成回调 (current, total)
  static Future<List<String>> generatePreviewBatch({
    required List<String> srcPaths,
    required String destDir,
    void Function(int current, int total)? onProgress,
  }) async {
    await Directory(destDir).create(recursive: true);
    final previewPaths = <String>[];
    for (var i = 0; i < srcPaths.length; i++) {
      final fileName = '${i.toString().padLeft(7, '0')}.jpg';
      final destPath = '$destDir/$fileName';
      await generatePreview(srcPaths[i], destPath);
      previewPaths.add(destPath);
      onProgress?.call(i + 1, srcPaths.length);
    }
    return previewPaths;
  }

  /// 在 Isolate 中批量复制原图
  static Future<List<String>> copyOriginals(
    List<String> srcPaths,
    String destDir,
    String bookId,
  ) async {
    return compute(_copyOriginalsIsolate, (srcPaths, destDir, bookId));
  }
}

Future<List<String>> _copyOriginalsIsolate(
  (List<String> srcPaths, String destDir, String bookId) args,
) async {
  final (srcPaths, destDir, bookId) = args;
  await Directory(destDir).create(recursive: true);
  final relPaths = <String>[];
  for (var i = 0; i < srcPaths.length; i++) {
    final src = File(srcPaths[i]);
    if (!await src.exists()) {
      throw FileSystemException('source file not found', srcPaths[i]);
    }
    final fileName = i.toString().padLeft(7, '0');
    await src.copy('$destDir/$fileName');
    relPaths.add('$bookId/original/$fileName');
  }
  return relPaths;
}

/// RGBA → JPEG 编码并写盘（compute isolate 执行，避免编码卡 UI）。
Future<void> _encodeJpegIsolate(
  ({
    Uint8List rgba,
    int width,
    int height,
    int quality,
    String dest,
  }) args,
) async {
  final decoded = img.Image.fromBytes(
    width: args.width,
    height: args.height,
    bytes: args.rgba.buffer,
    order: img.ChannelOrder.rgba,
  );
  final jpeg = img.encodeJpg(decoded, quality: args.quality);
  final dest = File(args.dest);
  await dest.parent.create(recursive: true);
  await dest.writeAsBytes(jpeg, flush: true);
}
