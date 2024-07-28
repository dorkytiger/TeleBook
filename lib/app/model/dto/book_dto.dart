class BookDTO {
  final int? id;
  final String title;
  final String path;
  final String? createTime;
  final String? updateTIme;

  BookDTO(
      {this.id,
      required this.title,
      required this.path,
      this.createTime,
      this.updateTIme});
}
