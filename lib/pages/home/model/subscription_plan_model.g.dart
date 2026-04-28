// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionPlanModel _$SubscriptionPlanModelFromJson(
  Map<String, dynamic> json,
) => SubscriptionPlanModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  currency: json['currency'] as String? ?? 'ج.م',
  durationDays: (json['durationDays'] as num).toInt(),
  speed: (json['speed'] as num).toDouble(),
  speedUnit: json['speedUnit'] as String? ?? 'Mbps',
  features: (json['features'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  isPopular: json['isPopular'] as bool? ?? false,
  isCurrentPlan: json['isCurrentPlan'] as bool? ?? false,
);

Map<String, dynamic> _$SubscriptionPlanModelToJson(
  SubscriptionPlanModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'currency': instance.currency,
  'durationDays': instance.durationDays,
  'speed': instance.speed,
  'speedUnit': instance.speedUnit,
  'features': instance.features,
  'isPopular': instance.isPopular,
  'isCurrentPlan': instance.isCurrentPlan,
};
