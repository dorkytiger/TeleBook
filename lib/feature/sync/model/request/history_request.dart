import 'package:json_annotation/json_annotation.dart';

import 'sync_request.dart';

part 'history_request.g.dart';

/// 整库快照中的单本书（uuid + 书籍 payload）。
@JsonSerializable(fieldRename: FieldRename.snake)
class BookSnapshotItem {
  final String uuid;
  final String name;
  final int currentPage;
  final String? coverHash;
  final List<BookFileMeta> files;

  const BookSnapshotItem({
    required this.uuid,
    required this.name,
    this.currentPage = 0,
    this.coverHash,
    this.files = const [],
  });

  factory BookSnapshotItem.fromJson(Map<String, dynamic> json) =>
      _$BookSnapshotItemFromJson(json);
  Map<String, dynamic> toJson() => _$BookSnapshotItemToJson(this);
}

/// 客户端驱动：把操作前捕获的整库快照同步为一条历史记录。
@JsonSerializable(fieldRename: FieldRename.snake)
class RecordHistoryRequest {
  final String opType; // import / modify / delete / manual_sync / restore
  final String tag; // manual / auto
  final List<BookSnapshotItem> snapshot;

  const RecordHistoryRequest({
    required this.opType,
    required this.tag,
    required this.snapshot,
  });

  factory RecordHistoryRequest.fromJson(Map<String, dynamic> json) =>
      _$RecordHistoryRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RecordHistoryRequestToJson(this);
}
