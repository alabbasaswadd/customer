import 'package:mikrotic_customer/core/constants/model/error_model.dart';
import 'package:mikrotic_customer/pages/features/complaint/model/complaint_model.dart';

class ComplaintListResponseModel {
  final bool succeeded;
  final List<ComplaintModel>? data;
  final ErrorModel? errors;

  ComplaintListResponseModel({required this.succeeded, this.data, this.errors});

  factory ComplaintListResponseModel.fromJson(Map<String, dynamic> json) {
    return ComplaintListResponseModel(
      succeeded: json['succeeded'] as bool? ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ComplaintModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors: json['errors'] != null
          ? ErrorModel.fromJson(json['errors'] as Map<String, dynamic>)
          : null,
    );
  }
}
