import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:tele_book/feature/parse/service/parse_archive_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory rootDir;
  late ParseArchiveService service;

  setUp(() async {
    service = ParseArchiveService();
    rootDir = await Directory.systemTemp.createTemp('tele_book_batch_parse_test_');
  });

  tearDown(() async {
    if (await rootDir.exists()) {
      await rootDir.delete(recursive: true);
    }
  });

  Future<void> createImageFile(String filePath) async {
    final file = File(filePath);
    await file.parent.create(recursive: true);
    await file.writeAsString('fake-image');
  }

  test('parseBatchImageFolders traverses all descendant folders and only keeps folders with more than one direct image', () async {
    await createImageFile(p.join(rootDir.path, 'book_a', '001.jpg'));
    await createImageFile(p.join(rootDir.path, 'book_a', '002.png'));
    await createImageFile(p.join(rootDir.path, 'book_b', '001.jpg'));
    await createImageFile(p.join(rootDir.path, 'outer', 'cover.jpg'));
    await createImageFile(p.join(rootDir.path, 'outer', 'book_c', '001.jpg'));
    await createImageFile(p.join(rootDir.path, 'outer', 'book_c', '002.jpg'));

    var startedTotal = -1;
    var progressedCount = -1;

    final result = await service.parseBatchImageFolders(
      rootDir.path,
      (total) => startedTotal = total,
      (count) => progressedCount = count,
    );

    expect(result.isSuccess, isTrue);
    final books = result.data!;

    expect(startedTotal, 4);
    expect(progressedCount, 4);
    expect(books.map((e) => e.name).toList(), ['book_a', 'book_c']);
    expect(books.first.tempPaths.length, 2);
    expect(books.last.tempPaths.length, 2);
  });

  test('parseBatchImageFoldersFromPaths keeps only folders with more than one selected image', () async {
    final bookA1 = p.join(rootDir.path, 'book_a', '001.jpg');
    final bookA2 = p.join(rootDir.path, 'book_a', '002.jpg');
    final bookB1 = p.join(rootDir.path, 'book_b', '001.jpg');
    final bookC1 = p.join(rootDir.path, 'nested', 'book_c', '001.jpg');
    final bookC2 = p.join(rootDir.path, 'nested', 'book_c', '002.jpg');

    await createImageFile(bookA1);
    await createImageFile(bookA2);
    await createImageFile(bookB1);
    await createImageFile(bookC1);
    await createImageFile(bookC2);

    var startedTotal = -1;
    var progressedCount = -1;

    final result = await service.parseBatchImageFoldersFromPaths(
      [bookA2, bookC1, bookB1, bookA1, bookC2],
      (total) => startedTotal = total,
      (count) => progressedCount = count,
    );

    expect(result.isSuccess, isTrue);
    final books = result.data!;

    expect(startedTotal, 3);
    expect(progressedCount, 3);
    expect(books.map((e) => e.name).toList(), ['book_a', 'book_c']);
    expect(books.first.tempPaths, [bookA1, bookA2]);
    expect(books.last.tempPaths, [bookC1, bookC2]);
  });
}

