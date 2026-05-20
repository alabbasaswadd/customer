import 'package:mikrotic_customer/core/constants/base_api.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/pages/features/complaint/api/complaint_api_service.dart';
import 'package:mikrotic_customer/pages/features/complaint/model/complaint_list_response_model.dart';
import 'package:mikrotic_customer/pages/features/complaint/model/complaint_request_model.dart';
import 'package:mikrotic_customer/pages/features/complaint/model/complaint_response_model.dart';

class ComplaintApi extends BaseApi {
  final ComplaintApiService _apiService;

  ComplaintApi(this._apiService);

  Future<ApiResult<ComplaintResponseModel>> addComplaint(
    ComplaintRequestModel request,
  ) {
    return execute(request: () => _apiService.addComplaint(request));
  }

  Future<ApiResult<ComplaintListResponseModel>> getComplaints() {
    return execute(request: () => _apiService.getComplaints());
  }

  Future<ApiResult<ComplaintResponseModel>> deleteComplaint(String id) {
    return execute(request: () => _apiService.deleteComplaint(id));
  }

  Future<ApiResult<ComplaintResponseModel>> updateComplaint(
    String id,
    ComplaintRequestModel request,
  ) {
    return execute(request: () => _apiService.updateComplaint(id, request));
  }
}
