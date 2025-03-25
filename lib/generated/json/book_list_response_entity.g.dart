import 'package:tele_book/generated/json/base/json_convert_content.dart';
import 'package:tele_book/app/model/response/book_list_response_entity.dart';

BookListResponseEntity $BookListResponseEntityFromJson(
    Map<String, dynamic> json) {
  final BookListResponseEntity bookListResponseEntity = BookListResponseEntity();
  final List<BookListResponseBooks>? books = (json['books'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<BookListResponseBooks>(e) as BookListResponseBooks)
      .toList();
  if (books != null) {
    bookListResponseEntity.books = books;
  }
  return bookListResponseEntity;
}

Map<String, dynamic> $BookListResponseEntityToJson(
    BookListResponseEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['books'] = entity.books.map((v) => v.toJson()).toList();
  return data;
}

extension BookListResponseEntityExtension on BookListResponseEntity {
  BookListResponseEntity copyWith({
    List<BookListResponseBooks>? books,
  }) {
    return BookListResponseEntity()
      ..books = books ?? this.books;
  }
}

BookListResponseBooks $BookListResponseBooksFromJson(
    Map<String, dynamic> json) {
  final BookListResponseBooks bookListResponseBooks = BookListResponseBooks();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    bookListResponseBooks.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    bookListResponseBooks.name = name;
  }
  final String? baseUrl = jsonConvert.convert<String>(json['base_url']);
  if (baseUrl != null) {
    bookListResponseBooks.baseUrl = baseUrl;
  }
  final List<String>? imageUrls = (json['image_urls'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (imageUrls != null) {
    bookListResponseBooks.imageUrls = imageUrls;
  }
  final List<String>? localImageUrls = (json['local_image_urls'] as List<
      dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (localImageUrls != null) {
    bookListResponseBooks.localImageUrls = localImageUrls;
  }
  final String? createdAt = jsonConvert.convert<String>(json['created_at']);
  if (createdAt != null) {
    bookListResponseBooks.createdAt = createdAt;
  }
  final String? updatedAt = jsonConvert.convert<String>(json['updated_at']);
  if (updatedAt != null) {
    bookListResponseBooks.updatedAt = updatedAt;
  }
  return bookListResponseBooks;
}

Map<String, dynamic> $BookListResponseBooksToJson(
    BookListResponseBooks entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['base_url'] = entity.baseUrl;
  data['image_urls'] = entity.imageUrls;
  data['local_image_urls'] = entity.localImageUrls;
  data['created_at'] = entity.createdAt;
  data['updated_at'] = entity.updatedAt;
  return data;
}

extension BookListResponseBooksExtension on BookListResponseBooks {
  BookListResponseBooks copyWith({
    int? id,
    String? name,
    String? baseUrl,
    List<String>? imageUrls,
    List<String>? localImageUrls,
    String? createdAt,
    String? updatedAt,
  }) {
    return BookListResponseBooks()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..baseUrl = baseUrl ?? this.baseUrl
      ..imageUrls = imageUrls ?? this.imageUrls
      ..localImageUrls = localImageUrls ?? this.localImageUrls
      ..createdAt = createdAt ?? this.createdAt
      ..updatedAt = updatedAt ?? this.updatedAt;
  }
}