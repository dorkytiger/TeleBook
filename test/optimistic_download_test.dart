import 'package:flutter_test/flutter_test.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/feature/sync/model/request/sync_request.dart';
import 'package:tele_book/feature/sync/service/optimistic_download_service.dart';

void main() {
  test('deriveSubPaths：cover→coverSubPath，original→localSubPaths', () {
    final book = RemoteLibraryBook(
      uuid: 'u1',
      name: '书A',
      files: const [
        BookFileMeta(relPath: 'cover.jpg', hash: 'h1', size: 1),
        BookFileMeta(relPath: 'original/0000000', hash: 'h2', size: 1),
        BookFileMeta(relPath: 'original/0000001', hash: 'h3', size: 1),
      ],
    );
    final (local, cover) = deriveSubPaths(book);
    expect(cover, 'u1/cover.jpg');
    expect(local, ['u1/original/0000000', 'u1/original/0000001']);
  });

  test('deriveSubPaths：无 cover 无 original → 空', () {
    final book = RemoteLibraryBook(
      uuid: 'u2',
      name: '书B',
      files: const [BookFileMeta(relPath: 'other/x.jpg', hash: 'h1', size: 1)],
    );
    final (local, cover) = deriveSubPaths(book);
    expect(cover, isNull);
    expect(local, isEmpty);
  });
}
