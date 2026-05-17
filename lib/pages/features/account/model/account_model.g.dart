// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
  id: json['id'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  note: json['note'] as String?,
  additionalNotes: json['additionalNotes'] as String?,
  addresses: json['addresses'] as List<dynamic>,
  addressId: json['addressId'] as String?,
  wallet: json['wallet'],
  walletId: json['walletId'] as String?,
  accountId: json['accountId'] as String,
  subscriptions: (json['subscriptions'] as List<dynamic>)
      .map((e) => SubscriptionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdBy: json['createdBy'] as String,
  createdOn: DateTime.parse(json['createdOn'] as String),
  updatedBy: json['updatedBy'] as String?,
  updatedOn: json['updatedOn'] == null
      ? null
      : DateTime.parse(json['updatedOn'] as String),
  isActive: json['isActive'] as bool,
  token: json['token'] as String,
);

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'note': instance.note,
      'additionalNotes': instance.additionalNotes,
      'addresses': instance.addresses,
      'addressId': instance.addressId,
      'wallet': instance.wallet,
      'walletId': instance.walletId,
      'accountId': instance.accountId,
      'subscriptions': instance.subscriptions,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'updatedOn': instance.updatedOn?.toIso8601String(),
      'isActive': instance.isActive,
      'token': instance.token,
    };
