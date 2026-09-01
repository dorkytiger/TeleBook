import 'package:drift/drift.dart';

/// 实体同步状态表：记录每个实体在服务器上的版本（乐观锁 base_revision）。
///
/// entity_id 是跨设备稳定的 UUID（书籍对应 BookTable.uuid）。
class EntitySyncStateTable extends Table {
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  IntColumn get serverRevision => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {entityType, entityId};
}
