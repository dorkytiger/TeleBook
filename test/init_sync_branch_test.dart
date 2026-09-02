import 'package:flutter_test/flutter_test.dart';
import 'package:tele_book/feature/sync/service/init_sync_service.dart';

void main() {
  test('分支检测：四种情况正确', () {
    expect(detectBranch(0, 0), InitSyncBranch.bothEmpty);
    expect(detectBranch(0, 5), InitSyncBranch.downloadOnly);
    expect(detectBranch(3, 0), InitSyncBranch.uploadOnly);
    expect(detectBranch(3, 5), InitSyncBranch.bidirectional);
  });
}
