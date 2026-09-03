import 'package:flutter/material.dart';

import 'package:tele_book/core/util/app_log.dart';

/// 全局生命周期日志：记录 App 前后台切换 / 失焦恢复的时间点。
///
/// 排查"熄屏后后台同步是否持续推进"时，日志里能对齐：
/// 何时进后台（paused/hidden）、何时回前台（resumed）、何时被系统挂起。
class LifecycleLogObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppLog.i('App 生命周期: $state', tag: 'LIFECYCLE');
  }
}
