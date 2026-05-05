class BookSort {
  final BookSortOrder order;
  final BookSortType type;

  BookSort({required this.order, required this.type});
}

enum BookSortOrder { asc, desc }

enum BookSortType { title, lastCreatedAt }
