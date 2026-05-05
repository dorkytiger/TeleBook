enum BookLayoutSetting {
  list(1, '列表'),
  grid(2, '网格');

  final int value;
  final String description;

  const BookLayoutSetting(this.value, this.description);

  static BookLayoutSetting fromValue(int value) {
    return BookLayoutSetting.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BookLayoutSetting.list,
    );
  }
}
