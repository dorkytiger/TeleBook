import 'dart:async';

/// 全局串行任务队列：所有会改变同步数据的操作（修改/删除/导入/手动同步/自动同步）
/// 经此队列串行执行，避免并发 push 与本地状态回写冲突。
class SyncQueue {
  final List<_SyncTask> _pending = [];
  bool _running = false;

  /// 入队并等待任务完成；任务抛错时 Future 以该错误结束（调用方可感知失败）。
  Future<void> enqueue(Future<void> Function() task) {
    final completer = Completer<void>();
    _pending.add(_SyncTask(task, completer));
    _drain();
    return completer.future;
  }

  Future<void> _drain() async {
    if (_running) return;
    _running = true;
    try {
      while (_pending.isNotEmpty) {
        final task = _pending.removeAt(0);
        try {
          await task.run();
          task.completer.complete();
        } catch (e, st) {
          task.completer.completeError(e, st);
        }
      }
    } finally {
      _running = false;
    }
  }
}

class _SyncTask {
  final Future<void> Function() run;
  final Completer<void> completer;

  _SyncTask(this.run, this.completer);
}
