// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conflict_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConflictResolveRequest _$ConflictResolveRequestFromJson(
  Map<String, dynamic> json,
) => ConflictResolveRequest(
  strategy: json['strategy'] as String,
  payload: json['payload'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ConflictResolveRequestToJson(
  ConflictResolveRequest instance,
) => <String, dynamic>{
  'strategy': instance.strategy,
  'payload': instance.payload,
};
