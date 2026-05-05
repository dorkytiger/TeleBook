enum ReadingDirection {
  leftToRight(0, '从左往右阅读'),
  rightToLeft(1, '从右往左阅读'),
  topToBottom(2, '从上往下阅读');

  const ReadingDirection(this.value, this.label);

  final int value;
  final String label;

  static ReadingDirection fromValue(int value) {
    return ReadingDirection.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ReadingDirection.leftToRight,
    );
  }
}
