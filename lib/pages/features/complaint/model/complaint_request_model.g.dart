// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComplaintRequestModel _$ComplaintRequestModelFromJson(
  Map<String, dynamic> json,
) => ComplaintRequestModel(
  title: json['title'] as String?,
  description: json['description'] as String?,
  attachmentUrl: json['attachmentUrl'] as String?,
);

Map<String, dynamic> _$ComplaintRequestModelToJson(
  ComplaintRequestModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'attachmentUrl': instance.attachmentUrl,
};
