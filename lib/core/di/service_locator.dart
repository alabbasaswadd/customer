import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mikrotic_customer/core/networking/base_api.dart';
import 'package:mikrotic_customer/pages/auth/signin/api/signin_api.dart';
import 'package:mikrotic_customer/pages/auth/signin/bloc/signin_bloc.dart';
import 'package:mikrotic_customer/pages/speed_test/bloc/speed_test_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Dio (Singleton)
  sl.registerLazySingleton(() {
    final dio = Dio();

    dio.options.baseUrl =
        "http://network-isp-user-api.runasp.net/network-user-api";

    return dio;
  });

  //! BaseApi
  sl.registerLazySingleton(() => BaseApi(sl()));

  //! SigninApi
  sl.registerLazySingleton(() => SigninApi(sl()));


  //! Bloc
  sl.registerFactory(() => SigninBloc(sl()));
  sl.registerFactory(() => SpeedTestBloc());
}
