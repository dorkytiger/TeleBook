import 'dart:async';

class HomeRuntimeDatasource {
  int tabIndex = 0;
  final _tabIndexController = StreamController<int>.broadcast();

  Stream<int> watchTabIndex() {
    return _tabIndexController.stream;
  }

  void updateTabIndex(int index) {
    tabIndex = index;
    _tabIndexController.add(index);
  }

  void dispose() {
    _tabIndexController.close();
  }
}
