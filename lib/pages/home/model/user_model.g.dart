// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      balance: (json['balance'] as num).toDouble(),
      subscription:
          SubscriptionModel.fromJson(json['subscription'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'fullName': instance.fullName,
      'balance': instance.balance,
      'subscription': instance.subscription.toJson(),
    };

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      speed: (json['speed'] as num).toDouble(),
      speedUnit: json['speedUnit'] as String,
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'expiryDate': instance.expiryDate.toIso8601String(),
      'speed': instance.speed,
      'speedUnit': instance.speedUnit,
    };
