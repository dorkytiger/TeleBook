import 'package:drift/drift.dart';

/// 待同步任务（outbox）：本地优先——变更先落库并记一条待推送任务，
/// 后台 drain 串行推送服务器，成功后移除。
///
/// payload 为变更时刻的快照（书籍 payload JSON 字符串），
/// base_revision 在 drain 时从 entity_sync_state 解析（保证同一实体多任务顺序正确）。
class SyncTaskTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // 主键 + 排序（FIFO）
  TextColumn get changeId => text().unique()(); // 幂等键（重试不变）
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get op => text()(); // upsert / delete
  TextColumn get payload => text().nullable()(); // 变更快照（JSON 字符串）
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending / failed
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
