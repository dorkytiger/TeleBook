import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:tele_book/common/config/global_config.dart';

/// 轻量文件日志（临时调试用）：同步/后台任务关键链路写本地文件，
/// 便于 release 真机（无法连调试器）排查熄屏后后台是否推进。
///
/// 文件：{appDocDir}/sync_bg.log；超 2MB 自动截断为后半。
class FileLog {
  static final List<String> _pending = [];
  static bool _writing = false;

  static String get filePath => p.join(GlobalConfig.appDocDir.path, 'sync_bg.log');

  /// 追加一条日志（异步落盘，不阻塞调用方）。
  static void log(String tag, String msg) {
    _pending.add('[${DateTime.now().toIso8601String()}] [$tag] $msg');
    unawaited(_flush());
  }

  static Future<void> _flush() async {
    if (_writing) return;
    _writing = true;
    try {
      final f = File(filePath);
      if (!await f.exists()) {
        await f.parent.create(recursive: true);
        await f.create();
      }
      // 防膨胀：超过上限时先截断（保留新内容）
      if (await f.length() > 2 * 1024 * 1024) {
        await f.delete();
        await f.create();
      }
      final sink = f.openWrite(mode: FileMode.append);
      while (_pending.isNotEmpty) {
        sink.write(_pending.removeAt(0));
        sink.write('\n');
      }
      await sink.flush();
      await sink.close();
    } catch (_) {
      // 日志失败不打扰主流程
    } finally {
      _writing = false;
    }
  }

  /// 读取日志（最近 [tail] 行）。
  static Future<List<String>> read({int tail = 2000}) async {
    final f = File(filePath);
    if (!await f.exists()) return const [];
    final lines = await f.readAsLines();
    if (lines.length <= tail) return lines;
    return lines.sublist(lines.length - tail);
  }

  static Future<void> clear() async {
    final f = File(filePath);
    if (await f.exists()) {
      await f.delete();
    }
  }
}
