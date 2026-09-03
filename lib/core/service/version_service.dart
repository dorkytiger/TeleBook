import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/core/service/dio_provdier.dart';

part 'version_service.g.dart';

class UpdateInfo {
  final String version;
  final String url;
  final String? notes;
  final String? publishedAt;

  const UpdateInfo({
    required this.version,
    required this.url,
    this.notes,
    this.publishedAt,
  });
}

@Riverpod(keepAlive: true)
class VersionService extends _$VersionService {
  static const String _latestPath =
      '/repos/dorkytiger/TeleBook/releases/latest';
  static const String _repo = 'dorkytiger/TeleBook';
  static const String _releasePage = 'https://github.com/$_repo/releases';

  @override
  Future<UpdateInfo?> build() => fetchLatest();

  Future<UpdateInfo?> fetchLatest() async {
    try {
      final dio = ref.watch(githubDioProvider);
      final res = await dio.get<Map<String, dynamic>>(
        _latestPath,
        options: Options(headers: {'Accept': 'application/vnd.github+json'}),
      );
      final tag = (res.data?['tag_name'] as String? ?? '').replaceFirst(
        RegExp(r'^v'),
        '',
      );
      if (tag.isEmpty) return null;

      return UpdateInfo(
        version: tag,
        url: (res.data?['html_url'] as String?) ?? _releasePage,
        notes: res.data?['body'] as String?,
        publishedAt: res.data?['published_at'] as String?,
      );
    } on DioException {
      return null;
    }
  }

  /// 语义化版本比较：remote > local
  static bool isNewer(String remote, String local) {
    final r = _parse(remote);
    final l = _parse(local);
    for (var i = 0; i < 3; i++) {
      if (r[i] != l[i]) return r[i] > l[i];
    }
    return false;
  }

  static List<int> _parse(String version) {
    final parts = version.split('.');
    return [for (var i = 0; i < 3; i++) int.tryParse(parts[i]) ?? 0];
  }
}
