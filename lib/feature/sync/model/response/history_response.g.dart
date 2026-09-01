// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookHistory _$BookHistoryFromJson(Map<String, dynamic> json) => BookHistory(
  id: (json['id'] as num).toInt(),
  opType: json['op_type'] as String,
  tag: json['tag'] as String,
  payload: (json['payload'] as List<dynamic>?)
      ?.map((e) => BookSnapshotItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$BookHistoryToJson(BookHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'op_type': instance.opType,
      'tag': instance.tag,
      'payload': instance.payload,
      'created_at': instance.createdAt.toIso8601String(),
    };

HistoryListResponse _$HistoryListResponseFromJson(Map<String, dynamic> json) =>
    HistoryListResponse(
      history: (json['history'] as List<dynamic>)
          .map((e) => BookHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HistoryListResponseToJson(
  HistoryListResponse instance,
) => <String, dynamic>{'history': instance.history};

BookRestoreResponse _$BookRestoreResponseFromJson(Map<String, dynamic> json) =>
    BookRestoreResponse(
      restored: (json['restored'] as num).toInt(),
      revision: (json['revision'] as num).toInt(),
    );

Map<String, dynamic> _$BookRestoreResponseToJson(
  BookRestoreResponse instance,
) => <String, dynamic>{
  'restored': instance.restored,
  'revision': instance.revision,
};
