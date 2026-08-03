import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';

class BookListState {
  // --- 数据与查询状态 ---
  final List<BookListItemVo> bookVos;
  final bool hasMore;
  final bool isLoadingMore;
  final String name;
  final BookSort? sort;

  // --- 💡 塞入 UI 交互状态 ---
  final bool isSelectionMode;
  final Set<int> selectedBookIds; // 使用 Set 处理查找更高效
  final BookLayout layout;        // 列表或网格布局

  BookListState({
    required this.bookVos,
    required this.hasMore,
    required this.name,
    this.sort,
    this.isLoadingMore = false,
    this.isSelectionMode = false,
    this.selectedBookIds = const {},
    this.layout = BookLayout.list,
  });

  // 快捷派生属性：获取当前选中的所有书籍模型
  List<BookListItemVo> get selectedBooks =>
      bookVos.where((vo) => selectedBookIds.contains(vo.book.id)).toList();

  BookListState copyWith({
    List<BookListItemVo>? bookVos,
    bool? hasMore,
    bool? isLoadingMore,
    String? name,
    BookSort? sort,
    bool? isSelectionMode,
    Set<int>? selectedBookIds,
    BookLayout? layout,
  }) {
    return BookListState(
      bookVos: bookVos ?? this.bookVos,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      name: name ?? this.name,
      sort: sort ?? this.sort,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedBookIds: selectedBookIds ?? this.selectedBookIds,
      layout: layout ?? this.layout,
    );
  }
}

enum BookLayout {
  list,
  grid,
}

class BookListItemVo {
  final BookTableData book;
  final String coverImagePath;

  BookListItemVo({required this.book, required this.coverImagePath});
}
