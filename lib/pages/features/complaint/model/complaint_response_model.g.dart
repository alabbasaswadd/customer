// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComplaintResponseModel _$ComplaintResponseModelFromJson(
  Map<String, dynamic> json,
) => ComplaintResponseModel(
  json['succeeded'] as bool,
  json['data'] == null
      ? null
      : ComplaintModel.fromJson(json['data'] as Map<String, dynamic>),
  json['errors'] == null
      ? null
      : ErrorModel.fromJson(json['errors'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ComplaintResponseModelToJson(
  ComplaintResponseModel instance,
) => <String, dynamic>{
  'succeeded': instance.succeeded,
  'data': instance.data,
  'errors': instance.errors,
};
