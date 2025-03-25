import 'package:tele_book/generated/json/base/json_field.dart';
import 'package:tele_book/generated/json/book_list_response_entity.g.dart';
import 'dart:convert';
export 'package:tele_book/generated/json/book_list_response_entity.g.dart';

@JsonSerializable()
class BookListResponseEntity {
	List<BookListResponseBooks> books = [];

	BookListResponseEntity();

	factory BookListResponseEntity.fromJson(Map<String, dynamic> json) => $BookListResponseEntityFromJson(json);

	Map<String, dynamic> toJson() => $BookListResponseEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class BookListResponseBooks {
	int id = 0;
	String name = '';
	@JSONField(name: 'base_url')
	String baseUrl = '';
	@JSONField(name: 'image_urls')
	List<String> imageUrls = [];
	@JSONField(name: 'local_image_urls')
	List<String> localImageUrls = [];
	@JSONField(name: 'created_at')
	String createdAt = '';
	@JSONField(name: 'updated_at')
	String updatedAt = '';

	BookListResponseBooks();

	factory BookListResponseBooks.fromJson(Map<String, dynamic> json) => $BookListResponseBooksFromJson(json);

	Map<String, dynamic> toJson() => $BookListResponseBooksToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}