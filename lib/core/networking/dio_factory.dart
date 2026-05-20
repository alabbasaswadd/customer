import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/constants/cached/user_session.dart';
import 'package:mikrotic_customer/core/networking/api_constans.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;

  static Dio getDio() {
    if (dio == null) {
      const timeOut = Duration(seconds: 30);
      dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.apiBaseUrl,
          connectTimeout: timeOut,
          receiveTimeout: timeOut,
          headers: {
            'Authorization': 'Bearer ${UserSession.user?.token ?? ''}',
            'X-Tenant-Id':
                UserSession.user?.subscriptions.first.id ??
                ApiConstants.tenantId,
          },
        ),
      );
      addDioInterceptor();
    }
    return dio!;
  }

  // static void addDioHeaders() async {
  //   dio?.options.headers = {
  //     'Accept': 'application/json',
  //     'Authorization':
  //         'Bearer ${await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken)}',
  //   };
  // }

  static void setTokenIntoHeaderAfterLogin(String token) {
    dio?.options.headers = {
      'X-Tenant-Id':
          UserSession.user?.subscriptions.first.id ?? ApiConstants.tenantId,
      'Authorization': 'Bearer ${UserSession.user?.token ?? token}',
    };
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }
}
