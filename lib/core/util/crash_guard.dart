import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:tele_book/core/util/app_log.dart';

/// 崩溃捕获与诊断上下文（Dart 层全覆盖，零第三方崩溃 SDK）：
///
/// - 捕获 [FlutterError.onError]（build/layout 异常）、
///   [PlatformDispatcher.instance.onError]（async/zone 未捕获）、
///   以及主 isolate 的未处理异步错误（runZonedGuarded）；
/// - 每次捕获把「上下文头（版本/设备/服务器）+ 异常 + 堆栈 +
///   崩溃前现场（AppLog 环形缓冲）」写为 logs/crash_*.log；
/// - [deviceInfo] 在 [collectContext] 时一次性收集（设备信息走平台通道，
///   崩溃瞬间再异步取来不及），缓存供崩溃时同步拼装。
///
/// 导出诊断包 = 日志文件 + crash 文件 + [contextText]（设置页触发）。
abstract final class CrashGuard {
  static bool _installed = false;

  static PackageInfo? _pkg;
  static String _device = '';
  static String _os = '';
  static String _serverUrl = ''; // 脱敏后的服务器地址（可选注入）

  static bool get installed => _installed;

  /// 启动早期安装（main 里 runApp 前调用一次）。
  static void install() {
    if (_installed) return;
    _installed = true;
    // 1) Flutter 框架层错误（build/layout/runApp 内的异常）
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      _record(
        'FlutterError: ${details.exception}',
        details.stack?.toString() ?? '',
      );
      oldOnError?.call(details); // 保留默认行为（debug 下红屏提示）
    };
    // 2) 平台派发未捕获异步错误（Zone 外兜底，返回 true=已处理）
    PlatformDispatcher.instance.onError = (error, stack) {
      _record('AsyncError: $error', stack.toString());
      return true;
    };
    // 3) 启动上下文预收集（设备信息异步，崩溃时同步可用）
    unawaited(_warmup());
  }

  /// 供 main 用 runZonedGuarded 包 runApp 的兜底（Zone 内未捕获同步错误）。
  static void zoneError(Object error, StackTrace stack) {
    _record('ZoneError: $error', stack.toString());
  }

  /// 注入服务器地址（脱敏，不含 token）。由同步服务初始化后调用（可选）。
  static void setServerUrl(String url) {
    _serverUrl = _maskUrl(url);
  }

  /// 设备/版本上下文文本（导出诊断包与崩溃文件头共用）。
  static Future<String> contextText() async {
    await _warmup();
    final buf = StringBuffer()
      ..writeln('TeleBook 诊断信息')
      ..writeln('App 版本: ${_pkg?.version ?? '?'} (build ${_pkg?.buildNumber ?? '?'})')
      ..writeln('平台: ${defaultTargetPlatform.name} / $kIsWeb')
      ..writeln('OS: $_os')
      ..writeln('设备: $_device')
      ..writeln('服务器: ${_serverUrl.isEmpty ? '未配置' : _serverUrl}')
      ..writeln('日志目录: ${AppLog.dirPath ?? '（未初始化）'}');
    return buf.toString();
  }

  // ── 内部 ──────────────────────────────────────────────

  /// 记录崩溃：写 crash 文件 + 主日志留一条 ERROR 便于按时间对齐。
  static Future<void> _record(String title, String stack) async {
    try {
      AppLog.e('$title\n$stack', tag: 'CRASH');
      // 上下文在崩溃瞬间同步拼装（预收集缓存）
      final header = StringBuffer()
        ..writeln('TeleBook 崩溃诊断')
        ..writeln('App: ${_pkg?.version ?? '?'} (${_pkg?.buildNumber ?? '?'})')
        ..writeln('平台: ${defaultTargetPlatform.name}')
        ..writeln('OS: $_os')
        ..writeln('设备: $_device')
        ..writeln('服务器: ${_serverUrl.isEmpty ? '未配置' : _serverUrl}');
      await AppLog.writeCrash(
        title: title,
        stack: stack,
        contextHeader: header.toString(),
      );
    } catch (_) {
      // 崩溃记录本身失败不影响用户
    }
  }

  /// 预收集设备/包信息（幂等，供崩溃与导出用）。
  static Future<void> _warmup() async {
    try {
      _pkg ??= await PackageInfo.fromPlatform();
    } catch (_) {}
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final info = await DeviceInfoPlugin().androidInfo;
        _device = info.model.isEmpty
            ? info.manufacturer
            : '${info.manufacturer} ${info.model}';
        _os = 'Android ${info.version.release} (API ${info.version.sdkInt})';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final info = await DeviceInfoPlugin().iosInfo;
        _device = '${info.name} ${info.model}';
        _os = 'iOS ${info.systemVersion}';
      } else if (!kIsWeb) {
        _os = Platform.operatingSystemVersion;
      }
    } catch (_) {
      // 设备信息不可得：留空
    }
  }

  /// 服务器地址脱敏：只保留 scheme+host（含 token/密钥参数一律去掉）。
  static String _maskUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
    } catch (_) {
      return url.length > 60 ? '${url.substring(0, 60)}…' : url;
    }
  }
}
