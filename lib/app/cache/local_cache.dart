import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

/// A simple local file cache. Stores bytes under application documents cache folder.
class LocalCache {
  LocalCache._internal();
  static final LocalCache instance = LocalCache._internal();

  Future<Directory> _cacheDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final cache = Directory('${dir.path}/telebook_cache');
    if (!await cache.exists()) await cache.create(recursive: true);
    return cache;
  }

  String _fileNameForKey(String key) {
    // Produce a short filename safe string from key
    final encoded = base64Url.encode(utf8.encode(key));
    // truncate to avoid extremely long filenames
    return encoded.length > 64 ? encoded.substring(0, 64) : encoded;
  }

  Future<File> _fileForKey(String key) async {
    final dir = await _cacheDir();
    final name = _fileNameForKey(key);
    return File('${dir.path}/$name');
  }

  Future<bool> exists(String key) async {
    final f = await _fileForKey(key);
    return f.exists();
  }

  Future<File?> getFile(String key) async {
    final f = await _fileForKey(key);
    if (await f.exists()) return f;
    return null;
  }

  Future<File> putBytes(String key, List<int> bytes) async {
    final f = await _fileForKey(key);
    await f.writeAsBytes(bytes, flush: true);
    return f;
  }

  Future<void> clear() async {
    final dir = await _cacheDir();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
      await dir.create();
    }
  }
}

