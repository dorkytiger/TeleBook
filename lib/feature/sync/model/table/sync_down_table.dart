import 'package:drift/drift.dart';

/// 待下载书籍（§8.1 下载侧断点续传：页级断点）。
///
/// 初始化同步「本地空 + 远程有」时，服务端返回的书清单先落库这里，
/// 下载队列逐个文件拉取，进程崩/断网后据此续传。
class SyncDownTable extends Table {
  /// 书籍稳定同步 ID（服务器分配，§6）。
  TextColumn get uuid => text()();

  TextColumn get name => text()();

  TextColumn get coverHash => text().nullable()();

  IntColumn get currentPage => integer().withDefault(const Constant(0))();

  /// 文件总数 / 已下载数。
  IntColumn get totalFiles => integer().withDefault(const Constant(0))();
  IntColumn get doneFiles => integer().withDefault(const Constant(0))();

  /// 整体任务状态：pending(待下载) / downloading / done(全部完成) / failed。
  TextColumn get status => text().withDefault(const Constant('pending'))();

  /// 该书的 user-facing 状态（明细面板显示）。
  TextColumn get bookStatus => text().withDefault(const Constant('等待'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {uuid};
}
