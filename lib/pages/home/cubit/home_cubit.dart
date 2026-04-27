import 'package:bloc/bloc.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/pages/home/api/home_api.dart';
import 'package:mikrotic_customer/pages/home/cubit/home_state.dart';
import 'package:mikrotic_customer/pages/home/model/user_model.dart';

class HomeCubit extends Cubit<HomeState<UserModel>> {
  final HomeApi api;

  HomeCubit(this.api) : super(const HomeState.initial());

  Future<void> loadUserProfile() async {
    emit(const HomeState.loading());

    final response = await api.getUserProfile();

    response.when(
      success: (user) {
        emit(HomeState.success(user));
      },
      failure: (error) {
        emit(HomeState.error(error.message ?? 'Unknown error'));
      },
    );
  }

  Future<void> refreshData() async {
    final response = await api.getUserProfile();

    response.when(
      success: (user) {
        emit(HomeState.success(user));
      },
      failure: (error) {
        emit(HomeState.error(error.message ?? 'Unknown error'));
      },
    );
  }
}
