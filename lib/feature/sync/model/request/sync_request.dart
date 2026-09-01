import 'package:json_annotation/json_annotation.dart';

part 'sync_request.g.dart';

/// 书籍文件元数据（hash 引用，内容寻址去重）。
@JsonSerializable(fieldRename: FieldRename.snake)
class BookFileMeta {
  final String relPath;
  final String hash;
  final int size;

  const BookFileMeta({
    required this.relPath,
    required this.hash,
    required this.size,
  });

  factory BookFileMeta.fromJson(Map<String, dynamic> json) =>
      _$BookFileMetaFromJson(json);
  Map<String, dynamic> toJson() => _$BookFileMetaToJson(this);
}

/// 书籍快照 payload（push / pull / 归档共用）。
@JsonSerializable(fieldRename: FieldRename.snake)
class BookPayload {
  final String name;
  final int currentPage;
  final String? coverHash;
  final List<BookFileMeta> files;

  const BookPayload({
    required this.name,
    this.currentPage = 0,
    this.coverHash,
    this.files = const [],
  });

  factory BookPayload.fromJson(Map<String, dynamic> json) =>
      _$BookPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$BookPayloadToJson(this);
}

/// 单条实体变更（push）。
@JsonSerializable(fieldRename: FieldRename.snake)
class BookChange {
  final String changeId;
  final String entityType;
  final String entityId;
  final String op; // upsert / delete
  final int baseRevision;
  final BookPayload? payload;

  const BookChange({
    required this.changeId,
    required this.entityType,
    required this.entityId,
    required this.op,
    required this.baseRevision,
    this.payload,
  });

  factory BookChange.fromJson(Map<String, dynamic> json) =>
      _$BookChangeFromJson(json);
  Map<String, dynamic> toJson() => _$BookChangeToJson(this);
}

/// push 请求体。
@JsonSerializable(fieldRename: FieldRename.snake)
class SyncPushRequest {
  final String source; // manual | auto
  final List<BookChange> changes;

  const SyncPushRequest({this.source = 'auto', required this.changes});

  factory SyncPushRequest.fromJson(Map<String, dynamic> json) =>
      _$SyncPushRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SyncPushRequestToJson(this);
}
