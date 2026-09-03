// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conflict_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncConflict _$SyncConflictFromJson(Map<String, dynamic> json) => SyncConflict(
  id: (json['id'] as num).toInt(),
  entityType: json['entity_type'] as String,
  entityId: json['entity_id'] as String,
  localPayload: json['local_payload'] as Map<String, dynamic>?,
  serverPayload: json['server_payload'] as Map<String, dynamic>?,
  serverRevision: (json['server_revision'] as num).toInt(),
  status: json['status'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$SyncConflictToJson(SyncConflict instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entity_type': instance.entityType,
      'entity_id': instance.entityId,
      'local_payload': instance.localPayload,
      'server_payload': instance.serverPayload,
      'server_revision': instance.serverRevision,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
    };

ConflictListResponse _$ConflictListResponseFromJson(
  Map<String, dynamic> json,
) => ConflictListResponse(
  conflicts: (json['conflicts'] as List<dynamic>)
      .map((e) => SyncConflict.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ConflictListResponseToJson(
  ConflictListResponse instance,
) => <String, dynamic>{'conflicts': instance.conflicts};
