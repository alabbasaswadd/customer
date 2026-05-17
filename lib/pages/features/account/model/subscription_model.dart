import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mikrotic_customer/pages/features/account/model/subscription_type_model.dart';
part 'subscription_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SubscriptionModel {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final int status;
  final SubscriptionType subscriptionType;
  final String subscriberId;
  final String subscriptionTypeId;
  final String createdBy;
  final DateTime createdOn;
  final String? updatedBy;
  final DateTime? updatedOn;
  final bool isActive;

  SubscriptionModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.subscriptionType,
    required this.subscriberId,
    required this.subscriptionTypeId,
    required this.createdBy,
    required this.createdOn,
    this.updatedBy,
    this.updatedOn,
    required this.isActive,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);
}
