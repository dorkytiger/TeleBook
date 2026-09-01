import 'package:json_annotation/json_annotation.dart';

import '../request/file_request.dart';

part 'file_response.g.dart';

/// /files/check 响应：远端缺失清单。
@JsonSerializable(fieldRename: FieldRename.snake)
class FileCheckResponse {
  final List<FileHashItem> missing;

  const FileCheckResponse({required this.missing});

  factory FileCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$FileCheckResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FileCheckResponseToJson(this);
}

/// 分片上传初始化响应（complete=true 表示文件已存在，幂等跳过）。
@JsonSerializable(fieldRename: FieldRename.snake)
class FileInitUploadResponse {
  final String? uploadId;
  final bool complete;

  const FileInitUploadResponse({this.uploadId, required this.complete});

  factory FileInitUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$FileInitUploadResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FileInitUploadResponseToJson(this);
}

/// 完成分片上传响应。
@JsonSerializable(fieldRename: FieldRename.snake)
class FileCompleteUploadResponse {
  final String hash;
  final bool complete;

  const FileCompleteUploadResponse({required this.hash, required this.complete});

  factory FileCompleteUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$FileCompleteUploadResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FileCompleteUploadResponseToJson(this);
}
