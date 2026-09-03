import 'package:json_annotation/json_annotation.dart';

part 'refresh_response.g.dart';

/// 刷新响应：新 access token + 轮换后的 refresh token。
@JsonSerializable(fieldRename: FieldRename.snake)
class RefreshResponse {
  final String accessToken;
  final String refreshToken;

  const RefreshResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshResponseToJson(this);
}
