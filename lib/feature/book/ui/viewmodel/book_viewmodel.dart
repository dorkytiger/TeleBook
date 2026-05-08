import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';
import 'package:tele_book/feature/book/model/vo/book_vo.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/book/store/book_store.dart';

enum BookLayout { list, grid }

class BookViewmodel extends ChangeNotifier {
  final BookRepository _bookRepository;
  final BookStore bookStore;
  final ScrollController scrollController = ScrollController();
  bool _isViewportCheckScheduled = false;

  BookLayout layout = BookLayout.list;

  // ── 批量选择模式 ──────────────────────────────────────────
  bool isSelectionMode = false;
  final Set<int> selectedBookIds = {};

  List<BookListItemVo> get selectedBooks =>
      bookStore.books.where((b) => selectedBookIds.contains(b.book.id)).toList();

  void enterSelectionMode(BookTableData book) {
    isSelectionMode = true;
    selectedBookIds.add(book.id);
    notifyListeners();
  }

  void exitSelectionMode() {
    isSelectionMode = false;
    selectedBookIds.clear();
    notifyListeners();
  }

  void toggleSelection(int bookId) {
    if (selectedBookIds.contains(bookId)) {
      selectedBookIds.remove(bookId);
    } else {
      selectedBookIds.add(bookId);
    }
    notifyListeners();
  }

  void selectAll() {
    selectedBookIds.addAll(bookStore.books.map((b) => b.book.id));
    notifyListeners();
  }

  void onExportSelected(BuildContext context) {
    final books = selectedBooks.map((v) => v.book).toList();
    exitSelectionMode();
    context.push(AppRoute.exportBatch, extra: books);
  }

  // ── 滚动 ─────────────────────────────────────────────────

  BookViewmodel(this._bookRepository, this.bookStore) {
    scrollController.addListener(_onScroll);
    bookStore.addListener(_onBookStoreChanged);
    _scheduleViewportCheck();
  }

  void _onScroll() {
    if (!scrollController.hasClients || bookStore.isLoading || !bookStore.hasMore) {
      return;
    }
    final pos = scrollController.position;
    if (pos.maxScrollExtent <= 0 || pos.pixels >= pos.maxScrollExtent - 200) {
      bookStore.loadMore();
    }
  }

  void _onBookStoreChanged() {
    _scheduleViewportCheck();
  }

  void _scheduleViewportCheck() {
    if (_isViewportCheckScheduled) return;
    _isViewportCheckScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isViewportCheckScheduled = false;
      _onScroll();
    });
  }

  void toggleLayout() {
    layout = layout == BookLayout.list ? BookLayout.grid : BookLayout.list;
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    bookStore.removeListener(_onBookStoreChanged);
    scrollController.dispose();
    super.dispose();
  }

  void onTopMenuSelected(BuildContext context, BookTopMenuType type) {
    switch (type) {
      case BookTopMenuType.add:
        context.push(AppRoute.parseForm);
        break;
      case BookTopMenuType.desc:
        bookStore.updateSort(
          bookStore.sort.copyWith(order: BookSortOrder.desc),
        );
        break;
      case BookTopMenuType.asc:
        bookStore.updateSort(bookStore.sort.copyWith(order: BookSortOrder.asc));
        break;
      case BookTopMenuType.name:
        bookStore.updateSort(bookStore.sort.copyWith(type: BookSortType.title));
        break;
      case BookTopMenuType.lastCreatedAt:
        bookStore.updateSort(
          bookStore.sort.copyWith(type: BookSortType.lastCreatedAt),
        );
        break;
      case BookTopMenuType.list:
        layout = BookLayout.list;
        notifyListeners();
        break;
      case BookTopMenuType.grid:
        layout = BookLayout.grid;
        notifyListeners();
        break;
    }
  }

  void onItemMenuSelected(
    BuildContext context,
    BookItemMenuType type,
    BookTableData book,
  ) {
    switch (type) {
      case BookItemMenuType.edit:
        context.push(AppRoute.bookForm, extra: book);
        break;
      case BookItemMenuType.export:
        context.push(AppRoute.exportSingle, extra: book);
        break;
      case BookItemMenuType.delete:
        showGeneralDialog(
          context: context,
          pageBuilder: (_, __, ___) {
            return AlertDialog(
              title: const Text('删除书籍'),
              content: const Text('确定要删除这本书吗？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    _bookRepository.deleteBook(book.id);
                    Navigator.of(context).pop();
                  },
                  child: const Text('删除'),
                ),
              ],
            );
          },
        );
        break;
    }
  }
}

enum BookTopMenuType {
  add('添加', Icons.add),
  desc('降序',Icons.arrow_downward),
  asc('升序',Icons.arrow_upward),
  name('按标题',Icons.sort_by_alpha),
  lastCreatedAt('按时间',Icons.access_time),
  list('列表',Icons.view_list),
  grid('网格',Icons.grid_view);

  final String title;
  final IconData icon;

  const BookTopMenuType(this.title,this.icon);
}

enum BookItemMenuType {
  edit('编辑',Icons.edit),
  export('导出',Icons.file_download),
  delete('删除',Icons.delete);

  final String title;
  final IconData icon;

  const BookItemMenuType(this.title,this.icon);
}
