// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookFileMeta _$BookFileMetaFromJson(Map<String, dynamic> json) => BookFileMeta(
  relPath: json['rel_path'] as String,
  hash: json['hash'] as String,
  size: (json['size'] as num).toInt(),
);

Map<String, dynamic> _$BookFileMetaToJson(BookFileMeta instance) =>
    <String, dynamic>{
      'rel_path': instance.relPath,
      'hash': instance.hash,
      'size': instance.size,
    };

BookPayload _$BookPayloadFromJson(Map<String, dynamic> json) => BookPayload(
  name: json['name'] as String,
  currentPage: (json['current_page'] as num?)?.toInt() ?? 0,
  coverHash: json['cover_hash'] as String?,
  files:
      (json['files'] as List<dynamic>?)
          ?.map((e) => BookFileMeta.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$BookPayloadToJson(BookPayload instance) =>
    <String, dynamic>{
      'name': instance.name,
      'current_page': instance.currentPage,
      'cover_hash': instance.coverHash,
      'files': instance.files,
    };

BookChange _$BookChangeFromJson(Map<String, dynamic> json) => BookChange(
  changeId: json['change_id'] as String,
  entityType: json['entity_type'] as String,
  entityId: json['entity_id'] as String,
  op: json['op'] as String,
  baseRevision: (json['base_revision'] as num).toInt(),
  payload: json['payload'] == null
      ? null
      : BookPayload.fromJson(json['payload'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookChangeToJson(BookChange instance) =>
    <String, dynamic>{
      'change_id': instance.changeId,
      'entity_type': instance.entityType,
      'entity_id': instance.entityId,
      'op': instance.op,
      'base_revision': instance.baseRevision,
      'payload': instance.payload,
    };

SyncPushRequest _$SyncPushRequestFromJson(Map<String, dynamic> json) =>
    SyncPushRequest(
      source: json['source'] as String? ?? 'auto',
      changes: (json['changes'] as List<dynamic>)
          .map((e) => BookChange.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SyncPushRequestToJson(SyncPushRequest instance) =>
    <String, dynamic>{'source': instance.source, 'changes': instance.changes};
