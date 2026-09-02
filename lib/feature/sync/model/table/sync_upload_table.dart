import 'package:drift/drift.dart';

/// 待上传书籍（§8.2 上传侧断点续传，文件级断点）。
///
/// 初始化同步「本地有 + 远程空/有」时，客户端把要上传的书清单 + 数据版本落库这里。
/// 后台逐文件上传，进度同步到服务器（Redis/DB），进程崩/断网后据此续传。
class SyncUploadTable extends Table {
  /// 服务器分配的 uuid（§6；init 后回填）。
  TextColumn get uuid => text()();

  TextColumn get name => text()();

  /// 文件总数 / 已上传数。
  IntColumn get totalFiles => integer().withDefault(const Constant(0))();
  IntColumn get doneFiles => integer().withDefault(const Constant(0))();

  /// 客户端数据版本（断点续传/并发匹配，§4）。
  TextColumn get dataVersion => text().withDefault(const Constant(''))();

  /// 整体任务状态：pending(待上传) / uploading / done(全部完成) / failed。
  TextColumn get status => text().withDefault(const Constant('pending'))();

  /// 该书 user-facing 状态（明细面板显示）。
  TextColumn get bookStatus => text().withDefault(const Constant('等待'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {uuid};
}
