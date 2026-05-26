import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/book/enum/book_menu_type.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';
import 'package:tele_book/feature/book/model/state/book_list_state.dart';
import 'package:tele_book/feature/book/ui/provider/book_provider.dart';
import 'package:tele_book/feature/download/ui/provider/download_provider.dart';
import 'package:tele_book/feature/export/ui/view/export_batch_form_view.dart';
import 'package:tele_book/feature/export/ui/view/export_single_form_view.dart';

// ── 根页面 ─────────────────────────────────────────────────────

class BookListView extends ConsumerStatefulWidget {
  const BookListView({super.key});

  @override
  ConsumerState<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends ConsumerState<BookListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(bookListProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookState = ref.watch(bookListProvider);
    final isSelectionMode = bookState.value?.isSelectionMode ?? false;
    final layout = bookState.value?.layout ?? BookLayout.list;

    return PopScope(
      canPop: !isSelectionMode,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && isSelectionMode) {
          ref.read(bookListProvider.notifier).exitSelectionMode();
        }
      },
      child: Scaffold(
        appBar: isSelectionMode
            ? _buildSelectionAppBar(context)
            : _buildNormalAppBar(context),
        body: bookState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('加载失败: $e')),
          data: (state) {
            if (state.bookVos.isEmpty) return _buildEmpty();
            return layout == BookLayout.list
                ? _BookListContent(
                    bookVos: state.bookVos,
                    isLoadingMore: state.isLoadingMore,
                    scrollController: _scrollController,
                  )
                : _BookGridContent(
                    bookVos: state.bookVos,
                    isLoadingMore: state.isLoadingMore,
                    scrollController: _scrollController,
                  );
          },
        ),
        bottomNavigationBar:
            isSelectionMode ? _buildSelectionBottomBar(context) : null,
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
          Text('暂无书籍',
              style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ],
      ),
    );
  }

  AppBar _buildNormalAppBar(BuildContext context) {
    final bookVos =
        ref.watch(bookListProvider.select((s) => s.value?.bookVos ?? []));
    final taskCount = ref.watch(downloadTasksProvider).value?.length ?? 0;
    final state = ref.watch(bookListProvider).value;

    return AppBar(
      title: const Text('书籍'),
      elevation: 0,
      actions: [
        SearchAnchor(
          builder: (context, controller) => IconButton(
            onPressed: controller.openView,
            icon: const Icon(Icons.search),
          ),
          suggestionsBuilder: (context, searchController) {
            final query = searchController.text.toLowerCase();
            final results =
                bookVos.where((vo) => vo.book.name.toLowerCase().contains(query));
            return results.map(
              (vo) => ListTile(
                leading: LocalImageWidget(imagePath: vo.coverImagePath),
                title: Text(vo.book.name),
                onTap: () {
                  searchController.closeView(vo.book.name);
                  context.push(AppRoute.bookPage, extra: vo.book);
                },
              ),
            );
          },
        ),
        if (taskCount > 0)
          IconButton(
            onPressed: () => context.push(AppRoute.download),
            icon: Badge(
              label: Text('$taskCount'),
              child: const Icon(Icons.download),
            ),
          ),
        IconButton(onPressed: (){
            context.push(AppRoute.parseForm);
        }, icon: const Icon(Icons.add)),
        _buildTopMenuButton(context, state),
      ],
    );
  }

  AppBar _buildSelectionAppBar(BuildContext context) {
    final selectedCount = ref.watch(
      bookListProvider.select((s) => s.value?.selectedBookIds.length ?? 0),
    );
    final notifier = ref.read(bookListProvider.notifier);

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: notifier.exitSelectionMode,
      ),
      title: Text('已选 $selectedCount 本'),
      actions: [
        TextButton(onPressed: notifier.selectAll, child: const Text('全选')),
      ],
    );
  }

  Widget _buildSelectionBottomBar(BuildContext context) {
    final selectedBooks = ref.watch(
      bookListProvider.select((s) => s.value?.selectedBooks ?? []),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: selectedBooks.isNotEmpty
            ? Row(
                children: [
                  IconButton(
                    tooltip: '导出选中',
                    onPressed: () => _onExportSelected(context),
                    icon: Icon(Icons.move_to_inbox,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  IconButton(
                    tooltip: '删除选中',
                    onPressed: () => _deleteSelected(context),
                    icon: Icon(Icons.delete,
                        color: Theme.of(context).colorScheme.error),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildTopMenuButton(BuildContext context, BookListState? state) {
    return PopupMenuButton<BookTopMenuType>(
      onSelected: (type) => _onTopMenuSelected(type),
      itemBuilder: (context) => BookTopMenuType.values.map((type) {
        return PopupMenuItem<BookTopMenuType>(
          value: type,
          child: Row(
            children: [
              Icon(type.icon, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(type.title),
              const SizedBox(width: 8),
              if (type == BookTopMenuType.asc &&
                  state?.sort?.order == BookSortOrder.asc)
                const Icon(Icons.check, size: 16),
              if (type == BookTopMenuType.desc &&
                  state?.sort?.order == BookSortOrder.desc)
                const Icon(Icons.check, size: 16),
              if (type == BookTopMenuType.name &&
                  state?.sort?.type == BookSortType.title)
                const Icon(Icons.check, size: 16),
              if (type == BookTopMenuType.lastCreatedAt &&
                  state?.sort?.type == BookSortType.lastCreatedAt)
                const Icon(Icons.check, size: 16),
              if (type == BookTopMenuType.list &&
                  state?.layout == BookLayout.list)
                const Icon(Icons.check, size: 16),
              if (type == BookTopMenuType.grid &&
                  state?.layout == BookLayout.grid)
                const Icon(Icons.check, size: 16),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _onTopMenuSelected(BookTopMenuType type) {
    final notifier = ref.read(bookListProvider.notifier);
    final current = ref.read(bookListProvider).value;
    final currentSort = current?.sort ??
        BookSort(order: BookSortOrder.desc, type: BookSortType.lastCreatedAt);

    switch (type) {
      case BookTopMenuType.asc:
        notifier.updateSort(currentSort.copyWith(order: BookSortOrder.asc));
      case BookTopMenuType.desc:
        notifier.updateSort(currentSort.copyWith(order: BookSortOrder.desc));
      case BookTopMenuType.name:
        notifier.updateSort(currentSort.copyWith(type: BookSortType.title));
      case BookTopMenuType.lastCreatedAt:
        notifier
            .updateSort(currentSort.copyWith(type: BookSortType.lastCreatedAt));
      case BookTopMenuType.list:
        if (current?.layout != BookLayout.list) notifier.toggleLayout();
      case BookTopMenuType.grid:
        if (current?.layout != BookLayout.grid) notifier.toggleLayout();
    }
  }

  void _onExportSelected(BuildContext context) {
    final selectedBooks =
        ref.read(bookListProvider).value?.selectedBooks ?? [];
    if (selectedBooks.isEmpty) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) =>
          ExportBatchFormView(books: selectedBooks.map((v) => v.book).toList()),
    ));
  }

  Future<void> _deleteSelected(BuildContext context) async {
    final count =
        ref.read(bookListProvider).value?.selectedBookIds.length ?? 0;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('将删除选中的 $count 本书籍，删除后不可恢复，是否继续？'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('删除', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(bookListProvider.notifier).deleteSelected();
    }
  }
}

// ── 列表布局 ───────────────────────────────────────────────────

class _BookListContent extends ConsumerWidget {
  final List<BookListItemVo> bookVos;
  final bool isLoadingMore;
  final ScrollController scrollController;

  const _BookListContent({
    required this.bookVos,
    required this.isLoadingMore,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = bookVos.length + (isLoadingMore ? 1 : 0);
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == bookVos.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        return _BookListTile(book: bookVos[index]);
      },
    );
  }
}

class _BookListTile extends ConsumerWidget {
  final BookListItemVo book;

  const _BookListTile({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectionMode = ref.watch(
        bookListProvider.select((s) => s.value?.isSelectionMode ?? false));
    final isSelected = ref.watch(bookListProvider.select(
        (s) => s.value?.selectedBookIds.contains(book.book.id) ?? false));
    final notifier = ref.read(bookListProvider.notifier);

    return GestureDetector(
      onTap: () => isSelectionMode
          ? notifier.toggleSelection(book.book.id)
          : context.push(AppRoute.bookPage, extra: book.book),
      onLongPress: () {
        if (!isSelectionMode) notifier.enterSelectionMode(book.book);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (isSelectionMode)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Checkbox(
                  value: isSelected,
                  onChanged: (_) => notifier.toggleSelection(book.book.id),
                ),
              ),
            LocalImageWidget(imagePath: book.coverImagePath),
            Expanded(
              child: ListTile(
                title: Text(book.book.name,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text('共 ${book.book.localSubPaths.length} 页'),
              ),
            ),
            if (!isSelectionMode) _buildItemMenu(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildItemMenu(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<BookItemMenuType>(
      onSelected: (type) => _onItemSelected(context, ref, type),
      itemBuilder: (context) => BookItemMenuType.values
          .map((type) => PopupMenuItem(
                value: type,
                child: Row(children: [
                  Icon(type.icon, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(type.title),
                ]),
              ))
          .toList(),
    );
  }

  void _onItemSelected(
      BuildContext context, WidgetRef ref, BookItemMenuType type) {
    switch (type) {
      case BookItemMenuType.export:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ExportSingleFormView(book: book.book)));
      case BookItemMenuType.delete:
        _confirmDelete(context, ref);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('删除《${book.book.name}》后不可恢复，是否继续？'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('删除', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await ref.read(bookListProvider.notifier).deleteBook(book.book.id);
    }
  }
}

// ── 网格布局 ───────────────────────────────────────────────────

class _BookGridContent extends ConsumerWidget {
  final List<BookListItemVo> bookVos;
  final bool isLoadingMore;
  final ScrollController scrollController;

  const _BookGridContent({
    required this.bookVos,
    required this.isLoadingMore,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final gridDelegate = isTablet
        ? const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65,
          )
        : const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65,
          );

    final itemCount = bookVos.length + (isLoadingMore ? 1 : 0);
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(12),
      gridDelegate: gridDelegate,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == bookVos.length) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        return _BookGridTile(book: bookVos[index]);
      },
    );
  }
}

class _BookGridTile extends ConsumerWidget {
  final BookListItemVo book;

  const _BookGridTile({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectionMode = ref.watch(
        bookListProvider.select((s) => s.value?.isSelectionMode ?? false));
    final isSelected = ref.watch(bookListProvider.select(
        (s) => s.value?.selectedBookIds.contains(book.book.id) ?? false));
    final notifier = ref.read(bookListProvider.notifier);

    return GestureDetector(
      onTap: () => isSelectionMode
          ? notifier.toggleSelection(book.book.id)
          : context.push(AppRoute.bookPage, extra: book.book),
      onLongPress: () => isSelectionMode
          ? _showItemMenu(context, ref)
          : notifier.enterSelectionMode(book.book),
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
              Text(book.book.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12)),
              Text('${book.book.localSubPaths.length} 页',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
          if (isSelectionMode)
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
                      color: Theme.of(context).colorScheme.primary, width: 2),
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

  void _showItemMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: BookItemMenuType.values
              .map((type) => ListTile(
                    leading: Icon(type.icon),
                    title: Text(type.title),
                    onTap: () {
                      Navigator.pop(context);
                      _onItemSelected(context, ref, type);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _onItemSelected(
      BuildContext context, WidgetRef ref, BookItemMenuType type) {
    switch (type) {
      case BookItemMenuType.export:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ExportSingleFormView(book: book.book)));
      case BookItemMenuType.delete:
        _confirmDelete(context, ref);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('删除《${book.book.name}》后不可恢复，是否继续？'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('删除', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await ref.read(bookListProvider.notifier).deleteBook(book.book.id);
    }
  }
}
