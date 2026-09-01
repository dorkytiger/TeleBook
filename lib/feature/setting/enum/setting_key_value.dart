enum ReadingDirection {
  leftToRight("从左到右"),
  rightToLeft("从右到左"),
  topToBottom("从上到下");

  final String label;

  const ReadingDirection(this.label);

  static String get key => "reading_direction";
}
