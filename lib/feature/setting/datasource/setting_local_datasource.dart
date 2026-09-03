import 'package:drift/drift.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/setting/model/table/setting_table.dart';

part 'setting_local_datasource.g.dart';

@DriftAccessor(tables: [SettingTable])
class SettingLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$SettingLocalDatasourceMixin {
  SettingLocalDatasource(super.attachedDatabase);

  /// 读取设置值；key 不存在返回 null
  Future<String?> getValue(String key) async {
    final row = await (select(settingTable)
      ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  /// 监听全部设置（任何 key 变更都会发出新快照；UI 状态类配置用）。
  Stream<List<SettingTableData>> watchAll() {
    return (select(settingTable)).watch();
  }

  /// 写入设置：key 存在则更新，不存在则插入。
  /// 依赖你改过的 key 唯一约束/主键，insertOnConflictUpdate 才有冲突目标。
  Future<void> setValue(String key, String value) {
    return into(settingTable).insertOnConflictUpdate(
      SettingTableCompanion.insert(key: key, value: value),
    );
  }

  /// 删除设置；返回删除行数（0 = key 不存在）
  Future<int> deleteValue(String key) {
    return (delete(settingTable)..where((t) => t.key.equals(key))).go();
  }
}