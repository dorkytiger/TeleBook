import 'dart:math';

/// 原生 UUID v4 生成器，替代 uuid 包。
///
/// 基于 [Random.secure()] 生成 122 位随机数，按 RFC 4122 v4 格式编排：
/// 版本号固定为 4，variant 固定为 10xx。
class Uuid {
  static final Random _random = Random.secure();

  /// 生成一个 UUID v4 字符串，如 `550e8400-e29b-41d4-a716-446655440000`。
  static String v4() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    // 设置版本号 (第 6 字节高 4 位 = 4)
    bytes[6] = (bytes[6] & 0x0F) | 0x40;
    // 设置 variant (第 8 字节高 2 位 = 10)
    bytes[8] = (bytes[8] & 0x3F) | 0x80;

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
