class BookVO {
  int id;
  String path;
  String preview;
  String title;
  List<String> pictures;

  BookVO(
      {required this.id,
      required this.path,
      required this.preview,
      required this.title,
      required this.pictures});
}
