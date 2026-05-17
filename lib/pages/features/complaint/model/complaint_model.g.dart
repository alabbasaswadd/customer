// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComplaintModel _$ComplaintModelFromJson(Map<String, dynamic> json) =>
    ComplaintModel(
      json['id'] as String?,
      json['title'] as String?,
      json['description'] as String?,
      json['subscriberId'] as String?,
      json['attachmentUrl'] as String?,
      json['createdBy'] as String?,
      json['createdOn'] as String?,
      json['updatedBy'] as String?,
      json['updatedOn'] as String?,
      json['isActive'] as bool?,
    );

Map<String, dynamic> _$ComplaintModelToJson(ComplaintModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'subscriberId': instance.subscriberId,
      'attachmentUrl': instance.attachmentUrl,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn,
      'updatedBy': instance.updatedBy,
      'updatedOn': instance.updatedOn,
      'isActive': instance.isActive,
    };
