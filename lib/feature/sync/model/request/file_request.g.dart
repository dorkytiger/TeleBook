// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileHashItem _$FileHashItemFromJson(Map<String, dynamic> json) => FileHashItem(
  hash: json['hash'] as String,
  size: (json['size'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$FileHashItemToJson(FileHashItem instance) =>
    <String, dynamic>{'hash': instance.hash, 'size': instance.size};

FileCheckRequest _$FileCheckRequestFromJson(Map<String, dynamic> json) =>
    FileCheckRequest(
      files: (json['files'] as List<dynamic>)
          .map((e) => FileHashItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FileCheckRequestToJson(FileCheckRequest instance) =>
    <String, dynamic>{'files': instance.files};

FileInitUploadRequest _$FileInitUploadRequestFromJson(
  Map<String, dynamic> json,
) => FileInitUploadRequest(
  hash: json['hash'] as String,
  size: (json['size'] as num).toInt(),
);

Map<String, dynamic> _$FileInitUploadRequestToJson(
  FileInitUploadRequest instance,
) => <String, dynamic>{'hash': instance.hash, 'size': instance.size};

FilePartMeta _$FilePartMetaFromJson(Map<String, dynamic> json) => FilePartMeta(
  partNumber: (json['part_number'] as num).toInt(),
  etag: json['etag'] as String,
);

Map<String, dynamic> _$FilePartMetaToJson(FilePartMeta instance) =>
    <String, dynamic>{
      'part_number': instance.partNumber,
      'etag': instance.etag,
    };

FileCompleteUploadRequest _$FileCompleteUploadRequestFromJson(
  Map<String, dynamic> json,
) => FileCompleteUploadRequest(
  hash: json['hash'] as String,
  uploadId: json['upload_id'] as String,
  size: (json['size'] as num).toInt(),
  totalParts: (json['total_parts'] as num).toInt(),
  parts: (json['parts'] as List<dynamic>)
      .map((e) => FilePartMeta.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FileCompleteUploadRequestToJson(
  FileCompleteUploadRequest instance,
) => <String, dynamic>{
  'hash': instance.hash,
  'upload_id': instance.uploadId,
  'size': instance.size,
  'total_parts': instance.totalParts,
  'parts': instance.parts,
};
