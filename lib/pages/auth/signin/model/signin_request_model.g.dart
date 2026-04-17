// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SigninRequestModel _$SigninRequestModelFromJson(Map<String, dynamic> json) =>
    SigninRequestModel(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$SigninRequestModelToJson(SigninRequestModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };
