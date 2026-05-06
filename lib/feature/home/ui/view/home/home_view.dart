import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/feature/book/ui/view/book_list_view.dart';
import 'package:tele_book/feature/home/store/home_store.dart';
import 'package:tele_book/feature/task/ui/view/task_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<HomeStore>();

    return Scaffold(
      body: IndexedStack(
        index: store.tabIndex,
        children: [BookListView(), TaskView()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: store.tabIndex,
        onTap: (index) => store.updateTabIndex(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '书籍'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: '任务'),
        ],
      ),
    );
  }
}
