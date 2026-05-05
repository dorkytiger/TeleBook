import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tele_book/feature/home/repository/home_repository.dart';

class HomeStore extends ChangeNotifier {
  final HomeRepository _homeRepository;
  int tabIndex = 0;
  late final StreamSubscription<int> _subscription;

  HomeStore(this._homeRepository) {
    _subscription = _homeRepository.watchTabIndex().listen((index) {
      tabIndex = index;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void updateTabIndex(int index) {
    _homeRepository.updateTabIndex(index);
  }
}
