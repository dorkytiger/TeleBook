// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileCheckResponse _$FileCheckResponseFromJson(Map<String, dynamic> json) =>
    FileCheckResponse(
      missing: (json['missing'] as List<dynamic>)
          .map((e) => FileHashItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FileCheckResponseToJson(FileCheckResponse instance) =>
    <String, dynamic>{'missing': instance.missing};

FileInitUploadResponse _$FileInitUploadResponseFromJson(
  Map<String, dynamic> json,
) => FileInitUploadResponse(
  uploadId: json['upload_id'] as String?,
  complete: json['complete'] as bool,
);

Map<String, dynamic> _$FileInitUploadResponseToJson(
  FileInitUploadResponse instance,
) => <String, dynamic>{
  'upload_id': instance.uploadId,
  'complete': instance.complete,
};

FileCompleteUploadResponse _$FileCompleteUploadResponseFromJson(
  Map<String, dynamic> json,
) => FileCompleteUploadResponse(
  hash: json['hash'] as String,
  complete: json['complete'] as bool,
);

Map<String, dynamic> _$FileCompleteUploadResponseToJson(
  FileCompleteUploadResponse instance,
) => <String, dynamic>{'hash': instance.hash, 'complete': instance.complete};
