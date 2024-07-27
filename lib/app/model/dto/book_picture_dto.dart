class BookPictureDto {
  final int? id;
  final int bookId;
  final String path;
  final int number;

  BookPictureDto(
      {this.id, required this.bookId, required this.path, required this.number});
}
