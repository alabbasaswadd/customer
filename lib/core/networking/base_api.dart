import 'package:dio/dio.dart';
import 'package:mikrotic_customer/core/networking/api_error.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';

class BaseApi {
  final Dio dio;

  BaseApi(this.dio);

  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic data,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await dio.post(path, data: data);
      return ApiResult.success(fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(ApiError.fromException(e));
    }
  }
}
