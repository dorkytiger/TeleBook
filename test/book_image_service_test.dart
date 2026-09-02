import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:tele_book/feature/book/service/book_image_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generateCover: 缩放 + JPEG 编码', () async {
    final dir = await Directory.systemTemp.createTemp('img_test');
    addTearDown(() => dir.delete(recursive: true));

    // 造一张 800x600 的测试 PNG
    final src = img.Image(width: 800, height: 600);
    img.fill(src, color: img.ColorRgb8(200, 30, 30));
    final png = img.encodePng(src);
    final srcPath = '${dir.path}/src.png';
    await File(srcPath).writeAsBytes(png);

    final destPath = '${dir.path}/cover.jpg';
    await BookImageService.generateCover(srcPath, destPath);

    final out = File(destPath);
    expect(await out.exists(), isTrue);
    expect(await out.length(), greaterThan(0));

    // 解码验证：宽度应缩到 300
    final bytes = await out.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    expect(frame.image.width, BookImageService.coverWidth);
    expect(frame.image.height, 225); // 800x600 等比 → 300x225
    frame.image.dispose();
    codec.dispose();
  });

  test('generatePreviewBatch: 批量生成', () async {
    final dir = await Directory.systemTemp.createTemp('img_batch');
    addTearDown(() => dir.delete(recursive: true));

    final src = img.Image(width: 400, height: 400);
    img.fill(src, color: img.ColorRgb8(10, 100, 200));
    final png = img.encodePng(src);
    final srcs = <String>[];
    for (var i = 0; i < 3; i++) {
      final p = '${dir.path}/s$i.png';
      await File(p).writeAsBytes(png);
      srcs.add(p);
    }

    var progress = 0;
    final destDir = '${dir.path}/preview';
    final paths = await BookImageService.generatePreviewBatch(
      srcPaths: srcs,
      destDir: destDir,
      onProgress: (c, t) => progress = c,
    );

    expect(paths.length, 3);
    expect(progress, 3);
    for (final p in paths) {
      expect(await File(p).exists(), isTrue);
    }
  });

  test('generateCover: 父目录不存在时也能写入（真实保存场景）', () async {
    final dir = await Directory.systemTemp.createTemp('img_nodir');
    addTearDown(() => dir.delete(recursive: true));

    // 源图在临时目录
    final src = img.Image(width: 100, height: 100);
    img.fill(src, color: img.ColorRgb8(1, 2, 3));
    final srcPath = '${dir.path}/src.png';
    await File(srcPath).writeAsBytes(img.encodePng(src));

    // 目标：一个完全不存在的深层目录（如 books/{bookId}/cover.jpg）
    final bookDir = '${dir.path}/not_exist_yet/books/uuid123';
    final coverPath = '$bookDir/cover.jpg';

    await BookImageService.generateCover(srcPath, coverPath);

    expect(await File(coverPath).exists(), isTrue);
    expect(await File(coverPath).length(), greaterThan(0));
  });
}
