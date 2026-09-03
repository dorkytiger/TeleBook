import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'package:tele_book/common/config/global_config.dart';

/// 统一诊断日志器（原 AppLog 增强）：
///
/// 三出口、一套 API（现有 `AppLog.d/i/w/e` 调用点零改动）：
/// - 控制台：[debugPrint]（保持原行为）；
/// - 滚动落盘：`{appDocDir}/logs/app.log`，超 [maxFileBytes] 滚动保留
///   [maxFiles] 份（app.log / app.1.log / …），供导出/崩溃排查；
/// - 内存环形缓冲：最近 [ringSize] 行，崩溃时随 crash 文件落盘（现场日志）。
///
/// 行格式统一：`[ISO时间] [级别] [tag] 消息`，与 FileLog 兼容可混排。
///
/// 健壮性（防长期运行/磁盘异常把日志系统变成负担）：
/// - **总量硬预算**：logs 目录所有文件（滚动 + crash）超 [totalBudgetBytes]
///   时从最旧开始删（[maintenance] 与写盘失败时都会触发）；
/// - **定时维护**：init 后每 30 分钟跑一次（预算 + 过期崩溃清理）；
/// - **写盘自愈**：写失败 → 丢弃积压 + 冷却 60s（避免疯狂重试）+ 立刻触发
///   维护腾空间；冷却期日志只进环形缓冲，恢复后自动续写；
/// - **待写积压上限** [pendingCap]，防止极端下内存膨胀；
/// - **旧版残留迁移**：老版本独立 `sync_bg.log` 升级时并入 app.log 后删除；
/// - **崩溃文件双保险**：保留最近 [crashKeep] 份 **且** 超过 [crashMaxAgeDays]
///   天的一律清理。
///
/// ⚠️ 必须先调用 [init]（main 启动早期，GlobalConfig.init 之后）；
/// 未初始化时仅控制台输出 + 环形缓冲，保证测试/异常路径安全。
abstract final class AppLog {
  static const String _dirName = 'logs';
  static const String _baseName = 'app.log';

  /// 单文件滚动上限。
  static const int maxFileBytes = 2 * 1024 * 1024;

  /// 滚动保留份数（app.log + app.1.log … app.{maxFiles-1}.log）。
  static const int maxFiles = 4;

  /// logs 目录总预算（主日志最多 ~8MB + 崩溃记录；超了删最旧）。
  static const int totalBudgetBytes = 12 * 1024 * 1024;

  /// 环形缓冲行数。
  static const int ringSize = 200;

  /// 待写积压上限（写盘冷却时防止内存无限增长）。
  static const int pendingCap = 4000;

  /// 崩溃记录保留份数。
  static const int crashKeep = 10;

  /// 崩溃记录最长保留天数。
  static const int crashMaxAgeDays = 30;

  /// 定时维护间隔。
  static const Duration maintenanceInterval = Duration(minutes: 30);

  /// 写盘失败后的冷却时长（冷却期丢弃落盘，只留环形缓冲）。
  static const Duration ioCooldown = Duration(seconds: 60);

  static Directory? _logDir;
  static bool _initDone = false;
  static bool _initFailed = false;
  static final List<String> _pending = [];
  static bool _writing = false;
  static final List<String> _ring = [];
  static DateTime? _ioCooldownUntil;
  static Timer? _maintenanceTimer;

  /// 初始化日志目录（幂等）：建目录 + 旧版迁移 + 立即维护一次 + 启动定时维护。
  /// 返回是否可用。
  static Future<bool> init() async {
    if (_initDone || _initFailed) return _initDone;
    try {
      final dir = Directory(p.join(GlobalConfig.appDocDir.path, _dirName));
      await dir.create(recursive: true);
      _logDir = dir;
      _initDone = true;
      await _migrateLegacySyncBg();
      await maintenance();
      _maintenanceTimer ??= Timer.periodic(maintenanceInterval, (_) {
        unawaited(maintenance());
      });
      return true;
    } catch (_) {
      _initFailed = true; // 目录不可写：降级纯控制台
      return false;
    }
  }

  static bool get isReady => _initDone;

  /// 测试注入：用指定目录直接初始化（绕过 GlobalConfig/path_provider），
  /// 不启动定时维护定时器。仅测试使用。
  @visibleForTesting
  static Future<void> initForTest(String dirPath) async {
    // 复位全部静态状态，保证测试间隔离（AppLog 是单例）
    _pending.clear();
    _ring.clear();
    _writing = false;
    _ioCooldownUntil = null;
    final dir = Directory(dirPath);
    await dir.create(recursive: true);
    _logDir = dir;
    _initDone = true;
    _initFailed = false;
    await maintenance();
  }

  /// 测试用：等待在途写盘完成 + 待写积压清空。
  @visibleForTesting
  static Future<void> flushNow() async {
    // 等在途写盘结束（_writing 竞态：可能已被某次 unawaited flush 占用）
    while (_writing) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    // 清空剩余积压（期间可能又有新行）
    for (var guard = 0; guard < 100 && _pending.isNotEmpty; guard++) {
      await _flush();
      while (_writing) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
    }
  }

  /// 日志目录绝对路径（未初始化返回 null）。
  static String? get dirPath => _logDir?.path;

  /// 主日志文件路径。
  static String get filePath =>
      _logDir == null ? '' : p.join(_logDir!.path, _baseName);

  // ── 对外 API（兼容旧 AppLog）──────────────────────────

  static void d(dynamic message, {String? tag}) =>
      _log('DEBUG', message, tag: tag);

  static void i(dynamic message, {String? tag}) =>
      _log('INFO', message, tag: tag);

  static void w(dynamic message, {String? tag}) =>
      _log('WARN', message, tag: tag);

  static void e(dynamic message, {String? tag, Object? error}) {
    _log('ERROR', message, tag: tag);
    if (error != null) {
      debugPrint('$error');
      _log('ERROR', '$error', tag: tag == null ? 'EX' : '$tag/EX');
    }
  }

  /// 静默日志：只进环形缓冲 + 落盘，不打控制台（供高频/后台链路，
  /// 如 FileLog 的 BG_* 调试日志）。行格式 `[ISO] [tag] msg`。
  static void silent(String tag, String msg) {
    _log('SYNC', msg, tag: tag, console: false);
  }

  // ── 维护（对外可手动触发，如导出前）───────────────────

  /// 维护：过期崩溃清理 + 总量预算执行。可随时手动调用（幂等）。
  static Future<void> maintenance() async {
    _pruneCrash(keep: crashKeep, maxAgeDays: crashMaxAgeDays);
    await _enforceBudget();
  }

  // ── 读取 / 清空 / 崩溃文件 ────────────────────────────

  /// 读取主日志尾部 [tail] 行（跨滚动文件拼接，时间序）。
  static Future<List<String>> readTail({int tail = 2000}) async {
    final files = _logFilesNewestFirst();
    final lines = <String>[];
    // 旧 → 新追加，保持时间序
    for (final f in files.reversed) {
      try {
        if (await f.exists()) lines.addAll(await f.readAsLines());
      } catch (_) {}
      if (lines.length >= tail) break;
    }
    if (lines.length <= tail) return lines;
    return lines.sublist(lines.length - tail);
  }

  /// 环形缓冲（最近 [ringSize] 行，崩溃现场）。
  static List<String> ringTail() => List.unmodifiable(_ring);

  /// 清空主日志（含滚动历史；不影响崩溃记录）。
  static Future<void> clear() async {
    _pending.clear();
    for (final f in _logFilesNewestFirst()) {
      try {
        if (await f.exists()) await f.delete();
      } catch (_) {}
    }
  }

  /// 崩溃记录文件（新在前）。
  static Future<List<File>> crashFiles() async {
    final dir = _logDir;
    if (dir == null || !await dir.exists()) return const [];
    try {
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => p.basename(f.path).startsWith('crash_'))
          .toList()
        ..sort((a, b) => b.path.compareTo(a.path));
      return files;
    } catch (_) {
      return const [];
    }
  }

  /// 崩溃记录数（设置页红点提示用）。
  static Future<int> crashCount() async => (await crashFiles()).length;

  /// 写一份崩溃记录：头部上下文 + 异常/堆栈 + 环形缓冲现场。
  /// [contextHeader] 由 CrashGuard 收集（版本/设备/服务器等）。
  static Future<File?> writeCrash({
    required String title,
    required String stack,
    required String contextHeader,
  }) async {
    final dir = _logDir;
    if (dir == null) return null;
    try {
      final now = DateTime.now();
      // 命名唯一：毫秒戳 + 同毫秒多崩溃加序号（避免互相覆盖丢记录）
      final base = 'crash_${now.millisecondsSinceEpoch}';
      var name = '$base.log';
      var seq = 1;
      while (File(p.join(dir.path, name)).existsSync()) {
        name = '${base}_$seq.log';
        seq++;
      }
      final f = File(p.join(dir.path, name));
      final buf = StringBuffer()
        ..writeln('===== TeleBook 崩溃记录 =====')
        ..writeln(contextHeader)
        ..writeln('时间: ${now.toIso8601String()}')
        ..writeln('异常: $title')
        ..writeln()
        ..writeln('---- 堆栈 ----')
        ..writeln(stack)
        ..writeln()
        ..writeln('---- 崩溃前现场（环形缓冲 ${_ring.length} 行）----');
      for (final line in _ring) {
        buf.writeln(line);
      }
      await f.writeAsString(buf.toString(), flush: true);
      _pruneCrash(keep: crashKeep, maxAgeDays: crashMaxAgeDays);
      return f;
    } catch (_) {
      return null;
    }
  }

  // ── 内部实现 ──────────────────────────────────────────

  static void _log(String level, dynamic message,
      {String? tag, bool console = true}) {
    final line =
        '[${DateTime.now().toIso8601String()}] [$level]${tag == null || tag.isEmpty ? '' : ' [$tag]'} $message';
    if (console) debugPrint('📚 $line');
    // 环形缓冲：始终维护（崩溃现场不依赖落盘）
    _ring.add(line);
    if (_ring.length > ringSize) {
      _ring.removeRange(0, _ring.length - ringSize);
    }
    // 落盘
    if (!_initDone) return;
    // 冷却期：丢弃落盘（只留环形缓冲），冷却结束后恢复
    final now = DateTime.now();
    if (_ioCooldownUntil != null && now.isBefore(_ioCooldownUntil!)) {
      return;
    }
    _ioCooldownUntil = null;
    _pending.add(line);
    if (_pending.length > pendingCap) {
      _pending.removeRange(0, _pending.length - pendingCap);
    }
    unawaited(_flush());
  }

  /// 异步批量写盘（单写者串行；滚动在主文件超限时进行）。
  /// 失败：清积压 + 冷却 60s（防疯狂重试）+ 触发维护腾空间，下条日志自愈。
  static Future<void> _flush() async {
    if (_writing) return;
    _writing = true;
    try {
      final dir = _logDir;
      if (dir == null) return;
      final file = File(filePath);
      if (!await file.exists()) {
        await file.create(recursive: true);
      }
      if (await file.length() > maxFileBytes) {
        await _rotate();
      }
      final sink = file.openWrite(mode: FileMode.append);
      while (_pending.isNotEmpty) {
        sink.write(_pending.removeAt(0));
        sink.write('\n');
      }
      await sink.flush();
      await sink.close();
    } catch (e) {
      // 写盘异常（磁盘满/权限等）：丢弃积压 + 冷却 + 触发维护清理空间
      debugPrint('📚 AppLog flush 失败: $e');
      _pending.clear();
      _ioCooldownUntil = DateTime.now().add(ioCooldown);
      unawaited(maintenance());
    } finally {
      _writing = false;
    }
  }

  /// 总量预算：logs 目录所有文件总大小超 [totalBudgetBytes] 时，
  /// 从最旧（按 mtime）开始删除（跳过当前正在写的 app.log，除非只剩它）。
  static Future<void> _enforceBudget() async {
    final dir = _logDir;
    if (dir == null || !dir.existsSync()) return;
    try {
      final files = dir.listSync().whereType<File>().toList()
        ..sort((a, b) => _mtime(a).compareTo(_mtime(b))); // 旧在前
      var total = 0;
      for (final f in files) {
        try {
          total += f.lengthSync();
        } catch (_) {}
      }
      while (total > totalBudgetBytes && files.isNotEmpty) {
        // 最旧优先删；尽量不删当前正在写的 app.log
        var victim = files.removeAt(0);
        if (p.basename(victim.path) == _baseName && files.isNotEmpty) {
          victim = files.removeAt(0); // 删下一个最旧的滚动/崩溃文件
        }
        try {
          final len = victim.lengthSync();
          await victim.delete();
          total -= len;
        } catch (_) {
          // 删不掉（可能正在写）：跳过避免死循环
          if (files.isEmpty) break;
        }
      }
    } catch (_) {}
  }

  static DateTime _mtime(File f) {
    try {
      return f.lastModifiedSync();
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  /// 滚动：删最旧（app.{maxFiles-1}.log）→ app.2→app.3 … → app.log→app.1。
  static Future<void> _rotate() async {
    final dir = _logDir;
    if (dir == null) return;
    // 1) 删除最旧一份（app.{maxFiles-1}.log）
    final oldest = File(p.join(dir.path, _rollName(maxFiles - 1)));
    try {
      if (await oldest.exists()) await oldest.delete();
    } catch (_) {}
    // 2) 从旧到新后移：app.{i}.log → app.{i+1}.log（i = maxFiles-2 … 1）
    for (var i = maxFiles - 2; i >= 1; i--) {
      final from = File(p.join(dir.path, _rollName(i)));
      if (await from.exists()) {
        try {
          await from.rename(p.join(dir.path, _rollName(i + 1)));
        } catch (_) {}
      }
    }
    // 3) 主文件 → app.1.log
    final main = File(p.join(dir.path, _rollName(0)));
    try {
      if (await main.exists()) {
        await main.rename(p.join(dir.path, _rollName(1)));
      }
    } catch (_) {}
    // 4) 清理历史遗留的超额文件（旧版可能生成过 app.log.1 风格）
    _pruneOldLogs();
  }

  /// 滚动文件名：0 → app.log，n → app.n.log。
  static String _rollName(int index) =>
      index == 0 ? _baseName : '${_baseName.split('.').first}.$index.log';

  /// 崩溃记录清理双保险：超 [maxAgeDays] 天的删 + 超 [keep] 份的删最旧。
  static void _pruneCrash({required int keep, required int maxAgeDays}) {
    final dir = _logDir;
    if (dir == null || !dir.existsSync()) return;
    try {
      final cutoff = DateTime.now()
          .subtract(Duration(days: maxAgeDays))
          .millisecondsSinceEpoch;
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => p.basename(f.path).startsWith('crash_'))
          .toList()
        ..sort((a, b) => _mtime(a).compareTo(_mtime(b))); // 旧在前
      // 1) 时间维度：超龄删除
      while (files.isNotEmpty) {
        final ms = _crashMillis(p.basename(files.first.path));
        if (ms == null || ms >= cutoff) break;
        try {
          files.removeAt(0).deleteSync();
        } catch (_) {
          files.removeAt(0);
        }
      }
      // 2) 份数维度：保留最近 keep 份
      while (files.length > keep) {
        try {
          files.removeAt(0).deleteSync();
        } catch (_) {
          files.removeAt(0);
        }
      }
    } catch (_) {}
  }

  /// 从 `crash_<millis>.log` 解析时间戳。
  static int? _crashMillis(String name) {
    final m = RegExp(r'^crash_(\d+)(?:_\d+)?\.log$').firstMatch(name);
    if (m == null) return null;
    return int.tryParse(m.group(1)!);
  }

  /// 旧版 FileLog（独立 sync_bg.log）升级迁移：内容并入 app.log 后删除。
  static Future<void> _migrateLegacySyncBg() async {
    final legacy = File(
      p.join(GlobalConfig.appDocDir.path, 'sync_bg.log'),
    );
    try {
      if (!await legacy.exists()) return;
      final lines = await legacy.readAsLines();
      if (lines.isNotEmpty && _initDone) {
        _pending.insertAll(
          0,
          ['—— 迁移自旧版 sync_bg.log ——', ...lines],
        );
        await _flush();
      }
      await legacy.delete(); // 迁移后删除（空文件/失败也删）
    } catch (_) {}
  }

  /// 删除超过 maxFiles 的滚动文件 + 兼容旧命名（app.log.N 遗留）。
  static void _pruneOldLogs() {
    final dir = _logDir;
    if (dir == null || !dir.existsSync()) return;
    try {
      final logs = dir
          .listSync()
          .whereType<File>()
          .where((f) =>
              RegExp(r'^app(\.\d+)?\.log$').hasMatch(p.basename(f.path)))
          .toList();
      for (final f in logs) {
        final name = p.basename(f.path);
        if (name == _baseName) continue;
        final idx = int.tryParse(name.split('.').elementAt(1)) ?? 0;
        if (idx >= maxFiles) {
          try {
            f.deleteSync();
          } catch (_) {}
        }
      }
      // 旧命名遗留：app.log.1 / app.log.2 …（早期 bug 版产物）直接删
      final legacy = dir
          .listSync()
          .whereType<File>()
          .where((f) =>
              RegExp(r'^app\.log\.\d+$').hasMatch(p.basename(f.path)))
          .toList();
      for (final f in legacy) {
        try {
          f.deleteSync();
        } catch (_) {}
      }
    } catch (_) {}
  }

  /// 现有主日志文件（新 → 旧：app.log, app.1.log, …）。
  static List<File> _logFilesNewestFirst() {
    final dir = _logDir;
    if (dir == null || !dir.existsSync()) return const [];
    try {
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) =>
              RegExp(r'^app(\.\d+)?\.log$').hasMatch(p.basename(f.path)))
          .toList();
      // 排序：app.log(0) < app.1.log < app.2.log …；新文件(小号)在前
      files.sort((a, b) {
        int idx(String name) {
          if (name == _baseName) return 0;
          return int.tryParse(name.split('.').elementAt(1)) ?? 0;
        }
        return idx(p.basename(a.path)).compareTo(idx(p.basename(b.path)));
      });
      return files;
    } catch (_) {
      return const [];
    }
  }
}
