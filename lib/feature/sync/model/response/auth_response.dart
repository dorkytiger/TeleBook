import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

/// 设备注册响应：access token（短期 JWT）+ refresh token（长期，可轮换）。
@JsonSerializable(fieldRename: FieldRename.snake)
class RegisterResponse {
  final String accessToken;
  final String refreshToken;
  final String deviceId;

  const RegisterResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.deviceId,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}
