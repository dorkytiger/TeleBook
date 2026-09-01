import 'package:json_annotation/json_annotation.dart';

import '../request/history_request.dart';

part 'history_response.g.dart';

/// 单条归档记录：payload = 整库快照（操作前的书籍数组）。
@JsonSerializable(fieldRename: FieldRename.snake)
class BookHistory {
  final int id;
  final String opType; // import / modify / delete / manual_sync / restore
  final String tag; // manual / auto
  final List<BookSnapshotItem>? payload;
  final DateTime createdAt;

  const BookHistory({
    required this.id,
    required this.opType,
    required this.tag,
    this.payload,
    required this.createdAt,
  });

  factory BookHistory.fromJson(Map<String, dynamic> json) =>
      _$BookHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$BookHistoryToJson(this);
}

/// 归档历史列表响应。
@JsonSerializable(fieldRename: FieldRename.snake)
class HistoryListResponse {
  final List<BookHistory> history;

  const HistoryListResponse({required this.history});

  factory HistoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryListResponseToJson(this);
}

/// 整库恢复响应。
@JsonSerializable(fieldRename: FieldRename.snake)
class BookRestoreResponse {
  final int restored; // 恢复的书籍数
  final int revision;

  const BookRestoreResponse({required this.restored, required this.revision});

  factory BookRestoreResponse.fromJson(Map<String, dynamic> json) =>
      _$BookRestoreResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BookRestoreResponseToJson(this);
}
