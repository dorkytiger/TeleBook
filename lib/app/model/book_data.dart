

class BookProp {
  final int? id;
  final String title;
  final String path;
  final String preview;
  final List<String> pictures;

  BookProp({
    this.id,
    required this.title,
    required this.path,
    required this.preview,
    required this.pictures,
  });
}
