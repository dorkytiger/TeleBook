import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tele_book/feature/task/repository/task_repository.dart';

class TaskStore extends ChangeNotifier {
  final TaskRepository _taskRepository;

  int _taskTabIndex = 0;

  int get taskTabIndex => _taskTabIndex;

  TaskStore(this._taskRepository) {
    _taskRepository.watchTaskIndex().listen((index) {
      _taskTabIndex = index;
      notifyListeners();
    });
  }

  void updateTaskTabIndex(int index) {
    _taskRepository.updateTaskIndex(index);
  }
}
