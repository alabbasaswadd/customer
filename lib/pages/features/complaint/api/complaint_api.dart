import 'package:mikrotic_customer/core/constants/model/error_model.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/pages/features/complaint/api/complaint_api_service.dart';
import 'package:mikrotic_customer/pages/features/complaint/model/complaint_request_model.dart';
import 'package:mikrotic_customer/pages/features/complaint/model/complaint_response_model.dart';

class ComplaintApi {
  final ComplaintApiService _apiService;

  ComplaintApi(this._apiService);

  Future<ApiResult<T>> _execute<T>(Future<T> Function() apiCall) async {
    try {
      final response = await apiCall();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorModel(message: e.toString(), errors: {}));
    }
  }

  Future<ApiResult<ComplaintResponseModel>> addComplaint(
    ComplaintRequestModel request,
  ) {
    return _execute(() => _apiService.addComplaint(request));
  }

  Future<ApiResult<ComplaintResponseModel>> getComplaints() {
    return _execute(() => _apiService.getComplaints());
  }

  Future<ApiResult<ComplaintResponseModel>> deleteComplaint(String id) {
    return _execute(() => _apiService.deleteComplaint(id));
  }

  Future<ApiResult<ComplaintResponseModel>> updateComplaint(
    String id,
    ComplaintRequestModel request,
  ) {
    return _execute(() => _apiService.updateComplaint(id, request));
  }
}
