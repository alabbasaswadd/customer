import 'package:bloc/bloc.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/pages/home/api/home_api.dart';
import 'package:mikrotic_customer/pages/home/cubit/subscriptions_state.dart';
import 'package:mikrotic_customer/pages/home/model/subscription_plan_model.dart';

class SubscriptionsCubit extends Cubit<SubscriptionsState<List<SubscriptionPlanModel>>> {
  final HomeApi api;

  SubscriptionsCubit(this.api) : super(const SubscriptionsState.initial());

  Future<void> loadPlans() async {
    emit(const SubscriptionsState.loading());

    final response = await api.getSubscriptionPlans();

    response.when(
      success: (plans) {
        emit(SubscriptionsState.success(plans));
      },
      failure: (error) {
        emit(SubscriptionsState.error(error.message ?? 'Unknown error'));
      },
    );
  }

  Future<void> selectPlan(SubscriptionPlanModel plan) async {
    // Handle plan selection - ready for API integration
  }
}
