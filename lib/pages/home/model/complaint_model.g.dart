// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComplaintModel _$ComplaintModelFromJson(Map<String, dynamic> json) =>
    ComplaintModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$ComplaintModelToJson(ComplaintModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'subject': instance.subject,
      'message': instance.message,
      'createdAt': instance.createdAt?.toIso8601String(),
      'status': instance.status,
    };
