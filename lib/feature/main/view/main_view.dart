import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
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
    return FScaffold(
      footer: FBottomNavigationBar(
        index: state.currentIndex,
        onChange: (index) => notifier.updateCurrentIndex(index),
        children: [
          FBottomNavigationBarItem(icon: Icon(Icons.book), label: Text("书籍")),
          FBottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: Text("下载"),
          ),
          FBottomNavigationBarItem(
            icon: Icon(Icons.collections),
            label: Text("收藏夹"),
          ),
        ],
      ),
      child: IndexedStack(
        index: state.currentIndex,
        children: [BookListView(), DownloadListView(), CollectionView()],
      ),
    );
  }
}
