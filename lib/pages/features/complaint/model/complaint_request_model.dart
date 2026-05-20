import 'package:json_annotation/json_annotation.dart';

part 'complaint_request_model.g.dart';

@JsonSerializable()
class ComplaintRequestModel {
  final String? title;
  final String? description;
  final String? attachmentUrl;
  ComplaintRequestModel({this.title, this.description, this.attachmentUrl});
  factory ComplaintRequestModel.fromJson(Map<String, dynamic> json) {
    return _$ComplaintRequestModelFromJson(json);
  }
  Map<String, dynamic> toJson() {
    return _$ComplaintRequestModelToJson(this);
  }
}
