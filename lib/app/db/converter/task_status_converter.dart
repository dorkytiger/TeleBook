import 'package:background_downloader/background_downloader.dart';
import 'package:drift/drift.dart';

class TaskStatusConverter extends TypeConverter<TaskStatus, String>
    with JsonTypeConverter<TaskStatus, String> {
  const TaskStatusConverter();

  @override
  TaskStatus fromSql(String fromDb) {
    return TaskStatus.values
        .firstWhere((element) => element.toString() == fromDb);
  }

  @override
  String toSql(TaskStatus value) {
    return value.toString();
  }
}
