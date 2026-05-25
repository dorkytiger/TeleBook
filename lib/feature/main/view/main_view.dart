import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/feature/book/ui/view/book_list_view.dart';
import 'package:tele_book/feature/collection/ui/view/collection_view.dart';
import 'package:tele_book/feature/main/viewmodel/main_viewmodel.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainViewmodel(),
      child: const _MainContent(),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainViewmodel>();
    return Scaffold(
      body: IndexedStack(
        index: vm.currentIndex,
        children: [BookListView(), CollectionView()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: vm.currentIndex,
        onTap: (index) => vm.onTabChange(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "书籍"),
          BottomNavigationBarItem(icon: Icon(Icons.collections), label: "收藏夹"),
        ],
      ),
    );
  }
}
