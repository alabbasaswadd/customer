// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: json['id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      status: (json['status'] as num).toInt(),
      subscriptionType: SubscriptionType.fromJson(
        json['subscriptionType'] as Map<String, dynamic>,
      ),
      subscriberId: json['subscriberId'] as String,
      subscriptionTypeId: json['subscriptionTypeId'] as String,
      createdBy: json['createdBy'] as String,
      createdOn: DateTime.parse(json['createdOn'] as String),
      updatedBy: json['updatedBy'] as String?,
      updatedOn: json['updatedOn'] == null
          ? null
          : DateTime.parse(json['updatedOn'] as String),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'status': instance.status,
      'subscriptionType': instance.subscriptionType.toJson(),
      'subscriberId': instance.subscriberId,
      'subscriptionTypeId': instance.subscriptionTypeId,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'updatedOn': instance.updatedOn?.toIso8601String(),
      'isActive': instance.isActive,
    };
