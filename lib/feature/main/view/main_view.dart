import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/feature/book/ui/view/book_list_view.dart';
import 'package:tele_book/feature/collection/ui/view/collection_view.dart';
import 'package:tele_book/feature/download/ui/view/download_list_view.dart';
import 'package:tele_book/feature/main/provider/main_provider.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainProvider);
    final notifier = ref.read(mainProvider.notifier);
    return Scaffold(
      body: IndexedStack(
        index: state.currentIndex,
        children: [BookListView(), DownloadListView(), CollectionView()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.currentIndex,
        onTap: (index) => notifier.updateCurrentIndex(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "书籍"),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: "下载"),
          BottomNavigationBarItem(icon: Icon(Icons.collections), label: "收藏夹"),
        ],
      ),
    );
  }
}
