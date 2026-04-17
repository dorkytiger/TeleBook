import 'package:flutter/material.dart';

/// TaskController - 使用 ChangeNotifier 进行状态管理
/// TabController 由外部传入，不再继承 TickerProvider
class TaskController extends ChangeNotifier {
  TabController? _tabController;

  TabController? get tabController => _tabController;

  void initTabController(TickerProvider vsync, {int initialIndex = 0}) {
    _tabController = TabController(
      length: 3,
      vsync: vsync,
      initialIndex: initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}