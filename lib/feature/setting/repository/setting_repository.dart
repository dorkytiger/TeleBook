import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';
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

  Future<ReadingDirection> getReadingDirection() async {
    final raw = await _datasource.getValue(ReadingDirection.key);
    return raw == null
        ? ReadingDirection.leftToRight
        : ReadingDirection.values.firstWhere((e) => e.name == raw);
  }

  Future<void> setReadingDirection(ReadingDirection dir) =>
      _datasource.setValue(ReadingDirection.key, dir.name);
}
