import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/f_adaptive_dialog.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/book/enum/book_menu_type.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';
import 'package:tele_book/feature/book/model/state/book_list_state.dart';
import 'package:tele_book/feature/book/ui/provider/book_provider.dart';
import 'package:tele_book/feature/export/ui/view/export_batch_form_view.dart';
import 'package:tele_book/feature/export/ui/view/export_single_form_view.dart';

// ── 根页面 ─────────────────────────────────────────────────────

class BookListView extends ConsumerStatefulWidget {
  const BookListView({super.key});

  @override
  ConsumerState<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends ConsumerState<BookListView> {
  bool _deleting = false;

  @override
  Widget build(BuildContext context) {
    final bookState = ref.watch(bookListProvider);
    final uiState = ref.watch(bookListUiProvider);
    final isSelectionMode = uiState.isSelectionMode;
    final layout = uiState.layout;

    return PopScope(
      canPop: !isSelectionMode,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && isSelectionMode) {
          ref.read(bookListProvider.notifier).exitSelectionMode();
        }
      },
      child: FScaffold(
        childPad: false,
        header: isSelectionMode
            ? _buildSelectionAppBar(context)
            : _buildNormalAppBar(context),
        footer: isSelectionMode ? _buildSelectionBottomBar(context) : null,
        child: bookState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('加载失败: $e')),
          data: (state) {
            if (state.bookVos.isEmpty) return _buildEmpty();
            return layout == BookLayout.list
                ? _BookListContent(bookVos: state.bookVos)
                : _BookGridContent(bookVos: state.bookVos);
          },
        ),
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

  FHeader _buildNormalAppBar(BuildContext context) {
    final bookVos = ref.watch(
      bookListProvider.select((s) => s.value?.bookVos ?? []),
    );
    final state = ref.watch(bookListProvider).value;

    return FHeader(
      title: const Text('书籍'),
      suffixes: [
        SearchAnchor(
          builder: (context, controller) => FHeaderAction(
            onPress: controller.openView,
            icon: const Icon(Icons.search),
          ),
          suggestionsBuilder: (context, searchController) {
            final query = searchController.text.toLowerCase();
            final results = bookVos.where(
              (vo) => vo.book.name.toLowerCase().contains(query),
            );
            return results.map(
              (vo) => FItem(
                prefix: LocalImageWidget(imagePath: vo.coverImagePath),
                title: Text(vo.book.name),
                onPress: () {
                  searchController.closeView(vo.book.name);
                  context.push(AppRoute.bookPage, extra: vo.book);
                },
              ),
            );
          },
        ),
        FHeaderAction(
          onPress: () {
            context.push(AppRoute.parseForm);
          },
          icon: const Icon(Icons.add),
        ),
        _buildTopMenuButton(context, state),
      ],
    );
  }

  FHeader _buildSelectionAppBar(BuildContext context) {
    final selectedCount = ref.watch(
      bookListUiProvider.select((s) => s.selectedBookIds.length),
    );
    final notifier = ref.read(bookListProvider.notifier);

    return FHeader.nested(
      prefixes: [
        FHeaderAction(
          icon: const Icon(Icons.close),
          onPress: notifier.exitSelectionMode,
        ),
      ],
      title: Text('已选 $selectedCount 本'),
      suffixes: [
        FHeaderAction(onPress: notifier.selectAll, icon: const Text('全选')),
      ],
    );
  }

  Widget _buildSelectionBottomBar(BuildContext context) {
    final selectedIds = ref.watch(
      bookListUiProvider.select((s) => s.selectedBookIds),
    );

    return Padding(
      padding: .all(8),
      child: selectedIds.isNotEmpty
          ? Row(
              children: [
                FButton(
                  variant: .outline,
                  onPress: () => _onExportSelected(context),
                  prefix: Icon(FLucideIcons.move),
                  child: Text("批量导出"),
                ),
                SizedBox(width: 8),
                FButton(
                  variant: .destructive,
                  onPress: _deleting ? null : () => _deleteSelected(context),
                  prefix: _deleting ? null : Icon(FLucideIcons.trash),
                  child: _deleting
                      ? const FCircularProgress()
                      : const Text("批量删除"),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildTopMenuButton(BuildContext context, BookListState? state) {
    return FPopoverMenu(
      autofocus: true,
      menuAnchor: .topRight,
      childAnchor: .bottomRight,
      menu: [
        .group(
          children: [
            .item(
              prefix: const Icon(FLucideIcons.arrowUp),
              title: const Text('升序'),
              suffix: state?.sort?.order == BookSortOrder.asc
                  ? const Icon(FLucideIcons.check, size: 16)
                  : null,
              onPress: () => _onTopMenuSelected(BookTopMenuType.asc),
            ),
            .item(
              prefix: const Icon(FLucideIcons.arrowDown),
              title: const Text('降序'),
              suffix: state?.sort?.order == BookSortOrder.desc
                  ? const Icon(FLucideIcons.check, size: 16)
                  : null,
              onPress: () => _onTopMenuSelected(BookTopMenuType.desc),
            ),
          ],
        ),
        .group(
          children: [
            .item(
              prefix: const Icon(FLucideIcons.type),
              title: const Text('按书名'),
              suffix: state?.sort?.type == BookSortType.title
                  ? const Icon(FLucideIcons.check, size: 16)
                  : null,
              onPress: () => _onTopMenuSelected(BookTopMenuType.name),
            ),
            .item(
              prefix: const Icon(FLucideIcons.clock),
              title: const Text('按添加时间'),
              suffix: state?.sort?.type == BookSortType.lastCreatedAt
                  ? const Icon(FLucideIcons.check, size: 16)
                  : null,
              onPress: () => _onTopMenuSelected(BookTopMenuType.lastCreatedAt),
            ),
          ],
        ),
        .group(
          children: [
            .item(
              prefix: const Icon(FLucideIcons.list),
              title: const Text('列表视图'),
              suffix: ref.watch(bookListUiProvider).layout == BookLayout.list
                  ? const Icon(FLucideIcons.check, size: 16)
                  : null,
              onPress: () => _onTopMenuSelected(BookTopMenuType.list),
            ),
            .item(
              prefix: const Icon(FLucideIcons.layoutGrid),
              title: const Text('网格视图'),
              suffix: ref.watch(bookListUiProvider).layout == BookLayout.grid
                  ? const Icon(FLucideIcons.check, size: 16)
                  : null,
              onPress: () => _onTopMenuSelected(BookTopMenuType.grid),
            ),
          ],
        ),
      ],
      builder: (_, controller, _) => FHeaderAction(
        icon: const Icon(FLucideIcons.ellipsis),
        onPress: controller.toggle,
      ),
    );
  }

  void _onTopMenuSelected(BookTopMenuType type) {
    final notifier = ref.read(bookListProvider.notifier);
    final current = ref.read(bookListProvider).value;
    final currentLayout = ref.read(bookListUiProvider).layout;
    final currentSort =
        current?.sort ??
        BookSort(order: BookSortOrder.desc, type: BookSortType.lastCreatedAt);

    switch (type) {
      case BookTopMenuType.asc:
        notifier.updateSort(currentSort.copyWith(order: BookSortOrder.asc));
      case BookTopMenuType.desc:
        notifier.updateSort(currentSort.copyWith(order: BookSortOrder.desc));
      case BookTopMenuType.name:
        notifier.updateSort(currentSort.copyWith(type: BookSortType.title));
      case BookTopMenuType.lastCreatedAt:
        notifier.updateSort(
          currentSort.copyWith(type: BookSortType.lastCreatedAt),
        );
      case BookTopMenuType.list:
        if (currentLayout != BookLayout.list) notifier.toggleLayout();
      case BookTopMenuType.grid:
        if (currentLayout != BookLayout.grid) notifier.toggleLayout();
    }
  }

  void _onExportSelected(BuildContext context) {
    final selectedIds = ref.read(bookListUiProvider).selectedBookIds;
    final bookVos = ref.read(bookListProvider).value?.bookVos ?? [];
    final selectedBooks = bookVos
        .where((v) => selectedIds.contains(v.book.id))
        .toList();
    if (selectedBooks.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExportBatchFormView(
          books: selectedBooks.map((v) => v.book).toList(),
        ),
      ),
    );
  }

  Future<void> _deleteSelected(BuildContext context) async {
    final count = ref.read(bookListUiProvider).selectedBookIds.length;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (context, style, animate) => FAdaptiveDialog(
        title: const Text('确认删除'),
        body: Text('将删除选中的 $count 本书籍，删除后不可恢复，是否继续？'),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            onPress: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
          FButton(
            variant: .outline,
            size: .sm,
            onPress: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
        ],
      ),
    );

    final rootContext = Navigator.of(context).context;
    if (confirmed == true && context.mounted) {
      setState(() => _deleting = true);
      try {
        await ref.read(bookListProvider.notifier).deleteSelected();
        if (mounted) {
          showFToast(context: rootContext, title: Text("删除成功"));
        }
      } finally {
        if (mounted) setState(() => _deleting = false);
      }
    }
  }
}

// ── 列表布局 ───────────────────────────────────────────────────

class _BookListContent extends ConsumerWidget {
  final List<BookListItemVo> bookVos;

  const _BookListContent({required this.bookVos});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectionMode = ref.watch(
      bookListUiProvider.select((s) => s.isSelectionMode),
    );
    return isSelectionMode ? _selectList(ref) : _listView(ref);
  }

  Widget _listView(WidgetRef ref) {
    final notifier = ref.read(bookListProvider.notifier);
    return FItemGroup.builder(
      count: bookVos.length,
      itemBuilder: (context, index) {
        final bookVo = bookVos[index];
        return FTile(
          title: Text(bookVo.book.name),
          prefix: LocalImageWidget(imagePath: bookVo.coverImagePath),
          subtitle: Text('共 ${bookVo.book.localSubPaths.length} 页'),
          suffix: FPopoverMenu.tiles(
            style: .delta(),
            menu: [
              .group(
                children: [
                  for (var item in BookItemMenuType.values)
                    .tile(
                      variant: item == BookItemMenuType.delete
                          ? .destructive
                          : .primary,
                      title: Text(item.title),
                      prefix: Icon(item.icon),
                      onPress: () {
                        _onItemSelected(context, ref, item, bookVo);
                      },
                    ),
                ],
              ),
            ],
            builder: (context, controller, child) {
              return FButton.icon(
                variant: .ghost,
                child: Icon(FLucideIcons.moreHorizontal),
                onPress: () {
                  controller.show();
                },
              );
            },
          ),
          onPress: () {
            context.push(AppRoute.bookPage, extra: bookVo.book);
          },
          onLongPress: () {
            notifier.enterSelectionMode(bookVo.book);
          },
        );
      },
    );
  }

  Widget _selectList(WidgetRef ref) {
    final notifier = ref.read(bookListProvider.notifier);
    final selectedIds = ref.watch(
      bookListUiProvider.select((s) => s.selectedBookIds),
    );
    return FSelectTileGroup.builder(
      control: FMultiValueControl<int>.managed(
        initial: selectedIds,
        onChange: (value) {
          notifier.toggleSelections(value);
        },
      ),
      count: bookVos.length,
      tileBuilder: (context, index) {
        final bookVo = bookVos[index];
        return .suffix(
          title: Text(bookVo.book.name),
          prefix: LocalImageWidget(imagePath: bookVo.coverImagePath),
          value: bookVo.book.id,
        );
      },
    );
  }

  void _onItemSelected(
    BuildContext context,
    WidgetRef ref,
    BookItemMenuType type,
    BookListItemVo bookVo,
  ) {
    switch (type) {
      case BookItemMenuType.edit:
        context.push(AppRoute.bookForm, extra: bookVo.book);
      case BookItemMenuType.export:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ExportSingleFormView(book: bookVo.book),
          ),
        );
      case BookItemMenuType.delete:
        _confirmDelete(context, ref, bookVo);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    BookListItemVo bookVo,
  ) async {
    final ok = await showFDialog<bool>(
      context: context,
      builder: (context, style, animate) => FAdaptiveDialog(
        title: Text('确认删除'),
        body: Text('删除《${bookVo.book.name}》后不可恢复，是否继续？'),
        actions: [
          FButton(
            size: .sm,
            variant: .destructive,
            child: const Text('确定'),
            onPress: () => Navigator.of(context).pop(true),
          ),
          FButton(
            variant: .outline,
            size: .sm,
            child: const Text('取消'),
            onPress: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
    final rootContext = Navigator.of(context).context;

    if (ok == true) {
      await _runDeleteWithProgress(context, () async {
        await ref.read(bookListProvider.notifier).deleteBook(bookVo.book.id);
      });
      if (context.mounted) {
        showFToast(context: rootContext, title: Text("删除成功"));
      }
    }
  }
}

// ── 网格布局 ───────────────────────────────────────────────────

class _BookGridContent extends ConsumerWidget {
  final List<BookListItemVo> bookVos;

  const _BookGridContent({required this.bookVos});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 240,
      ),
      itemCount: bookVos.length,
      itemBuilder: (context, index) {
        return _BookGridTile(bookVo: bookVos[index]);
      },
    );
  }
}

class _BookGridTile extends ConsumerWidget {
  final BookListItemVo bookVo;

  const _BookGridTile({required this.bookVo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectionMode = ref.watch(
      bookListUiProvider.select((s) => s.isSelectionMode),
    );
    final isSelected = ref.watch(
      bookListUiProvider.select(
        (s) => s.selectedBookIds.contains(bookVo.book.id),
      ),
    );
    final notifier = ref.read(bookListProvider.notifier);

    return GestureDetector(
      onTap: () => isSelectionMode
          ? notifier.toggleSelection(bookVo.book.id)
          : context.push(AppRoute.bookPage, extra: bookVo.book),
      onLongPress: () => isSelectionMode
          ? _showItemMenu(context, ref)
          : notifier.enterSelectionMode(bookVo.book),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: bookVo.coverImagePath.isNotEmpty
                      ? Image.file(
                          File(bookVo.coverImagePath),
                          width: double.infinity,
                          fit: BoxFit.cover,
                          cacheWidth: 300,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
              ),
              const SizedBox(height: 4),
              FItem(
                title: Text(bookVo.book.name, maxLines: 2),
                subtitle: Text('${bookVo.book.localSubPaths.length} 页'),
                suffix: FPopoverMenu.tiles(
                  style: .delta(),
                  menu: [
                    .group(
                      children: [
                        for (var item in BookItemMenuType.values)
                          .tile(
                            variant: item == BookItemMenuType.delete
                                ? .destructive
                                : .primary,
                            title: Text(item.title),
                            prefix: Icon(item.icon),
                            onPress: () {
                              _onItemSelected(context, ref, item);
                            },
                          ),
                      ],
                    ),
                  ],
                  builder: (context, controller, child) {
                    return FButton.icon(
                      variant: .ghost,
                      child: Icon(FLucideIcons.moreHorizontal),
                      onPress: () {
                        controller.show();
                      },
                    );
                  },
                ),
              ),
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

  void _showItemMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: BookItemMenuType.values
              .map(
                (type) => ListTile(
                  leading: Icon(type.icon),
                  title: Text(type.title),
                  onTap: () {
                    Navigator.pop(context);
                    _onItemSelected(context, ref, type);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _onItemSelected(
    BuildContext context,
    WidgetRef ref,
    BookItemMenuType type,
  ) {
    switch (type) {
      case BookItemMenuType.edit:
        context.push(AppRoute.bookForm, extra: bookVo.book);
      case BookItemMenuType.export:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ExportSingleFormView(book: bookVo.book),
          ),
        );
      case BookItemMenuType.delete:
        _confirmDelete(context, ref);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showFDialog<bool>(
      context: context,
      builder: (context, style, animate) => FAdaptiveDialog(
        title: const Text('确认删除'),
        body: Text('删除《${bookVo.book.name}》后不可恢复，是否继续？'),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            onPress: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
          FButton(
            size: .sm,
            variant: .outline,
            onPress: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
        ],
      ),
    );

    final rootContext = Navigator.of(context).context;
    if (ok == true && context.mounted) {
      await _runDeleteWithProgress(context, () async {
        await ref.read(bookListProvider.notifier).deleteBook(bookVo.book.id);
      });
      if (context.mounted) {
        showFToast(context: rootContext, title: Text("删除成功"));
      }
    }
  }
}

/// 删除期间显示全屏模态转圈（首次删除需算快照 hash，可能耗时，给用户明确反馈）。
Future<void> _runDeleteWithProgress(
  BuildContext context,
  Future<void> Function() action,
) async {
  if (!context.mounted) return;
  final navigator = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: FCircularProgress()),
  );
  try {
    await action();
  } finally {
    if (navigator.mounted) {
      navigator.pop();
    }
  }
}
