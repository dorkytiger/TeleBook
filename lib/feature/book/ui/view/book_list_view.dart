import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/book/store/book_store.dart';

class BookListView extends StatefulWidget {
  const BookListView({super.key});

  @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 监听滚动，当接近底部时加载更多
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      // 距离底部 200 像素时触发加载
      if (currentScroll >= maxScroll - 200) {
        context.read<BookStore>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<BookStore>().search(value.isEmpty ? null : value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('书籍'), elevation: 0),
      body: Consumer<BookStore>(
        builder: (context, store, _) {
          return Column(
            children: [
              // 搜索框
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '搜索书籍...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              // 书籍列表
              Expanded(
                child: store.books.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.library_books_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '暂无书籍',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: _scrollController,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemCount: store.books.length + (store.hasMore ? 1 : 0),
                        // +1 用于加载更多按钮/指示器
                        itemBuilder: (context, index) {
                          // 最后一项：加载更多或加载中指示器
                          if (index == store.books.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: store.isLoading
                                    ? const SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : ElevatedButton.icon(
                                        onPressed: () => store.loadMore(),
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('加载更多'),
                                      ),
                              ),
                            );
                          }

                          final book = store.books[index];
                          final pageCount = book.book.localSubPaths.length;

                          return GestureDetector(
                            onTap: () {
                              context.push(AppRoute.bookPage, extra: book.book);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      height: 64,
                                      width: 64,
                                      fit: BoxFit.cover,
                                      File(book.coverImagePath),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(book.book.name),
                                      subtitle: Text('共 $pageCount 页'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
