import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tele_book/app/cache/network_cache.dart';
import 'package:tele_book/app/cache/local_cache.dart';

/// A simple custom image loader that first checks local files, then local cache,
/// then network (with caching). Returns a Widget (Image).
class CustomImageLoader {
  CustomImageLoader._internal();
  static final CustomImageLoader instance = CustomImageLoader._internal();

  Widget image(String pathOrUrl, {double? width, double? height, BoxFit? fit, Widget? placeholder}) {
    if (pathOrUrl.isEmpty) return placeholder ?? const SizedBox();

    // Local file
    if (!pathOrUrl.startsWith('http')) {
      final f = File(pathOrUrl);
      if (f.existsSync()) return Image.file(f, width: width, height: height, fit: fit);
      // else fallthrough to placeholder
      return placeholder ?? const SizedBox();
    }

    // Network URL: attempt to load from disk cache first synchronously (if exists)
    return FutureBuilder<Widget>(
      future: _loadNetworkImageWidget(pathOrUrl, width: width, height: height, fit: fit),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done && snap.hasData) {
          return snap.data!;
        }
        return placeholder ?? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)));
      },
    );
  }

  Future<Widget> _loadNetworkImageWidget(String url, {double? width, double? height, BoxFit? fit}) async {
    // check local cache file first
    final localFile = await LocalCache.instance.getFile(url);
    if (localFile != null) {
      return Image.file(localFile, width: width, height: height, fit: fit);
    }

    final bytes = await NetworkCache.instance.get(url);
    if (bytes != null) {
      return Image.memory(bytes, width: width, height: height, fit: fit);
    }

    // final fallback: return empty sized box
    return const SizedBox();
  }
}

