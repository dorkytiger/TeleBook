import 'package:drift/drift.dart';

/// 同步操作任务（组任务：一次用户操作 = 一组，含多书×多图）。
///
/// 这是「全局通知 + 队列调度」的核心状态：
/// - 一次用户操作（初始化同步 / 刷新同步 / 上传快照 / 手动同步）写入一行。
/// - status 覆盖文档 §8.0：进行中 / 等待中 / 成功 / 失败 / 中断。
/// - 落库持久化：App 启动收割遗留「进行中」为「中断」；断点续传依赖它。
class SyncOpTable extends Table {
  /// 主键 + 队列顺序（FIFO，串行执行）。
  IntColumn get id => integer().autoIncrement()();

  /// 任务类型：init(初始化) / refresh(刷新) / upload_snapshot(上传快照) / manual(手动同步)。
  TextColumn get type => text()();

  /// 状态：running(进行中) / waiting(等待中) / done(成功) / failed(失败) / interrupted(中断)。
  TextColumn get status => text().withDefault(const Constant('waiting'))();

  /// 进度：总书数 / 已完成书数。
  IntColumn get totalBooks => integer().withDefault(const Constant(0))();
  IntColumn get doneBooks => integer().withDefault(const Constant(0))();

  /// 当前书进度（页 a / 页 b）。
  IntColumn get currentPage => integer().withDefault(const Constant(0))();
  IntColumn get totalPages => integer().withDefault(const Constant(0))();

  /// 错误信息（失败时）。
  TextColumn get error => text().nullable()();

  /// 用户可见的任务名称（如「初始化同步」「刷新同步」）。
  TextColumn get title => text()();

  /// 组任务规格（未发布迭代：main v2 → 本分支 v3 起新增）：内容型变更等任务的执行数据（如本地变更推送的
  /// 书清单 JSON）。落库后重启可据此重建执行（§8.0 恢复，替代纯闭包）。
  TextColumn get payload => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
