class BookSort {
  final BookSortOrder order;
  final BookSortType type;

  BookSort({required this.order, required this.type});

  BookSort copyWith({BookSortOrder? order, BookSortType? type}) {
    return BookSort(
      order: order ?? this.order,
      type: type ?? this.type,
    );
  }
}

enum BookSortOrder { asc, desc }

enum BookSortType { title, lastCreatedAt }
