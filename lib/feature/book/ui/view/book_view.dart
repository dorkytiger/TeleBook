import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';
import 'package:tele_book/feature/book/model/vo/book_vo.dart';
import 'package:tele_book/feature/book/store/book_store.dart';
import 'package:tele_book/feature/book/ui/viewmodel/book_viewmodel.dart';

import 'package:tele_book/feature/download/store/download_store.dart';

class BookView extends StatelessWidget {
  const BookView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookViewmodel(context.read(), context.read()),
      child: _BookViewContent(),
    );
  }
}

class _BookViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookStore = context.watch<BookStore>();
    final downloadStore = context.watch<DownloadStore>();
    final vm = context.watch<BookViewmodel>();

    return PopScope(
      canPop: !vm.isSelectionMode,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && vm.isSelectionMode) vm.exitSelectionMode();
      },
      child: Scaffold(
        appBar: vm.isSelectionMode
            ? _buildSelectionAppBar(context, vm)
            : _buildNormalAppBar(context, vm, bookStore, downloadStore),
        body: bookStore.books.isEmpty && !bookStore.isLoading
            ? _buildEmpty()
            : vm.layout == BookLayout.list
            ? _BookListView(vm: vm)
            : _BookGridView(vm: vm),
        bottomNavigationBar: vm.isSelectionMode
            ? _buildSelectionBottomBar(context, vm)
            : null,
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('暂无书籍', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ],
      ),
    );
  }

  AppBar _buildNormalAppBar(
    BuildContext context,
    BookViewmodel vm,
    BookStore bookStore,
    DownloadStore downloadStore,
  ) {
    return AppBar(
      title: const Text('书籍'),
      elevation: 0,
      actions: [
        downloadStore.tasks.isNotEmpty
            ? IconButton(
                onPressed: () => context.push(AppRoute.download),
                icon: Badge(
                  label: Text('${downloadStore.tasks.length}'),
                  child: const Icon(Icons.download),
                ),
              )
            : const SizedBox.shrink(),
        _buildTopMenuButton(context, vm, bookStore),
      ],
    );
  }

  AppBar _buildSelectionAppBar(BuildContext context, BookViewmodel vm) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: vm.exitSelectionMode,
      ),
      title: Text('已选 ${vm.selectedBookIds.length} 本'),
      actions: [TextButton(onPressed: vm.selectAll, child: const Text('全选'))],
    );
  }

  Widget _buildSelectionBottomBar(BuildContext context, BookViewmodel vm) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: FilledButton.icon(
          onPressed: vm.selectedBookIds.isEmpty
              ? null
              : () => vm.onExportSelected(context),
          icon: const Icon(Icons.upload_file),
          label: Text(
            vm.selectedBookIds.isEmpty
                ? '请选择书籍'
                : '导出 ${vm.selectedBookIds.length} 本',
          ),
        ),
      ),
    );
  }

  Widget _buildTopMenuButton(
    BuildContext context,
    BookViewmodel vm,
    BookStore bookStore,
  ) {
    return PopupMenuButton<BookTopMenuType>(
      onSelected: (value) => vm.onTopMenuSelected(context, value),
      itemBuilder: (context) => [
        ...BookTopMenuType.values.map((type) {
          return PopupMenuItem<BookTopMenuType>(
            value: type,
            child: Row(
              children: [
                Icon(
                  type.icon,
                  size: 16,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 8),
                Text(type.title),
                const SizedBox(width: 8),
                if (type == BookTopMenuType.asc &&
                    bookStore.sort.order == BookSortOrder.asc)
                  const Icon(Icons.check, size: 16),
                if (type == BookTopMenuType.desc &&
                    bookStore.sort.order == BookSortOrder.desc)
                  const Icon(Icons.check, size: 16),
                if (type == BookTopMenuType.name &&
                    bookStore.sort.type == BookSortType.title)
                  const Icon(Icons.check, size: 16),
                if (type == BookTopMenuType.lastCreatedAt &&
                    bookStore.sort.type == BookSortType.lastCreatedAt)
                  const Icon(Icons.check, size: 16),
                if (type == BookTopMenuType.list &&
                    vm.layout == BookLayout.list)
                  const Icon(Icons.check, size: 16),
                if (type == BookTopMenuType.grid &&
                    vm.layout == BookLayout.grid)
                  const Icon(Icons.check, size: 16),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ── 列表布局 ──────────────────────────────────────────────
class _BookListView extends StatelessWidget {
  final BookViewmodel vm;

  const _BookListView({required this.vm});

  @override
  Widget build(BuildContext context) {
    final bookStore = context.watch<BookStore>();
    final itemCount = bookStore.books.length + (bookStore.isLoading ? 1 : 0);

    return ListView.separated(
      controller: vm.scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == bookStore.books.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        final book = bookStore.books[index];
        return _BookListTile(book: book, vm: vm);
      },
    );
  }
}

class _BookListTile extends StatelessWidget {
  final BookListItemVo book;
  final BookViewmodel vm;

  const _BookListTile({required this.book, required this.vm});

  @override
  Widget build(BuildContext context) {
    final isSelected = vm.selectedBookIds.contains(book.book.id);

    return GestureDetector(
      onTap: () {
        if (vm.isSelectionMode) {
          vm.toggleSelection(book.book.id);
        } else {
          context.push(AppRoute.bookPage, extra: book.book);
        }
      },
      onLongPress: () {
        if (!vm.isSelectionMode) vm.enterSelectionMode(book.book);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (vm.isSelectionMode)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Checkbox(
                  value: isSelected,
                  onChanged: (_) => vm.toggleSelection(book.book.id),
                ),
              ),
            LocalImageWidget(imagePath: book.coverImagePath),
            Expanded(
              child: ListTile(
                title: Text(
                  book.book.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('共 ${book.book.localSubPaths.length} 页'),
              ),
            ),
            if (!vm.isSelectionMode)
              _buildItemMenuButton(context, vm, book.book),
          ],
        ),
      ),
    );
  }

  Widget _buildItemMenuButton(
    BuildContext context,
    BookViewmodel vm,
    BookTableData book,
  ) {
    return PopupMenuButton<BookItemMenuType>(
      onSelected: (value) => vm.onItemMenuSelected(context, value, book),
      itemBuilder: (context) => BookItemMenuType.values
          .map((type) => PopupMenuItem(value: type, child: Text(type.title)))
          .toList(),
    );
  }
}

// ── 网格布局 ──────────────────────────────────────────────
class _BookGridView extends StatelessWidget {
  final BookViewmodel vm;

  const _BookGridView({required this.vm});

  @override
  Widget build(BuildContext context) {
    final bookStore = context.watch<BookStore>();

    return GridView.builder(
      controller: vm.scrollController,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: bookStore.books.length + (bookStore.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == bookStore.books.length) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        final book = bookStore.books[index];
        return _BookGridTile(book: book, vm: vm);
      },
    );
  }
}

class _BookGridTile extends StatelessWidget {
  final BookListItemVo book;
  final BookViewmodel vm;

  const _BookGridTile({required this.book, required this.vm});

  @override
  Widget build(BuildContext context) {
    final isSelected = vm.selectedBookIds.contains(book.book.id);

    return GestureDetector(
      onTap: () {
        if (vm.isSelectionMode) {
          vm.toggleSelection(book.book.id);
        } else {
          context.push(AppRoute.bookPage, extra: book.book);
        }
      },
      onLongPress: () {
        if (vm.isSelectionMode) {
          _showItemMenu(context);
        } else {
          vm.enterSelectionMode(book.book);
        }
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: book.coverImagePath.isNotEmpty
                      ? Image.file(
                          File(book.coverImagePath),
                          width: double.infinity,
                          fit: BoxFit.cover,
                          cacheWidth: 300,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                book.book.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                '${book.book.localSubPaths.length} 页',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
          // 选择模式时显示选中指示器
          if (vm.isSelectionMode)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : const SizedBox(width: 18, height: 18),
              ),
            ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.grey[200],
    child: Icon(Icons.book, color: Colors.grey[400], size: 40),
  );

  void _showItemMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: BookItemMenuType.values
              .map(
                (type) => ListTile(
                  title: Text(type.title),
                  onTap: () {
                    Navigator.pop(context);
                    vm.onItemMenuSelected(context, type, book.book);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
