import 'package:json_annotation/json_annotation.dart';

part 'conflict_request.g.dart';

/// 冲突解决请求。
@JsonSerializable(fieldRename: FieldRename.snake)
class ConflictResolveRequest {
  final String strategy; // keep_local | keep_server | manual
  final Map<String, dynamic>? payload; // manual 时必填

  const ConflictResolveRequest({required this.strategy, this.payload});

  factory ConflictResolveRequest.fromJson(Map<String, dynamic> json) =>
      _$ConflictResolveRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ConflictResolveRequestToJson(this);
}
