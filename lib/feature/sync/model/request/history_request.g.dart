// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookSnapshotItem _$BookSnapshotItemFromJson(Map<String, dynamic> json) =>
    BookSnapshotItem(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      currentPage: (json['current_page'] as num?)?.toInt() ?? 0,
      coverHash: json['cover_hash'] as String?,
      files:
          (json['files'] as List<dynamic>?)
              ?.map((e) => BookFileMeta.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BookSnapshotItemToJson(BookSnapshotItem instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'current_page': instance.currentPage,
      'cover_hash': instance.coverHash,
      'files': instance.files,
    };

RecordHistoryRequest _$RecordHistoryRequestFromJson(
  Map<String, dynamic> json,
) => RecordHistoryRequest(
  opType: json['op_type'] as String,
  tag: json['tag'] as String,
  snapshot: (json['snapshot'] as List<dynamic>)
      .map((e) => BookSnapshotItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RecordHistoryRequestToJson(
  RecordHistoryRequest instance,
) => <String, dynamic>{
  'op_type': instance.opType,
  'tag': instance.tag,
  'snapshot': instance.snapshot,
};
