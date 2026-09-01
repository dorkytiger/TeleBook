import 'dart:io';

import 'package:crypto/crypto.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tele_book/feature/sync/service/file_sync_service.dart';

void main() {
  test('hashFile 计算 SHA-256（与 sha256sum 一致）', () async {
    final dir = await Directory.systemTemp.createTemp('telebook_hash_test');
    addTearDown(() => dir.delete(recursive: true));
    final f = File('${dir.path}/a.jpg');
    await f.writeAsBytes(List<int>.generate(1024 * 1024, (i) => i % 256));

    final hash = await FileSyncService.hashFile(f.path);
    expect(hash, hasLength(64));
    // 独立验证：用 dart 的 sha256 直接算同一字节流
    expect(hash, equals(_sha256Of(await f.readAsBytes())));
  });

  test('hashFile 对不存在的文件抛错', () async {
    await expectLater(
      FileSyncService.hashFile('/nonexistent/x.jpg'),
      throwsStateError,
    );
  });
}

String _sha256Of(List<int> bytes) {
  // 用 crypto 包独立计算，避免与实现共用同一代码路径
  return sha256.convert(bytes).toString();
}
