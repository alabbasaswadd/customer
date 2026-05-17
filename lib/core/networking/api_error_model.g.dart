// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorModel _$ApiErrorModelFromJson(Map<String, dynamic> json) => ErrorModel(
  message: json['message'] as String?,
  code: (json['code'] as num?)?.toInt(),
);

Map<String, dynamic> _$ApiErrorModelToJson(ErrorModel instance) =>
    <String, dynamic>{'message': instance.message, 'code': instance.code};
