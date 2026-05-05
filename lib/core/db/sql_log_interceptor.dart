import 'package:dk_util/log/dk_log.dart';
import 'package:drift/drift.dart';

class SqlLogInterceptor extends QueryInterceptor {
  static const _tag = 'SQL';

  @override
  Future<int> runInsert(QueryExecutor executor, String sql, List<Object?> args) {
    DKLog.d('INSERT | $sql | args: $args', tag: _tag);
    return super.runInsert(executor, sql, args);
  }

  @override
  Future<int> runUpdate(QueryExecutor executor, String sql, List<Object?> args) {
    DKLog.d('UPDATE | $sql | args: $args', tag: _tag);
    return super.runUpdate(executor, sql, args);
  }

  @override
  Future<int> runDelete(QueryExecutor executor, String sql, List<Object?> args) {
    DKLog.d('DELETE | $sql | args: $args', tag: _tag);
    return super.runDelete(executor, sql, args);
  }

  @override
  Future<List<Map<String, Object?>>> runSelect(
      QueryExecutor executor, String sql, List<Object?> args) {
    DKLog.d('SELECT | $sql | args: $args', tag: _tag);
    return super.runSelect(executor, sql, args);
  }
}
