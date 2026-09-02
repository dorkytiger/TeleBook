// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_upload_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookUploadInitRequest _$BookUploadInitRequestFromJson(
  Map<String, dynamic> json,
) => BookUploadInitRequest(
  books: (json['books'] as List<dynamic>)
      .map((e) => BookUploadInitBook.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BookUploadInitRequestToJson(
  BookUploadInitRequest instance,
) => <String, dynamic>{'books': instance.books};

BookUploadInitBook _$BookUploadInitBookFromJson(Map<String, dynamic> json) =>
    BookUploadInitBook(
      uuid: json['uuid'] as String? ?? '',
      clientId: json['client_id'] as String,
      name: json['name'] as String,
      dataVersion: json['data_version'] as String?,
      files:
          (json['files'] as List<dynamic>?)
              ?.map((e) => BookFileMeta.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BookUploadInitBookToJson(BookUploadInitBook instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'client_id': instance.clientId,
      'name': instance.name,
      'data_version': instance.dataVersion,
      'files': instance.files,
    };
