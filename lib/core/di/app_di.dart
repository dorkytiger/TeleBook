import 'package:provider/single_child_widget.dart';
import 'package:tele_book/core/di/core_di.dart';
import 'package:tele_book/core/di/datasource_di.dart';
import 'package:tele_book/core/di/repository_di.dart';
import 'package:tele_book/core/di/service_di.dart';
import 'package:tele_book/core/di/store_di.dart';

List<SingleChildWidget> createAppDI() {
  return [
    ...createCoreDI(),
    ...createDatasourceDI(),
    ...createRepositoryDI(),
    ...createServiceDI(),
    ...createStoreDI(),
  ];
}
