import 'package:mikrotic_customer/core/constants/model/error_model.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/pages/home/model/complaint_model.dart';
import 'package:mikrotic_customer/pages/home/model/subscription_plan_model.dart';
import 'package:mikrotic_customer/pages/home/model/user_model.dart';

class HomeApi {
  HomeApi();

  /// Fetch user profile data
  Future<ApiResult<UserModel>> getUserProfile() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return ApiResult.success(UserModel.mock());
    } catch (e) {
      return ApiResult.failure(ErrorModel(message: e.toString(), errors: {}));
    }
  }

  /// Refresh user balance
  Future<ApiResult<double>> refreshBalance() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const ApiResult.success(150.00);
    } catch (e) {
      return ApiResult.failure(ErrorModel(message: e.toString(), errors: {}));
    }
  }

  /// Get subscription plans
  Future<ApiResult<List<SubscriptionPlanModel>>> getSubscriptionPlans() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return ApiResult.success(SubscriptionPlanModel.mockPlans());
    } catch (e) {
      return ApiResult.failure(ErrorModel(message: e.toString(), errors: {}));
    }
  }

  /// Submit complaint
  Future<ApiResult<bool>> submitComplaint(ComplaintModel complaint) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      return const ApiResult.success(true);
    } catch (e) {
      return ApiResult.failure(ErrorModel(message: e.toString(), errors: {}));
    }
  }

  /// Submit maintenance request
  Future<ApiResult<bool>> submitMaintenanceRequest({
    required String issueType,
    required String priority,
    required String description,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      return const ApiResult.success(true);
    } catch (e) {
      return ApiResult.failure(ErrorModel(message: e.toString(), errors: {}));
    }
  }
}
