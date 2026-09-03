// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeResult _$ChangeResultFromJson(Map<String, dynamic> json) => ChangeResult(
  entityType: json['entity_type'] as String,
  entityId: json['entity_id'] as String,
  accepted: json['accepted'] as bool,
  revision: (json['revision'] as num).toInt(),
  eventId: (json['event_id'] as num).toInt(),
  reason: json['reason'] as String?,
  conflictId: (json['conflict_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$ChangeResultToJson(ChangeResult instance) =>
    <String, dynamic>{
      'entity_type': instance.entityType,
      'entity_id': instance.entityId,
      'accepted': instance.accepted,
      'revision': instance.revision,
      'event_id': instance.eventId,
      'reason': instance.reason,
      'conflict_id': instance.conflictId,
    };

SyncPushResponse _$SyncPushResponseFromJson(Map<String, dynamic> json) =>
    SyncPushResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => ChangeResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SyncPushResponseToJson(SyncPushResponse instance) =>
    <String, dynamic>{'results': instance.results};

SyncEvent _$SyncEventFromJson(Map<String, dynamic> json) => SyncEvent(
  id: (json['id'] as num).toInt(),
  entityType: json['entity_type'] as String,
  entityId: json['entity_id'] as String,
  op: json['op'] as String,
  revision: (json['revision'] as num?)?.toInt() ?? 0,
  payload: json['payload'] == null
      ? null
      : BookPayload.fromJson(json['payload'] as Map<String, dynamic>),
  deviceId: json['device_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$SyncEventToJson(SyncEvent instance) => <String, dynamic>{
  'id': instance.id,
  'entity_type': instance.entityType,
  'entity_id': instance.entityId,
  'op': instance.op,
  'revision': instance.revision,
  'payload': instance.payload,
  'device_id': instance.deviceId,
  'created_at': instance.createdAt.toIso8601String(),
};

SyncPullResponse _$SyncPullResponseFromJson(Map<String, dynamic> json) =>
    SyncPullResponse(
      cursor: (json['cursor'] as num).toInt(),
      hasMore: json['has_more'] as bool,
      events: (json['events'] as List<dynamic>)
          .map((e) => SyncEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SyncPullResponseToJson(SyncPullResponse instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'has_more': instance.hasMore,
      'events': instance.events,
    };

SyncStatusResponse _$SyncStatusResponseFromJson(Map<String, dynamic> json) =>
    SyncStatusResponse(
      cursor: (json['cursor'] as num).toInt(),
      pendingCount: (json['pending_count'] as num).toInt(),
      conflictCount: (json['conflict_count'] as num).toInt(),
      failedCount: (json['failed_count'] as num).toInt(),
      lastSyncedAt: json['last_synced_at'] == null
          ? null
          : DateTime.parse(json['last_synced_at'] as String),
    );

Map<String, dynamic> _$SyncStatusResponseToJson(SyncStatusResponse instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'pending_count': instance.pendingCount,
      'conflict_count': instance.conflictCount,
      'failed_count': instance.failedCount,
      'last_synced_at': instance.lastSyncedAt?.toIso8601String(),
    };
