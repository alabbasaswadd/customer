import 'package:get_it/get_it.dart';
import 'package:mikrotic_customer/core/networking/dio_factory.dart';
import 'package:mikrotic_customer/pages/auth/signin/api/signin_api.dart';
import 'package:mikrotic_customer/pages/auth/signin/api/signin_api_service.dart';
import 'package:mikrotic_customer/pages/auth/signin/cubit/signin_cubit.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/api/connected_devices_api.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/cubit/connected_devices_cubit.dart';
import 'package:mikrotic_customer/pages/home/api/home_api.dart';
import 'package:mikrotic_customer/pages/home/cubit/home_cubit.dart';
import 'package:mikrotic_customer/pages/home/cubit/subscriptions_cubit.dart';
import 'package:mikrotic_customer/pages/home/cubit/maintenance_cubit.dart';
import 'package:mikrotic_customer/pages/home/cubit/support_cubit.dart';
import 'package:mikrotic_customer/pages/features/chat/repository/chat_repository.dart';
import 'package:mikrotic_customer/pages/features/chat/cubit/chat_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDI() async {
  //! Dio (Singleton) - shared instance used across all API services
  getIt.registerLazySingleton(() => DioFactory.getDio());

  //! SigninApi
  getIt.registerLazySingleton(() => SigninApi(getIt()));
  getIt.registerLazySingleton(() => SigninApiService(getIt()));

  //! HomeApi
  getIt.registerLazySingleton(() => HomeApi());

  //! ConnectedDevicesApi
  getIt.registerLazySingleton(() => ConnectedDevicesApi());

  //! Cubit
  getIt.registerFactory(() => SigninCubit(getIt()));
  getIt.registerFactory(() => HomeCubit(getIt()));
  getIt.registerFactory(() => SubscriptionsCubit(getIt()));
  getIt.registerFactory(() => SupportCubit(getIt()));
  getIt.registerFactory(() => MaintenanceCubit(getIt()));
  getIt.registerFactory(() => ConnectedDevicesCubit(getIt()));
  getIt.registerLazySingleton(() => ChatRepository());
  getIt.registerFactory(() => ChatCubit(getIt()));
}
