import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tele_book/feature/download/datasource/runtime/download_runtime_datasource.dart';

List<SingleChildWidget> createDatasourceDI() {
  return [

    Provider(create: (context) => DownloadRuntimeDatasource()),
  ];
}
