import 'package:json_annotation/json_annotation.dart';

part 'conflict_response.g.dart';

/// 单条冲突记录。
@JsonSerializable(fieldRename: FieldRename.snake)
class SyncConflict {
  final int id;
  final String entityType;
  final String entityId;
  final Map<String, dynamic>? localPayload;
  final Map<String, dynamic>? serverPayload;
  final int serverRevision;
  final String status;
  final DateTime createdAt;

  const SyncConflict({
    required this.id,
    required this.entityType,
    required this.entityId,
    this.localPayload,
    this.serverPayload,
    required this.serverRevision,
    required this.status,
    required this.createdAt,
  });

  factory SyncConflict.fromJson(Map<String, dynamic> json) =>
      _$SyncConflictFromJson(json);
  Map<String, dynamic> toJson() => _$SyncConflictToJson(this);
}

/// 冲突列表响应。
@JsonSerializable(fieldRename: FieldRename.snake)
class ConflictListResponse {
  final List<SyncConflict> conflicts;

  const ConflictListResponse({required this.conflicts});

  factory ConflictListResponse.fromJson(Map<String, dynamic> json) =>
      _$ConflictListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ConflictListResponseToJson(this);
}
