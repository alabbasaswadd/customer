import 'package:dio/dio.dart';
import 'package:mikrotic_customer/core/constants/model/error_model.dart';
import 'package:mikrotic_customer/core/networking/api_error_handler.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';

abstract class BaseApi {
  Future<ApiResult<T>> execute<T>({
    required Future<T> Function() request,
  }) async {
    try {
      final response = await request();

      return ApiResult.success(response);
    } on DioException catch (e) {
      return ApiResult.failure(
        ErrorModel(
          message: ErrorHandler.handle(e).errorModel.message,
          errors: {},
        ),
      );
    } catch (e) {
      return ApiResult.failure(ErrorModel(message: e.toString(), errors: {}));
    }
  }
}
