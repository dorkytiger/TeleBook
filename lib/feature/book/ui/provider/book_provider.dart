import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';
import 'package:tele_book/feature/book/model/state/book_list_state.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';

part 'book_provider.g.dart';

@riverpod
class BookList extends _$BookList {
  final int _pageSize = 20;

  @override
  Future<BookListState> build() async {
    return _fetchPage(
      name: '',
      sort: null,
      isFirstPage: true,
      previousBooks: [],
    );
  }

  Future<BookListState> _fetchPage({
    required String name,
    required BookSort? sort,
    required bool isFirstPage,
    required List<BookListItemVo> previousBooks,
  }) async {
    final bookRepository = ref.watch(bookRepositoryProvider);

    final lastCreatedAt = isFirstPage
        ? null
        : previousBooks.last.book.createdAt;

    final newBooks = await bookRepository.getPagedBooks(
      page: isFirstPage ? 1 : null,
      pageSize: _pageSize,
      name: name,
      sort: sort,
      lastCreatedAt: lastCreatedAt,
    );

    final bookVos = newBooks
        .map(
          (book) => BookListItemVo(
            book: book,
            coverImagePath: GlobalConfig.resolveBookPath(
              book.localSubPaths.first,
            ),
          ),
        )
        .toList();

    return BookListState(
      bookVos: isFirstPage ? bookVos : [...previousBooks, ...bookVos],
      hasMore: newBooks.length == _pageSize,
      name: name,
      sort: sort,
      isLoadingMore: false,
    );
  }

  Future<void> loadNextPage() async {
    if (!state.hasValue || state.isLoading) return;
    final current = state.requireValue;

    if (!current.hasMore || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final nextState = await _fetchPage(
        name: current.name,
        sort: current.sort,
        isFirstPage: false,
        previousBooks: current.bookVos,
      );
      state = AsyncData(nextState);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateSearch(String name) async {
    if (!state.hasValue) return;

    state = const AsyncLoading();
    try {
      final nextState = await _fetchPage(
        name: name,
        sort: state.requireValue.sort,
        isFirstPage: true,
        previousBooks: [],
      );
      state = AsyncData(nextState);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateSort(BookSort? sort) async {
    if (!state.hasValue) return;
    state = const AsyncLoading();
    try {
      final nextState = await _fetchPage(
        name: state.requireValue.name,
        sort: sort,
        isFirstPage: true,
        previousBooks: [],
      );
      state = AsyncData(nextState);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // ➡️ 进入多选模式并勾选第一本书
  void enterSelectionMode(BookTableData firstBook) {
    if (!state.hasValue) return;
    state = AsyncData(state.requireValue.copyWith(
      isSelectionMode: true,
      selectedBookIds: {firstBook.id},
    ));
  }

  // ➡️ 退出多选模式
  void exitSelectionMode() {
    if (!state.hasValue) return;
    state = AsyncData(state.requireValue.copyWith(
      isSelectionMode: false,
      selectedBookIds: {}, // 清空勾选
    ));
  }

  // ➡️ 切换某本书的选中状态
  void toggleSelection(int bookId) {
    if (!state.hasValue) return;
    final updatedIds = Set<int>.from(state.requireValue.selectedBookIds);
    if (updatedIds.contains(bookId)) {
      updatedIds.remove(bookId);
      // 如果全取消了，可以选择自动退出多选模式
      if (updatedIds.isEmpty) {
        exitSelectionMode();
        return;
      }
    } else {
      updatedIds.add(bookId);
    }
    state = AsyncData(state.requireValue.copyWith(selectedBookIds: updatedIds));
  }

  // ➡️ 全选
  void selectAll() {
    if (!state.hasValue) return;
    final allIds = state.requireValue.bookVos.map((vo) => vo.book.id).toSet();
    state = AsyncData(state.requireValue.copyWith(selectedBookIds: allIds));
  }

  // ➡️ 切换布局
  void toggleLayout() {
    if (!state.hasValue) return;
    final nextLayout = state.requireValue.layout == BookLayout.list
        ? BookLayout.grid
        : BookLayout.list;
    state = AsyncData(state.requireValue.copyWith(layout: nextLayout));
  }

  // ➡️ 删除单本书并刷新列表
  Future<void> deleteBook(int bookId) async {
    if (!state.hasValue) return;
    final current = state.requireValue;
    final bookRepository = ref.read(bookRepositoryProvider);

    // 乐观更新：先从 UI 中移除
    state = AsyncData(current.copyWith(
      bookVos: current.bookVos.where((v) => v.book.id != bookId).toList(),
    ));

    await bookRepository.deleteBook(bookId);

    // 重新拉取第一页确保数据一致
    try {
      final nextState = await _fetchPage(
        name: current.name,
        sort: current.sort,
        isFirstPage: true,
        previousBooks: [],
      );
      state = AsyncData(nextState.copyWith(layout: current.layout));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // ➡️ 批量删除选中书籍并刷新列表
  Future<void> deleteSelected() async {
    if (!state.hasValue) return;
    final current = state.requireValue;
    final selectedIds = Set<int>.from(current.selectedBookIds);
    final bookRepository = ref.read(bookRepositoryProvider);

    // 乐观更新
    state = AsyncData(current.copyWith(
      bookVos: current.bookVos.where((v) => !selectedIds.contains(v.book.id)).toList(),
      isSelectionMode: false,
      selectedBookIds: {},
    ));

    for (final id in selectedIds) {
      await bookRepository.deleteBook(id);
    }

    try {
      final nextState = await _fetchPage(
        name: current.name,
        sort: current.sort,
        isFirstPage: true,
        previousBooks: [],
      );
      state = AsyncData(nextState.copyWith(layout: current.layout));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
