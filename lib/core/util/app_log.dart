import 'package:flutter/foundation.dart';

/// 轻量原生日志工具，替代 dk_util 的 DKLog。
///
/// 仅实现项目实际使用到的 debug / info / error 级别，
/// 通过 [debugPrint] 输出，附带可选 [tag] 便于过滤。
abstract final class AppLog {
  static const String _prefix = '📚';

  /// 调试日志。
  static void d(dynamic message, {String? tag}) =>
      _log('DEBUG', message, tag: tag);

  /// 信息日志。
  static void i(dynamic message, {String? tag}) =>
      _log('INFO', message, tag: tag);

  /// 警告日志。
  static void w(dynamic message, {String? tag}) =>
      _log('WARN', message, tag: tag);

  /// 错误日志。
  static void e(dynamic message, {String? tag, Object? error}) {
    _log('ERROR', message, tag: tag);
    if (error != null) {
      debugPrint('$error');
    }
  }

  static void _log(String level, dynamic message, {String? tag}) {
    final tagPart = tag == null || tag.isEmpty ? '' : ' [$tag]';
    debugPrint('$_prefix $level$tagPart: $message');
  }
}
