class TaskRuntimeDatasource {
  int taskTabIndex = 0;

  Stream<int> watchTaskTabIndex() async* {
    yield taskTabIndex;
  }

  void updateTaskTabIndex(int index) {
    taskTabIndex = index;
  }
}
