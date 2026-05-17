import 'package:json_annotation/json_annotation.dart';
part 'subscription_type_model.g.dart';

@JsonSerializable()
class SubscriptionType {
  final String id;
  final String name;
  final double price;
  final int durationDays;
  final int dataLimitGB;
  final String packageSpeedId;
  final dynamic packageSpeed;
  final String createdBy;
  final DateTime createdOn;
  final String? updatedBy;
  final DateTime? updatedOn;
  final bool isActive;

  SubscriptionType({
    required this.id,
    required this.name,
    required this.price,
    required this.durationDays,
    required this.dataLimitGB,
    required this.packageSpeedId,
    this.packageSpeed,
    required this.createdBy,
    required this.createdOn,
    this.updatedBy,
    this.updatedOn,
    required this.isActive,
  });

  factory SubscriptionType.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionTypeFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionTypeToJson(this);
}
