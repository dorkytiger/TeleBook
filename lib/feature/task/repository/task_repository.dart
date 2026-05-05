import 'package:tele_book/feature/task/datasource/runtime/task_runtime_datasource.dart';

class TaskRepository {
  final TaskRuntimeDatasource _taskRuntimeDatasource;
  TaskRepository(this._taskRuntimeDatasource);

  Stream<int> watchTaskIndex() {
    return _taskRuntimeDatasource.watchTaskTabIndex();
  }

  void updateTaskIndex(int index) {
    _taskRuntimeDatasource.updateTaskTabIndex(index);
  }
}
