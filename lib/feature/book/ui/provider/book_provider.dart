import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';
import 'package:tele_book/feature/book/model/state/book_list_state.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';

part 'book_provider.g.dart';

final booksProvider = StreamProvider.autoDispose<List<BookTableData>>((ref){
  final bookRepository = ref.watch(bookRepositoryProvider);
  return bookRepository.watchAllBooks();
});

class _BookListQueryState {
  final String name;
  final BookSort? sort;
  final int page;
  final int pageSize;

  const _BookListQueryState({
    this.name = '',
    this.sort,
    this.page = 1,
    this.pageSize = 20,
  });

  _BookListQueryState copyWith({
    String? name,
    BookSort? sort,
    int? page,
    int? pageSize,
  }) {
    return _BookListQueryState(
      name: name ?? this.name,
      sort: sort ?? this.sort,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

class _BookListUiState {
  final bool isSelectionMode;
  final Set<int> selectedBookIds;
  final BookLayout layout;

  const _BookListUiState({
    this.isSelectionMode = false,
    this.selectedBookIds = const {},
    this.layout = BookLayout.list,
  });

  _BookListUiState copyWith({
    bool? isSelectionMode,
    Set<int>? selectedBookIds,
    BookLayout? layout,
  }) {
    return _BookListUiState(
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedBookIds: selectedBookIds ?? this.selectedBookIds,
      layout: layout ?? this.layout,
    );
  }
}

class _BookListQueryNotifier extends Notifier<_BookListQueryState> {
  @override
  _BookListQueryState build() => const _BookListQueryState();

  void updateSearch(String name) {
    state = state.copyWith(name: name, page: 1);
  }

  void updateSort(BookSort? sort) {
    state = state.copyWith(sort: sort, page: 1);
  }

  void loadNextPage() {
    state = state.copyWith(page: state.page + 1);
  }
}

final bookListQueryProvider =
    NotifierProvider<_BookListQueryNotifier, _BookListQueryState>(
      _BookListQueryNotifier.new,
    );

class _BookListUiNotifier extends Notifier<_BookListUiState> {
  @override
  _BookListUiState build() => const _BookListUiState();

  void enterSelectionMode(BookTableData firstBook) {
    state = state.copyWith(isSelectionMode: true, selectedBookIds: {firstBook.id});
  }

  void exitSelectionMode() {
    state = state.copyWith(isSelectionMode: false, selectedBookIds: {});
  }

  void toggleSelection(int bookId) {
    final updatedIds = Set<int>.from(state.selectedBookIds);
    if (updatedIds.contains(bookId)) {
      updatedIds.remove(bookId);
      if (updatedIds.isEmpty) {
        state = state.copyWith(isSelectionMode: false, selectedBookIds: {});
        return;
      }
    } else {
      updatedIds.add(bookId);
    }

    state = state.copyWith(selectedBookIds: updatedIds);
  }

  void selectAll(Iterable<int> ids) {
    state = state.copyWith(
      isSelectionMode: true,
      selectedBookIds: ids.toSet(),
    );
  }

  void toggleLayout() {
    final nextLayout =
        state.layout == BookLayout.list ? BookLayout.grid : BookLayout.list;
    state = state.copyWith(layout: nextLayout);
  }

  void clearSelectedIds(Iterable<int> ids) {
    final updated = Set<int>.from(state.selectedBookIds)
      ..removeAll(ids);
    if (updated.isEmpty) {
      state = state.copyWith(isSelectionMode: false, selectedBookIds: {});
      return;
    }
    state = state.copyWith(selectedBookIds: updated);
  }
}

final bookListUiProvider = NotifierProvider<_BookListUiNotifier, _BookListUiState>(
  _BookListUiNotifier.new,
);

@riverpod
class BookList extends _$BookList {
  @override
  Future<BookListState> build() async {
    final booksAsync = ref.watch(booksProvider);
    final query = ref.watch(bookListQueryProvider);
    final ui = ref.watch(bookListUiProvider);

    if (booksAsync.hasError) {
      throw booksAsync.error!;
    }
    final books =
        (booksAsync.value ?? await ref.watch(booksProvider.future)) ??
        const <BookTableData>[];
    final keyword = query.name.toLowerCase();

    final filtered = books.where((book) {
      if (keyword.isEmpty) return true;
      return book.name.toLowerCase().contains(keyword);
    }).toList();

    if (query.sort != null) {
      filtered.sort((a, b) {
        final cmp = switch (query.sort!.type) {
          BookSortType.title =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          BookSortType.lastCreatedAt => a.createdAt.compareTo(b.createdAt),
        };
        return query.sort!.order == BookSortOrder.asc ? cmp : -cmp;
      });
    } else {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    final visibleCount = query.page * query.pageSize;
    final visibleBooks = filtered.take(visibleCount).toList();

    final bookVos = visibleBooks.map((book) {
      final coverPath = book.localSubPaths.isNotEmpty
          ? GlobalConfig.resolveBookPath(book.localSubPaths.first)
          : '';
      return BookListItemVo(book: book, coverImagePath: coverPath);
    }).toList();

    final visibleIds = visibleBooks.map((e) => e.id).toSet();
    final selectedIds = ui.selectedBookIds.where(visibleIds.contains).toSet();

    return BookListState(
      bookVos: bookVos,
      hasMore: filtered.length > visibleBooks.length,
      name: query.name,
      sort: query.sort,
      isLoadingMore: false,
      isSelectionMode: ui.isSelectionMode,
      selectedBookIds: selectedIds,
      layout: ui.layout,
    );
  }

  Future<void> loadNextPage() async {
    if (!state.hasValue || state.isLoading) return;
    final current = state.requireValue;
    if (!current.hasMore || current.isLoadingMore) return;
    ref.read(bookListQueryProvider.notifier).loadNextPage();
  }

  Future<void> updateSearch(String name) async {
    ref.read(bookListQueryProvider.notifier).updateSearch(name);
  }

  Future<void> updateSort(BookSort? sort) async {
    ref.read(bookListQueryProvider.notifier).updateSort(sort);
  }

  // ➡️ 进入多选模式并勾选第一本书
  void enterSelectionMode(BookTableData firstBook) {
    ref.read(bookListUiProvider.notifier).enterSelectionMode(firstBook);
  }

  // ➡️ 退出多选模式
  void exitSelectionMode() {
    ref.read(bookListUiProvider.notifier).exitSelectionMode();
  }

  // ➡️ 切换某本书的选中状态
  void toggleSelection(int bookId) {
    ref.read(bookListUiProvider.notifier).toggleSelection(bookId);
  }

  // ➡️ 全选
  void selectAll() {
    final ids =
        state.asData?.value.bookVos.map((vo) => vo.book.id) ?? const <int>[];
    ref.read(bookListUiProvider.notifier).selectAll(ids);
  }

  // ➡️ 切换布局
  void toggleLayout() {
    ref.read(bookListUiProvider.notifier).toggleLayout();
  }

  // ➡️ 删除单本书并刷新列表
  Future<void> deleteBook(int bookId) async {
    final bookRepository = ref.read(bookRepositoryProvider);
    await bookRepository.deleteBook(bookId);
    ref.read(bookListUiProvider.notifier).clearSelectedIds([bookId]);
  }

  // ➡️ 批量删除选中书籍并刷新列表
  Future<void> deleteSelected() async {
    if (!state.hasValue) return;
    final selectedIds = Set<int>.from(state.requireValue.selectedBookIds);
    final bookRepository = ref.read(bookRepositoryProvider);

    for (final id in selectedIds) {
      await bookRepository.deleteBook(id);
    }
    ref.read(bookListUiProvider.notifier).exitSelectionMode();
  }
}
