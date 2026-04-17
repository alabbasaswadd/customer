// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SigninModel _$SigninModelFromJson(Map<String, dynamic> json) => SigninModel(
  id: json['id'] as String?,
  token: json['token'] as String?,
  username: json['username'] as String?,
  password: json['password'] as String?,
);

Map<String, dynamic> _$SigninModelToJson(SigninModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'username': instance.username,
      'password': instance.password,
    };
