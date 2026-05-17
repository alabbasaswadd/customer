import 'package:json_annotation/json_annotation.dart';

part 'complaint_model.g.dart';

@JsonSerializable()
class ComplaintModel {
  final String? id;
  final String? title;
  final String? description;
  final String? subscriberId;
  final String? attachmentUrl;
  final String? createdBy;
  final String? createdOn;
  final String? updatedBy;
  final String? updatedOn;
  final bool? isActive;

  ComplaintModel(
    this.id,
    this.title,
    this.description,
    this.subscriberId,
    this.attachmentUrl,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.isActive,
  );

  factory ComplaintModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComplaintModelToJson(this);
}
