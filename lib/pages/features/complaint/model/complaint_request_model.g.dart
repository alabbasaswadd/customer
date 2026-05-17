// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComplaintRequestModel _$ComplaintRequestModelFromJson(
  Map<String, dynamic> json,
) => ComplaintRequestModel(
  json['title'] as String?,
  json['description'] as String?,
  json['attachmentUrl'] as String?,
);

Map<String, dynamic> _$ComplaintRequestModelToJson(
  ComplaintRequestModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'attachmentUrl': instance.attachmentUrl,
};
