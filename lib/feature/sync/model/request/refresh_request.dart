import 'package:json_annotation/json_annotation.dart';

part 'refresh_request.g.dart';

/// access token 刷新请求（refresh token 换新 access）。
@JsonSerializable(fieldRename: FieldRename.snake)
class RefreshRequest {
  final String refreshToken;

  const RefreshRequest({required this.refreshToken});

  factory RefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshRequestToJson(this);
}
