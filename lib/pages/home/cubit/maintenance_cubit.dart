import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/pages/home/api/home_api.dart';
import 'package:mikrotic_customer/pages/home/cubit/maintenance_state.dart';

class MaintenanceCubit extends Cubit<MaintenanceState> {
  final HomeApi api;

  MaintenanceCubit(this.api) : super(const MaintenanceState.initial());

  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();

  Future<void> submitRequest({
    required String issueType,
    required String priority,
  }) async {
    if (!formKey.currentState!.validate()) return;

    emit(const MaintenanceState.loading());

    final result = await api.submitMaintenanceRequest(
      issueType: issueType,
      priority: priority,
      description: descriptionController.text.trim(),
    );

    result.when(
      success: (_) {
        descriptionController.clear();
        emit(const MaintenanceState.success());
      },
      failure: (error) {
        emit(MaintenanceState.error(error.message ?? 'حدث خطأ غير متوقع'));
      },
    );
  }

  void resetState() => emit(const MaintenanceState.initial());

  @override
  Future<void> close() {
    descriptionController.dispose();
    return super.close();
  }
}
