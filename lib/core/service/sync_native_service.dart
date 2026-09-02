import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 同步保活前台服务桥（原生优先，避免第三方库）。
///
/// Android：MethodChannel → [SyncForegroundService]（前台通知 + PARTIAL_WAKE_LOCK，
/// 熄屏/Doze 下保持进程 CPU 唤醒、网络连接不断）。
/// iOS：系统后台机制为“暂停”，暂不实现（如需跨进程后台任务再引入
/// workmanager / BGTaskScheduler 类库）。
/// 其它平台 / 无宿主：静默 no-op。
class SyncNativeForeground {
  static const MethodChannel _channel = MethodChannel('telebook/sync_service');

  static bool _active = false;

  static bool get active => _active;

  /// 同步开始：启动前台服务（幂等）。
  static Future<void> start(String text) async {
    if (_active) return;
    _active = true;
    await _invoke('startSync', text);
  }

  /// 同步进行中：更新前台通知文案（低频调用）。
  static Future<void> update(String text) async {
    if (!_active) return;
    await _invoke('updateSync', text);
  }

  /// 同步结束：停止前台服务（幂等）。
  static Future<void> stop() async {
    if (!_active) return;
    _active = false;
    await _invoke('stopSync', null);
  }

  static Future<void> _invoke(String method, String? text) async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        await _channel.invokeMethod<String>(
          method,
          text == null ? null : {'text': text},
        );
      } catch (_) {
        // 无宿主/插件未注册：静默（单元测试等场景）
      }
    }
  }
}
