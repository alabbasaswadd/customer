import 'package:mikrotic_customer/core/constants/model/error_model.dart';
import 'package:mikrotic_customer/core/networking/api_error.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/pages/auth/signin/api/signin_api_service.dart';
import 'package:mikrotic_customer/pages/auth/signin/model/signin_request_model.dart';
import 'package:mikrotic_customer/pages/auth/signin/model/signin_response_model.dart';

class SigninApi {
  final SigninApiService _apiService;

  SigninApi(this._apiService);

  Future<ApiResult<SigninResponseModel>> signin(
    SigninRequestModel request,
  ) async {
    try {
      final response = await _apiService.signin(request);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(
        ErrorModel(message: ApiError.fromException(e), errors: {}),
      );
    }
  }
}
