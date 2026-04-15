import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'local_cache.dart';

/// A lightweight network cache: in-memory map with optional persistence to LocalCache.
class NetworkCache {
  NetworkCache._internal();
  static final NetworkCache instance = NetworkCache._internal();

  final Map<String, Uint8List> _memCache = {};
  final int maxEntries = 200;

  Future<Uint8List?> get(String url) async {
    if (_memCache.containsKey(url)) return _memCache[url];

    // Check local cache on disk
    final local = await LocalCache.instance.getFile(url);
    if (local != null) {
      final bytes = await local.readAsBytes();
      _putToMem(url, bytes);
      return Uint8List.fromList(bytes);
    }

    // Download
    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        final bytes = resp.bodyBytes;
        _putToMem(url, bytes);
        await LocalCache.instance.putBytes(url, bytes);
        return Uint8List.fromList(bytes);
      }
    } catch (_) {
      // ignore network errors here; caller can handle null
    }
    return null;
  }

  void _putToMem(String key, List<int> bytes) {
    if (_memCache.length >= maxEntries) {
      // simple eviction: remove first key
      final firstKey = _memCache.keys.first;
      _memCache.remove(firstKey);
    }
    _memCache[key] = Uint8List.fromList(bytes);
  }

  void clearMem() => _memCache.clear();
}

