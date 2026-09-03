import 'package:flutter_test/flutter_test.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/feature/sync/model/request/sync_request.dart';
import 'package:tele_book/feature/sync/service/match_plan.dart';

RemoteLibraryBook _book(String uuid, String name, List<String> hashes) =>
    RemoteLibraryBook(
      uuid: uuid,
      name: name,
      files: [for (final h in hashes) BookFileMeta(relPath: '$h.jpg', hash: h, size: 1)],
    );

void main() {
  test('四类匹配正确', () {
    final local = [
      // uuid-a：本地与远程 hash 一致 → same
      const LocalBookDigest(uuid: 'a', name: '书A', fileHashes: {'h1', 'h2'}),
      // uuid-b：本地与远程 hash 不一致 → conflict
      const LocalBookDigest(uuid: 'b', name: '书B', fileHashes: {'h9'}),
      // uuid-c：远程无 → upload
      const LocalBookDigest(uuid: 'c', name: '书C', fileHashes: {'h5'}),
    ];
    final remote = [
      _book('a', '书A', ['h1', 'h2']), // same
      _book('b', '书B', ['h1', 'h3']), // conflict (hash 不同)
      _book('d', '书D', ['h7']), // download
    ];

    final plan = buildMatchPlan(local, remote);
    expect(plan.skipped, 1); // a
    expect(plan.conflicts.length, 1); // b
    expect(plan.conflicts.first.uuid, 'b');
    expect(plan.toDownload.length, 1); // d
    expect(plan.toDownload.first.uuid, 'd');
    expect(plan.toUploadUuids, ['c']); // 本地 c 远程无
  });

  test('文件数量不同也算不同', () {
    final local = [const LocalBookDigest(uuid: 'x', name: '书X', fileHashes: {'h1'})];
    final remote = [_book('x', '书X', ['h1', 'h2'])];
    final plan = buildMatchPlan(local, remote);
    expect(plan.conflicts.length, 1, reason: '数量不同 → conflict');
    expect(plan.skipped, 0);
  });

  test('空两侧', () {
    expect(buildMatchPlan([], []).skipped, 0);
    expect(buildMatchPlan([], []).toDownload, isEmpty);
  });
}
