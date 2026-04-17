import 'package:json_annotation/json_annotation.dart';

part 'signin_request_model.g.dart';

@JsonSerializable()
class SigninRequestModel {
  final String username;
  final String password;

  SigninRequestModel({required this.username, required this.password});
  factory SigninRequestModel.fromJson(Map<String, dynamic> json) {
    return _$SigninRequestModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SigninRequestModelToJson(this);
  }
}
