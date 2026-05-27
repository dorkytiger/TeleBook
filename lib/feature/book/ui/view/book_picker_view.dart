import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/ui/provider/book_provider.dart';

class BookPickerView extends ConsumerStatefulWidget {
  final Set<int> disabledBookIds;

  const BookPickerView({
    super.key,
    this.disabledBookIds = const <int>{},
  });

  @override
  ConsumerState<BookPickerView> createState() => _BookPickerViewState();
}

class _BookPickerViewState extends ConsumerState<BookPickerView> {
  final Set<int> _selectedBookIds = <int>{};
  final TextEditingController _searchController = TextEditingController();
  String _keyword = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleBook(int bookId) {
    if (widget.disabledBookIds.contains(bookId)) return;
    setState(() {
      if (_selectedBookIds.contains(bookId)) {
        _selectedBookIds.remove(bookId);
      } else {
        _selectedBookIds.add(bookId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(title: Text("选择书籍")),
      body: asyncState.when(
        data: (books) {
          final filteredBooks = books.where((book) {
            if (_keyword.isEmpty) return true;
            return book.name.toLowerCase().contains(_keyword.toLowerCase());
          }).toList();

          if (filteredBooks.isEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: '搜索书名',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _keyword = value.trim();
                      });
                    },
                  ),
                ),
                const Expanded(child: Center(child: Text('无匹配书籍'))),
              ],
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: '搜索书名',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _keyword = value.trim();
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredBooks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
                    final isDisabled = widget.disabledBookIds.contains(book.id);
                    final isSelected = isDisabled || _selectedBookIds.contains(book.id);
                    final coverPath = book.localSubPaths.isNotEmpty
                        ? GlobalConfig.resolveBookPath(book.localSubPaths.first)
                        : '';

                    return ListTile(
                      onTap: () => _toggleBook(book.id),
                      leading: coverPath.isEmpty
                          ? Container(
                              width: 64,
                              height: 64,
                              color: Colors.grey.shade300,
                              child: Icon(
                                Icons.menu_book_outlined,
                                color: Colors.grey.shade600,
                              ),
                            )
                          : LocalImageWidget(imagePath: coverPath),
                      title: Text(
                        book.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        isDisabled
                            ? '已在当前收藏夹中'
                            : '共 ${book.localSubPaths.length} 页',
                      ),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: isDisabled ? null : (_) => _toggleBook(book.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        error: (e, st) => Center(
          child: CustomErrorWidget(errorMessage: e.toString(), stackTrace: st),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: asyncState.when(
        data: (books) {
          final selectedBooks = books
              .where((book) => _selectedBookIds.contains(book.id))
              .toList();

          return SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton(
              onPressed: selectedBooks.isEmpty
                  ? null
                  : () {
                      context.pop<List<BookTableData>>(selectedBooks);
                    },
              child: Text('确认选择 (${selectedBooks.length})'),
            ),
          );
        },
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
      ),
    );
  }
}
