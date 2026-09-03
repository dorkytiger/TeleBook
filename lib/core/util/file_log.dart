import 'dart:io';

import 'package:tele_book/core/util/app_log.dart';

/// 同步/后台链路调试日志（并入统一日志系统后的兼容层）。
///
/// 早期版本独立写 `sync_bg.log`；现在统一走 [AppLog] 的滚动落盘
/// （{appDocDir}/logs/app.log），仅保留 `log/read/clear/filePath` 三个
/// 兼容入口，调用点（同步服务/原生桥）无需改动。
///
/// 与 [AppLog] 的区别：只落盘 + 进环形缓冲，**不打控制台**（BG 链路
/// 日志量大，避免刷屏）；行格式相同，可与 AppLog 日志混排按 tag 过滤。
abstract final class FileLog {
  /// 追加一条日志（异步落盘，不打控制台）。
  static void log(String tag, String msg) {
    AppLog.silent(tag, msg);
  }

  /// 读取日志尾部（统一日志，跨滚动文件拼接）。
  static Future<List<String>> read({int tail = 2000}) =>
      AppLog.readTail(tail: tail);

  /// 清空统一日志。
  static Future<void> clear() => AppLog.clear();

  /// 统一日志主文件路径。
  static String get filePath => AppLog.filePath;

  /// 兼容：旧实现是独立文件，现统一后返回 null（调用方不再单独展示）。
  static String? get legacyFilePath => null;

  /// 崩溃记录文件（排查同步链路崩溃现场用）。
  static Future<List<File>> crashFiles() => AppLog.crashFiles();
}
