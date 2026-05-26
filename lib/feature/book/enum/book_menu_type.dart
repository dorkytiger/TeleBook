import 'package:flutter/material.dart';

/// 顶部菜单（排序方式 + 布局切换）
enum BookTopMenuType {
  asc(icon: Icons.arrow_upward, title: '升序'),
  desc(icon: Icons.arrow_downward, title: '降序'),
  name(icon: Icons.sort_by_alpha, title: '按书名'),
  lastCreatedAt(icon: Icons.access_time, title: '按添加时间'),
  list(icon: Icons.view_list, title: '列表视图'),
  grid(icon: Icons.grid_view, title: '网格视图');

  const BookTopMenuType({required this.icon, required this.title});

  final IconData icon;
  final String title;
}

/// 单本书条目菜单
enum BookItemMenuType {
  edit(icon: Icons.edit, title: '编辑'),
  export(icon: Icons.move_to_inbox, title: '导出'),
  delete(icon: Icons.delete, title: '删除');

  const BookItemMenuType({required this.icon, required this.title});

  final IconData icon;
  final String title;
}

