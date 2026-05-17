// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionType _$SubscriptionTypeFromJson(Map<String, dynamic> json) =>
    SubscriptionType(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      durationDays: (json['durationDays'] as num).toInt(),
      dataLimitGB: (json['dataLimitGB'] as num).toInt(),
      packageSpeedId: json['packageSpeedId'] as String,
      packageSpeed: json['packageSpeed'],
      createdBy: json['createdBy'] as String,
      createdOn: DateTime.parse(json['createdOn'] as String),
      updatedBy: json['updatedBy'] as String?,
      updatedOn: json['updatedOn'] == null
          ? null
          : DateTime.parse(json['updatedOn'] as String),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$SubscriptionTypeToJson(SubscriptionType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'durationDays': instance.durationDays,
      'dataLimitGB': instance.dataLimitGB,
      'packageSpeedId': instance.packageSpeedId,
      'packageSpeed': instance.packageSpeed,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'updatedOn': instance.updatedOn?.toIso8601String(),
      'isActive': instance.isActive,
    };
