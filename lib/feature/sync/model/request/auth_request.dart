import 'package:json_annotation/json_annotation.dart';

part 'auth_request.g.dart';

/// 设备注册请求（密钥换 JWT）。
@JsonSerializable(fieldRename: FieldRename.snake)
class RegisterRequest {
  final String connectionKey;
  final String deviceId;
  final String deviceName;
  final String platform;

  const RegisterRequest({
    required this.connectionKey,
    required this.deviceId,
    required this.deviceName,
    required this.platform,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
