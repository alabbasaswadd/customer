import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mikrotic_customer/pages/auth/signin/api/signin_api.dart';
import 'package:mikrotic_customer/pages/auth/signin/cubit/signin_cubit.dart';
import 'package:mikrotic_customer/pages/home/api/home_api.dart';
import 'package:mikrotic_customer/pages/home/cubit/home_cubit.dart';
import 'package:mikrotic_customer/pages/home/cubit/subscriptions_cubit.dart';
import 'package:mikrotic_customer/pages/home/cubit/support_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDI() async {
  //! Dio (Singleton)
  getIt.registerLazySingleton(() {
    final dio = Dio();

    dio.options.baseUrl =
        "http://network-isp-user-api.runasp.net/network-user-api";

    return dio;
  });

  //! SigninApi
  getIt.registerLazySingleton(() => SigninApi(getIt()));

  //! HomeApi
  getIt.registerLazySingleton(() => HomeApi());

  //! Cubit
  getIt.registerFactory(() => SigninCubit(getIt()));
  getIt.registerFactory(() => HomeCubit(getIt()));
  getIt.registerFactory(() => SubscriptionsCubit(getIt()));
  getIt.registerFactory(() => SupportCubit(getIt()));
}
