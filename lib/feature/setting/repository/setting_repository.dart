import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/feature/setting/datasource/setting_local_datasource.dart';
import 'package:tele_book/feature/setting/enum/setting_key_value.dart';



final settingRepositoryProvider = Provider<SettingRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return SettingRepository(SettingLocalDatasource(database));
});

class SettingRepository {
  final SettingLocalDatasource _datasource;

  SettingRepository(this._datasource);

  Future<String?> getString(String key) => _datasource.getValue(key);

  Future<void> setString(String key, String value) =>
      _datasource.setValue(key, value);

  /// 监听同步配置（serverUrl + token 都非空才算已初始化服务器）。
  /// 响应式：在引导页连接成功写库后，设置页无需手动刷新即更新。
  Stream<bool> watchConfigured() {
    return _datasource.watchAll().map((rows) {
      String? valueOf(String key) {
        for (final row in rows) {
          if (row.key == key) return row.value;
        }
        return null;
      }

      final url = valueOf(SyncSettings.serverUrl);
      final token = valueOf(SyncSettings.token);
      return url != null && url.isNotEmpty && token != null && token.isNotEmpty;
    });
  }

  Future<ReadingDirection> getReadingDirection() async {
    final raw = await _datasource.getValue(ReadingDirection.key);
    return raw == null
        ? ReadingDirection.leftToRight
        : ReadingDirection.values.firstWhere((e) => e.name == raw);
  }

  Future<void> setReadingDirection(ReadingDirection dir) =>
      _datasource.setValue(ReadingDirection.key, dir.name);
}
