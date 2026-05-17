import 'package:json_annotation/json_annotation.dart';
import 'package:mikrotic_customer/core/constants/model/error_model.dart';
import 'package:mikrotic_customer/pages/home/home.dart';

part 'complaint_response_model.g.dart';

@JsonSerializable()
class ComplaintResponseModel {
  final bool succeeded;
  final ComplaintModel? data;
  final ErrorModel? errors;
  ComplaintResponseModel(this.succeeded, this.data, this.errors);
  factory ComplaintResponseModel.fromJson(Map<String, dynamic> json) {
    return _$ComplaintResponseModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ComplaintResponseModelToJson(this);
  }
}
