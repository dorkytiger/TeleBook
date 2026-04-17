import 'package:flutter/cupertino.dart';

class HomeController extends ChangeNotifier {
  int selectedIndex;
  int? taskTabIndex; // 任务页面的 tab 索引（0=下载, 1=导入, 2=导出）

  HomeController({
    this.selectedIndex = 0,
    this.taskTabIndex,
  });

  void onTabSelected(int index) {
    if (index != selectedIndex) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  /// 设置任务页面的子 tab（下载、导入、导出）
  void setTaskTab(int index) {
    taskTabIndex = index;
    notifyListeners();
  }
}
