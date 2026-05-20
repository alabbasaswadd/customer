import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/pages/home/api/home_api.dart';
import 'package:mikrotic_customer/pages/home/cubit/support_state.dart';
import 'package:mikrotic_customer/pages/home/model/complaint_model.dart';

class SupportCubit extends Cubit<SupportState> {
  final HomeApi api;

  SupportCubit(this.api) : super(const SupportState.initial());

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> submitComplaint() async {
    if (!formKey.currentState!.validate()) return;

    emit(const SupportState.loading());

    final complaint = ComplaintModel(
      name: '',
      phone: '',
      subject: titleController.text.trim(),
      message: descriptionController.text.trim(),
    );

    final response = await api.submitComplaint(complaint);

    response.when(
      success: (_) {
        clearForm();
        emit(const SupportState.success());
      },
      failure: (error) {
        emit(SupportState.error(error.message ?? 'Unknown error'));
      },
    );
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
  }

  void resetState() {
    emit(const SupportState.initial());
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
