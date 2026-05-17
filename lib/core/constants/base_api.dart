import 'package:dio/dio.dart';
import 'package:mikrotic_customer/core/constants/model/error_model.dart';
import 'package:mikrotic_customer/core/networking/api_error_handler.dart';
import 'package:mikrotic_customer/core/networking/api_error_model.dart'
    hide ErrorModel;
import 'package:mikrotic_customer/core/networking/api_result.dart';

abstract class BaseApi {
  /// دالة التنفيذ الأساسية
  Future<ApiResult<T>> execute<T>({
    required Future<Response<dynamic>> Function() request,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await request();

      /// نجاح
      return ApiResult.success(parser(response.data));
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
