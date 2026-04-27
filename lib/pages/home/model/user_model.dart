import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String username;
  final String fullName;
  final double balance;
  final SubscriptionModel subscription;

  UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.balance,
    required this.subscription,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Mock data for development
  factory UserModel.mock() => UserModel(
        id: '1',
        username: 'ahmed_user',
        fullName: 'أحمد محمد',
        balance: 150.00,
        subscription: SubscriptionModel.mock(),
      );
}

@JsonSerializable()
class SubscriptionModel {
  final String id;
  final String name;
  final DateTime expiryDate;
  final double speed;
  final String speedUnit;

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.expiryDate,
    required this.speed,
    required this.speedUnit,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);

  /// Mock data for development
  factory SubscriptionModel.mock() => SubscriptionModel(
        id: '1',
        name: 'باقة بريميوم',
        expiryDate: DateTime.now().add(const Duration(days: 15, hours: 8, minutes: 30)),
        speed: 100,
        speedUnit: 'Mbps',
      );

  Duration get remainingTime => expiryDate.difference(DateTime.now());

  bool get isExpired => remainingTime.isNegative;
}
