import 'dart:async';

/// 轻量原生异步互斥锁，替代 synchronized 包。
///
/// 用法与 synchronized 包的 [Lock] 保持一致：
/// ```dart
/// final lock = AsyncLock();
/// await lock.synchronized(() async {
///   // 临界区
/// });
/// ```
class AsyncLock {
  Future<void> _tail = Future.value();

  /// 串行执行 [action]，保证同一时刻只有一个任务在临界区内运行。
  Future<T> synchronized<T>(FutureOr<T> Function() action) {
    final completer = Completer<void>();
    // 将新任务追加到队列尾部
    final previous = _tail;
    _tail = completer.future;
    return previous.then((_) => action()).whenComplete(completer.complete);
  }
}
