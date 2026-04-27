import 'package:json_annotation/json_annotation.dart';

part 'complaint_model.g.dart';

@JsonSerializable()
class ComplaintModel {
  final String? id;
  final String name;
  final String phone;
  final String subject;
  final String message;
  final DateTime? createdAt;
  final String? status;

  ComplaintModel({
    this.id,
    required this.name,
    required this.phone,
    required this.subject,
    required this.message,
    this.createdAt,
    this.status,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComplaintModelToJson(this);
}
