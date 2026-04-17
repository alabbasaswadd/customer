import 'package:dio/dio.dart';
import 'package:mikrotic_customer/core/networking/api_constans.dart';
import 'package:mikrotic_customer/pages/auth/signin/model/signin_request_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.login)
  Future<SigninRequestModel> login(@Body() SigninRequestModel loginRequestBody);
}
