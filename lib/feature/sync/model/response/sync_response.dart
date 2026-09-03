import 'package:json_annotation/json_annotation.dart';

import '../request/sync_request.dart';

part 'sync_response.g.dart';

/// push 单条变更结果。
@JsonSerializable(fieldRename: FieldRename.snake)
class ChangeResult {
  final String entityType;
  final String entityId;
  final bool accepted;
  final int revision;
  final int eventId;
  final String? reason; // conflict / duplicate
  final int? conflictId;

  const ChangeResult({
    required this.entityType,
    required this.entityId,
    required this.accepted,
    required this.revision,
    required this.eventId,
    this.reason,
    this.conflictId,
  });

  factory ChangeResult.fromJson(Map<String, dynamic> json) =>
      _$ChangeResultFromJson(json);
  Map<String, dynamic> toJson() => _$ChangeResultToJson(this);
}

/// push 响应。
@JsonSerializable(fieldRename: FieldRename.snake)
class SyncPushResponse {
  final List<ChangeResult> results;

  const SyncPushResponse({required this.results});

  factory SyncPushResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncPushResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SyncPushResponseToJson(this);
}

/// 单条拉取事件。
@JsonSerializable(fieldRename: FieldRename.snake)
class SyncEvent {
  final int id;
  final String entityType;
  final String entityId;
  final String op; // upsert / delete
  final int revision; // 该变更后的实体版本（pull 回写乐观锁用）
  final BookPayload? payload;
  final String deviceId;
  final DateTime createdAt;

  const SyncEvent({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.op,
    this.revision = 0,
    this.payload,
    required this.deviceId,
    required this.createdAt,
  });

  factory SyncEvent.fromJson(Map<String, dynamic> json) =>
      _$SyncEventFromJson(json);
  Map<String, dynamic> toJson() => _$SyncEventToJson(this);
}

/// pull 响应。
@JsonSerializable(fieldRename: FieldRename.snake)
class SyncPullResponse {
  final int cursor;
  final bool hasMore;
  final List<SyncEvent> events;

  const SyncPullResponse({
    required this.cursor,
    required this.hasMore,
    required this.events,
  });

  factory SyncPullResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncPullResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SyncPullResponseToJson(this);
}

/// 同步状态响应。
@JsonSerializable(fieldRename: FieldRename.snake)
class SyncStatusResponse {
  final int cursor;
  final int pendingCount;
  final int conflictCount;
  final int failedCount;
  final DateTime? lastSyncedAt;

  const SyncStatusResponse({
    required this.cursor,
    required this.pendingCount,
    required this.conflictCount,
    required this.failedCount,
    this.lastSyncedAt,
  });

  factory SyncStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncStatusResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SyncStatusResponseToJson(this);
}
