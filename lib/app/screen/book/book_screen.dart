import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/store/book_store.dart';
import 'package:tele_book/app/store/collection_store.dart';
import 'package:tele_book/app/store/export_store.dart';
import 'package:tele_book/app/store/mark_store.dart';
import 'package:tele_book/app/util/file_util.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

/// 书籍页面 - 使用 Provider 模式
class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookController(
        bookStore: context.read<BookStore>(),
        markStore: context.read<MarkStore>(),
        collectionStore: context.read<CollectionStore>(),
        exportStore: context.read<ExportStore>(),
        importStore: context.read(),
        downloadStore: context.read(),
        sharedPreferences: context.read<SharedPreferences>(),
        context: context,
      ),
      child: const _BookScreenContent(),
    );
  }
}

class _BookScreenContent extends StatelessWidget {
  const _BookScreenContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookController>(
      builder: (context, controller, child) {
        return PopScope(
          canPop: !controller.multiEditMode,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && controller.multiEditMode) {
              // 如果在批量编辑模式，退出模式而不是返回页面
              controller.triggerMultiEditMode(false);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('书籍管理'),
              actions: [_SearchButton(), _ActionPopupButton()],
            ),
            body: RefreshIndicator(
              onRefresh: () => controller.fetchBooks(),
              child: DKStateQueryDisplay(
                state: controller.fetchBooksState,
                successBuilder: (data) {
                  return controller.bookLayout == BookLayoutSetting.list
                      ? const _BookListView()
                      : const _BookGridView();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 搜索按钮
class _SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<BookController>();

    return SearchAnchor(
      builder: (context, searchController) {
        return IconButton(
          onPressed: () => searchController.openView(),
          icon: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (context, searchController) {
        final results = controller.searchBooks(searchController.text);
        return results.map((bookVo) {
          return ListTile(
            leading: FutureBuilder(
              future: FileUtil.getBookImageFullPath(
                bookVo.book.localPaths.first,
              ),
              builder: (context, snapData) {
                return CustomImageLoader(localUrl: snapData.data);
              },
            ),
            title: Text(bookVo.book.name),
            subtitle: Text(
              '创建于 ${bookVo.book.createdAt.toIso8601String().split('T')[0]}',
            ),
            onTap: () {
              context.push(AppRoute.bookPage, extra: bookVo.book.id);
              searchController.closeView('');
            },
          );
        }).toList();
      },
    );
  }
}

/// 操作弹出菜单按钮
class _ActionPopupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookController>(
      builder: (context, controller, child) {
        return PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('批量选择'),
              onTap: () {
                controller.triggerMultiEditMode(true);
                _showBottomSheet(context);
              },
            ),
            PopupMenuItem(
              child: const Text('切换布局'),
              onTap: () {
                controller.bookLayout =
                    controller.bookLayout == BookLayoutSetting.list
                    ? BookLayoutSetting.grid
                    : BookLayoutSetting.list;
              },
            ),
            PopupMenuItem(
              child: const Text('排序方式'),
              onTap: () => _showSortDialog(context),
            ),
          ],
        );
      },
    );
  }

  void _showSortDialog(BuildContext context) {
    final controller = context.read<BookController>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('排序方式'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<BookSortType>(
              title: const Text('按标题'),
              value: BookSortType.title,
              groupValue: controller.sortBy.type,
              onChanged: (value) {
                if (value != null) {
                  controller.changeSortBy(value, controller.sortBy.order);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<BookSortType>(
              title: const Text('按添加时间'),
              value: BookSortType.addTime,
              groupValue: controller.sortBy.type,
              onChanged: (value) {
                if (value != null) {
                  controller.changeSortBy(value, controller.sortBy.order);
                  Navigator.pop(context);
                }
              },
            ),
            const Divider(),
            RadioListTile<BookSortOrder>(
              title: const Text('升序'),
              value: BookSortOrder.asc,
              groupValue: controller.sortBy.order,
              onChanged: (value) {
                if (value != null) {
                  controller.changeSortBy(controller.sortBy.type, value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<BookSortOrder>(
              title: const Text('降序'),
              value: BookSortOrder.desc,
              groupValue: controller.sortBy.order,
              onChanged: (value) {
                if (value != null) {
                  controller.changeSortBy(controller.sortBy.type, value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    final controller = context.read<BookController>();
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => ChangeNotifierProvider.value(
        value: controller,
        child: const _BatchEditBottomSheet(),
      ),
    );
  }
}

/// 列表视图
class _BookListView extends StatelessWidget {
  const _BookListView();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookController>(
      builder: (context, controller, child) {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: controller.books.length,
          itemBuilder: (context, index) {
            final bookVo = controller.books[index];
            return _BookListItem(bookVo: bookVo);
          },
        );
      },
    );
  }
}

/// 列表项
class _BookListItem extends StatelessWidget {
  final BookVo bookVo;

  const _BookListItem({required this.bookVo});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<BookController>();
    final isSelected = controller.selectedBookIds.contains(bookVo.book.id);

    void onTap() {
      if (controller.multiEditMode) {
        controller.toggleSelectBook(bookVo.book.id);
      } else {
        context.push(AppRoute.bookPage, extra: bookVo.book.id);
      }
    }

    void onLongTap() {
      if (!controller.multiEditMode) {
        controller.triggerMultiEditMode(true);
        controller.toggleSelectBook(bookVo.book.id);
        _showBottomSheet(context);
      }
    }

    return InkWell(
      onTap: onTap,
      onLongPress: onLongTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 选择框或封面
          if (controller.multiEditMode)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => controller.toggleSelectBook(bookVo.book.id),
              ),
            )
          else
            _buildCover(context),
          // 信息区域
          Expanded(child: _buildInfo(context)),
        ],
      ),
    );
  }

  Widget _buildCover(BuildContext context) {
    return FutureBuilder(
      future: FileUtil.getBookImageFullPath(bookVo.book.localPaths.first),
      builder: (context, snapData) {
        return CustomImageLoader(localUrl: snapData.data);
      },
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          bookVo.book.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (bookVo.collection != null || bookVo.marks.isNotEmpty) ...[
          Row(
            children: [
              if (bookVo.collection != null)
                Chip(
                  label: Text(bookVo.collection!.name),
                  avatar: const Icon(Icons.collections_bookmark, size: 16),
                  visualDensity: VisualDensity.compact,
                ),
              if (bookVo.marks.isNotEmpty)
                ...bookVo.marks.map(
                  (mark) => Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Chip(
                      label: Text(mark.name),
                      avatar: const Icon(Icons.bookmark, size: 16),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
            ],
          ),
        ],
        Text(
          '创建于 ${bookVo.book.createdAt.toIso8601String().split('T')[0]}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    final controller = context.read<BookController>();
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => ChangeNotifierProvider.value(
        value: controller,
        child: const _BatchEditBottomSheet(),
      ),
    );
  }
}

/// 网格视图
class _BookGridView extends StatelessWidget {
  const _BookGridView();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookController>(
      builder: (context, controller, child) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.6,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.books.length,
          itemBuilder: (context, index) {
            final bookVo = controller.books[index];
            return _BookGridItem(bookVo: bookVo);
          },
        );
      },
    );
  }
}

/// 网格项
class _BookGridItem extends StatelessWidget {
  final BookVo bookVo;

  const _BookGridItem({required this.bookVo});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookController>();
    final isSelected = controller.selectedBookIds.contains(bookVo.book.id);

    void onTap() {
      if (controller.multiEditMode) {
        controller.toggleSelectBook(bookVo.book.id);
      } else {
        context.push(AppRoute.bookPage, extra: bookVo.book.id);
      }
    }

    void onLongTap() {
      if (!controller.multiEditMode) {
        controller.triggerMultiEditMode(true);
        controller.toggleSelectBook(bookVo.book.id);
        _showBottomSheet(context);
      }
    }

    return InkWell(
      onTap: onTap,
      onLongPress: onLongTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面 + 选择框
          Stack(
            children: [
              FutureBuilder(
                future: FileUtil.getBookImageFullPath(
                  bookVo.book.localPaths.first,
                ),
                builder: (context, snapData) {
                  return CustomImageLoader(localUrl: snapData.data);
                },
              ),
              if (controller.multiEditMode)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) =>
                        controller.toggleSelectBook(bookVo.book.id),
                  ),
                ),
              // 标签和收藏夹显示在右上角
              if (!controller.multiEditMode &&
                  (bookVo.collection != null || bookVo.marks.isNotEmpty))
                Positioned(
                  top: 8,
                  right: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 4,
                    children: [
                      if (bookVo.collection != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.collections_bookmark,
                                size: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                bookVo.collection!.name,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (bookVo.marks.isNotEmpty)
                        ...bookVo.marks
                            .take(2)
                            .map(
                              (mark) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.bookmark,
                                      size: 12,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      mark.name,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // 书名
          Text(
            bookVo.book.name,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    final controller = context.read<BookController>();
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => ChangeNotifierProvider.value(
        value: controller,
        child: const _BatchEditBottomSheet(),
      ),
    );
  }
}

/// 批量编辑底部操作栏
class _BatchEditBottomSheet extends StatelessWidget {
  const _BatchEditBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookController>(
      builder: (context, controller, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '已选择 ${controller.selectedBookIds.length} 本书籍',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          if (controller.isAllBooksSelected) {
                            controller.toggleDeselectAllBooks();
                          } else {
                            controller.toggleSelectAllBooks();
                          }
                        },
                        child: Text(
                          controller.isAllBooksSelected ? '取消全选' : '全选',
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.triggerMultiEditMode(false);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton.icon(
                    onPressed: controller.selectedBookIds.isEmpty
                        ? null
                        : () async {
                            await controller.exportMultipleBooks();
                            if (context.mounted) Navigator.pop(context);
                          },
                    icon: const Icon(Icons.upload),
                    label: const Text('导出'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: controller.selectedBookIds.isEmpty
                        ? null
                        : () {
                            _showCollectionDialog(context);
                          },
                    icon: const Icon(Icons.collections_bookmark),
                    label: const Text('添加到收藏夹'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: controller.selectedBookIds.isEmpty
                        ? null
                        : () async {
                            final confirmed = await _showDeleteConfirmDialog(
                              context,
                            );
                            if (confirmed == true && context.mounted) {
                              await controller.deleteMultipleBooks();
                              if (context.mounted) Navigator.pop(context);
                            }
                          },
                    icon: const Icon(Icons.delete),
                    label: const Text('删除'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.errorContainer,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCollectionDialog(BuildContext context) {
    final controller = context.read<BookController>();
    final collectionStore = context.read<CollectionStore>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择收藏夹'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: collectionStore.collections.length,
            itemBuilder: (context, index) {
              final collection = collectionStore.collections[index];
              return ListTile(
                title: Text(collection.name),
                subtitle: collection.description != null
                    ? Text(collection.description!)
                    : null,
                onTap: () async {
                  await controller.addMultipleBooksToCollection(collection.id);
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmDialog(BuildContext context) {
    final controller = context.read<BookController>();
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除选中的 ${controller.selectedBookIds.length} 本书籍吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
