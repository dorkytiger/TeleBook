import 'package:flutter/material.dart';

class MainViewmodel extends ChangeNotifier {
  int currentIndex = 0;

  void onTabChange(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      notifyListeners();
    }
  }
}
