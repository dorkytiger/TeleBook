import 'package:json_annotation/json_annotation.dart';

part 'file_request.g.dart';

/// 文件指纹（hash + size）。
@JsonSerializable(fieldRename: FieldRename.snake)
class FileHashItem {
  final String hash;
  final int size;

  const FileHashItem({required this.hash, this.size = 0});

  factory FileHashItem.fromJson(Map<String, dynamic> json) =>
      _$FileHashItemFromJson(json);
  Map<String, dynamic> toJson() => _$FileHashItemToJson(this);
}

/// /files/check 请求：批量比对远端缺失。
@JsonSerializable(fieldRename: FieldRename.snake)
class FileCheckRequest {
  final List<FileHashItem> files;

  const FileCheckRequest({required this.files});

  factory FileCheckRequest.fromJson(Map<String, dynamic> json) =>
      _$FileCheckRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FileCheckRequestToJson(this);
}

/// 分片上传初始化请求。
@JsonSerializable(fieldRename: FieldRename.snake)
class FileInitUploadRequest {
  final String hash;
  final int size;

  const FileInitUploadRequest({required this.hash, required this.size});

  factory FileInitUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$FileInitUploadRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FileInitUploadRequestToJson(this);
}

/// 已上传分片（partNumber + ETag）。
@JsonSerializable(fieldRename: FieldRename.snake)
class FilePartMeta {
  final int partNumber;
  final String etag;

  const FilePartMeta({required this.partNumber, required this.etag});

  factory FilePartMeta.fromJson(Map<String, dynamic> json) =>
      _$FilePartMetaFromJson(json);
  Map<String, dynamic> toJson() => _$FilePartMetaToJson(this);
}

/// 完成分片上传请求。
@JsonSerializable(fieldRename: FieldRename.snake)
class FileCompleteUploadRequest {
  final String hash;
  final String uploadId;
  final int size;
  final int totalParts;
  final List<FilePartMeta> parts;

  const FileCompleteUploadRequest({
    required this.hash,
    required this.uploadId,
    required this.size,
    required this.totalParts,
    required this.parts,
  });

  factory FileCompleteUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$FileCompleteUploadRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FileCompleteUploadRequestToJson(this);
}
