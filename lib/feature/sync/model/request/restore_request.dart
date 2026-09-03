import 'package:json_annotation/json_annotation.dart';

part 'restore_request.g.dart';

/// 归档恢复请求。
@JsonSerializable(fieldRename: FieldRename.snake)
class BookRestoreRequest {
  final int historyId;

  const BookRestoreRequest({required this.historyId});

  factory BookRestoreRequest.fromJson(Map<String, dynamic> json) =>
      _$BookRestoreRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BookRestoreRequestToJson(this);
}
