import 'package:bloc/bloc.dart';
import 'package:mikrotic_customer/core/constants/cached/cached_helper.dart';
import 'package:mikrotic_customer/core/constants/cached/user_session.dart';
import 'package:mikrotic_customer/core/networking/dio_factory.dart';
import 'package:mikrotic_customer/pages/startup/cubit/startup_state.dart';

enum StartupDestination { home, signin, onboarding }

class StartupCubit extends Cubit<StartupState> {
  StartupCubit() : super(const StartupState.initial());

  Future<void> isLogin() async {
    emit(const StartupState.loading());

    final token = await CacheHelper.getString('token');
    if (token.isNotEmpty) {
      DioFactory.setTokenIntoHeaderAfterLogin(token);
      await UserSession.init();
      await Future.delayed(const Duration(seconds: 2));
      emit(const StartupState.success(StartupDestination.home));
      return;
    }

    final onboardingShown = await CacheHelper.getString('onboarding_shown');
    if (onboardingShown.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 2));
      emit(const StartupState.success(StartupDestination.signin));
    } else {
      await Future.delayed(const Duration(seconds: 2));
      emit(const StartupState.success(StartupDestination.onboarding));
    }
  }
}
