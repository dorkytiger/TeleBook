import 'package:tele_book/feature/home/datasource/runtime/home_runtime_datasource.dart';

class HomeRepository {
  final HomeRuntimeDatasource _homeRuntimeDatasource;

  HomeRepository(this._homeRuntimeDatasource);

  Stream<int> watchTabIndex() {
    return _homeRuntimeDatasource.watchTabIndex();
  }

  void updateTabIndex(int index) {
    _homeRuntimeDatasource.updateTabIndex(index);
  }
}
