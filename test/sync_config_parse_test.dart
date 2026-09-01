import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

// 复制自 sync_server_view 的解析逻辑（静态方法，直接内联验证行为）
final List<int> _xorKey = sha256.convert(utf8.encode('telebook-sync-config-v1')).bytes;

String _obfuscate(String plain) {
  final data = utf8.encode(plain);
  final out = List<int>.generate(data.length, (i) => data[i] ^ _xorKey[i % _xorKey.length]);
  return base64Encode(out);
}

String _deobfuscate(String encoded) {
  final data = base64Decode(encoded);
  final out = List<int>.generate(data.length, (i) => data[i] ^ _xorKey[i % _xorKey.length]);
  return utf8.decode(out);
}

String? _validateUrl(String? raw) {
  if (raw == null) return null;
  final s = raw.trim();
  if (s.isEmpty) return null;
  final uri = Uri.tryParse(s);
  if (uri == null) return null;
  final scheme = uri.scheme.toLowerCase();
  if (scheme != 'http' && scheme != 'https') return null;
  if (uri.host.isEmpty) return null;
  return s;
}

(String?, String?) parseConfig(String text) {
  String? url;
  String? key;
  for (final rawLine in text.split('\n')) {
    var line = rawLine.trim();
    if (line.isEmpty) continue;
    line = line.replaceAll('：', ':');
    final lower = line.toLowerCase();
    if (lower.startsWith('服务器地址:')) {
      url = line.substring('服务器地址:'.length).trim();
    } else if (lower.startsWith('连接密钥:')) {
      final v = line.substring('连接密钥:'.length).trim();
      if (v.isEmpty) key = null;
      else if (v.startsWith('enc:') || v.startsWith('ENC:')) {
        try { key = _deobfuscate(v.substring(4)); } catch (_) { key = null; }
      } else { key = v; }
    } else if (lower.startsWith('http://') || lower.startsWith('https://')) {
      url = line;
    }
  }
  if (url == null && text.toLowerCase().contains('host=')) {
    for (final part in text.split(RegExp(r'[,，]'))) {
      final p = part.trim();
      final idx = p.indexOf('=');
      if (idx <= 0) continue;
      final k = p.substring(0, idx).trim().toLowerCase();
      final v = p.substring(idx + 1).trim();
      if (k == 'host') { url = v; }
      else if (k == 'key') {
        if (v.isEmpty) key = null;
        else if (v.startsWith('enc:') || v.startsWith('ENC:')) {
          try { key = _deobfuscate(v.substring(4)); } catch (_) { key = null; }
        } else { key = v; }
      }
    }
  }
  url = _validateUrl(url);
  if (key != null && key.isEmpty) key = null;
  return (url, key);
}

void main() {
  test('解析本 App 复制格式（enc 混淆密钥）', () {
    final enc = _obfuscate('my-secret-key');
    final (url, key) = parseConfig('TeleBook 同步配置\n服务器地址: http://192.168.1.5:18080\n连接密钥: enc:$enc');
    expect(url, 'http://192.168.1.5:18080');
    expect(key, 'my-secret-key');
  });

  test('中文冒号 + 明文密钥', () {
    final (url, key) = parseConfig('服务器地址：http://example.com:18080\n连接密钥：plain-key');
    expect(url, 'http://example.com:18080');
    expect(key, 'plain-key');
  });

  test('RustDesk 风格 host=/key= 逗号分隔（大小写不敏感）', () {
    final (url, key) = parseConfig('rustdesk-Host=192.168.1.9:18080,Key=abc123');
    // 无 http/https scheme → 地址校验失败
    expect(url, isNull);
    expect(key, 'abc123');
  });

  test('RustDesk 风格带 scheme 合法', () {
    final (url, key) = parseConfig('host=http://10.0.0.2:18080,key=xyz');
    expect(url, 'http://10.0.0.2:18080');
    expect(key, 'xyz');
  });

  test('裸 URL', () {
    final (url, key) = parseConfig('http://192.168.31.202:18080');
    expect(url, 'http://192.168.31.202:18080');
    expect(key, isNull);
  });

  test('非法 URL 被拒绝', () {
    final (url, _) = parseConfig('服务器地址: 不是地址\n连接密钥: k');
    expect(url, isNull);
  });

  test('损坏的 enc 密文 → 密钥 null', () {
    final (_, key) = parseConfig('服务器地址: http://a.b:1\n连接密钥: enc:!!!not-base64!!!');
    expect(key, isNull);
  });

  test('无关文本 → 两者皆 null', () {
    final (url, key) = parseConfig('今天天气不错\n随便复制的内容');
    expect(url, isNull);
    expect(key, isNull);
  });
}
