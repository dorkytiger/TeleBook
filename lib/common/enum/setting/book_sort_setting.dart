enum BookTitleSortSetting {
  titleAsc('titleAsc', '标题升序'),
  titleDesc('titleDesc', '标题降序');


  final String value;
  final String description;

  const BookTitleSortSetting(this.value, this.description);

  static BookTitleSortSetting fromValue(String value) {
    return BookTitleSortSetting.values.firstWhere(
          (e) => e.value == value,
      orElse: () => BookTitleSortSetting.titleAsc, // 默认值
    );
  }
}

enum BookAddTimeSortSetting {
  addTimeAsc('addTimeAsc', '添加日期升序'),
  addTimeDesc('addTimeDesc', '添加日期降序');

  final String value;
  final String description;

  const BookAddTimeSortSetting(this.value, this.description);

  static BookAddTimeSortSetting fromValue(String value) {
    return BookAddTimeSortSetting.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BookAddTimeSortSetting.addTimeAsc, // 默认值
    );
  }
}