import 'package:dio/dio.dart';

class ApiError {
  static String fromException(dynamic e) {
    if (e is DioException) {
      return e.response?.data.toString() ?? "Server Error";
    }
    return "Unexpected Error";
  }
}
