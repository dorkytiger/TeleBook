import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tele_book/feature/download/datasource/runtime/download_runtime_datasource.dart';
import 'package:tele_book/feature/home/datasource/runtime/home_runtime_datasource.dart';
import 'package:tele_book/feature/task/datasource/runtime/task_runtime_datasource.dart';

List<SingleChildWidget> createDatasourceDI() {
  return [
    Provider(create: (context) => HomeRuntimeDatasource()),
    Provider(create: (context) => TaskRuntimeDatasource()),
    Provider(create: (context) => DownloadRuntimeDatasource()),
  ];
}
