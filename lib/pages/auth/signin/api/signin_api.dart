import 'package:mikrotic_customer/core/api/api_result.dart';
import 'package:mikrotic_customer/core/api/base_api.dart';
import 'package:mikrotic_customer/core/constants/api_routes.dart';
import 'package:mikrotic_customer/pages/auth/signin/model/signin_request_model.dart';
import 'package:mikrotic_customer/pages/auth/signin/model/signin_response_model.dart';

class SigninApi {
  final BaseApi api;

  SigninApi(this.api);
  Future<ApiResult<SigninResponseModel>> signin({
    required SigninRequestModel request,
  }) {
    return api.post(
      ApiRoutes.signin,
      data: request.toJson(),
      fromJson: (json) => SigninResponseModel.fromJson(json),
    );
  }
}
