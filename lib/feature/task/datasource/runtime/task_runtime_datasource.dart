import 'dart:async';

class TaskRuntimeDatasource {
  int taskTabIndex = 0;

  late final StreamController<int> _controller = StreamController<int>.broadcast(
    onListen: () => _controller.add(taskTabIndex),
  );

  Stream<int> watchTaskTabIndex() {
    return _controller.stream;
  }

  void updateTaskTabIndex(int index) {
    if (taskTabIndex == index) return;
    taskTabIndex = index;
    _controller.add(taskTabIndex);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
