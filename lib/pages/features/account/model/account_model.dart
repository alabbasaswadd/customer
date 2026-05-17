import 'package:json_annotation/json_annotation.dart';
import 'package:mikrotic_customer/pages/features/account/model/subscription_model.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? note;
  final String? additionalNotes;
  final List<dynamic> addresses;
  final String? addressId;
  final dynamic wallet;
  final String? walletId;
  final String accountId;
  final List<SubscriptionModel> subscriptions;
  final String createdBy;
  final DateTime createdOn;
  final String? updatedBy;
  final DateTime? updatedOn;
  final bool isActive;
  final String token;

  AccountModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.note,
    this.additionalNotes,
    required this.addresses,
    this.addressId,
    this.wallet,
    this.walletId,
    required this.accountId,
    required this.subscriptions,
    required this.createdBy,
    required this.createdOn,
    this.updatedBy,
    this.updatedOn,
    required this.isActive,
    required this.token,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
