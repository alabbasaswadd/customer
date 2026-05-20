import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/constants/base_cubit.dart';
import 'package:mikrotic_customer/pages/features/complaint/api/complaint_api.dart';
import 'package:mikrotic_customer/pages/features/complaint/cubit/complaint_state.dart';
import 'package:mikrotic_customer/pages/features/complaint/model/complaint_request_model.dart';

class ComplaintCubit extends BaseCubit<ComplaintState> {
  ComplaintCubit(super.initialState, this.api);
  final ComplaintApi api;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void resetState() => emit(const ComplaintState.initial());

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
  }

  Future<void> addComplaint() async {
    if (!validateForm()) return;
    await executeApi(
      onLoading: () => emit(const ComplaintState.loading()),
      request: () => api.addComplaint(
        ComplaintRequestModel(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          attachmentUrl: null,
        ),
      ),
      onSuccess: (response) async {
        clearForm();
        emit(ComplaintState.success(response));
      },
      onError: (message) {
        emit(ComplaintState.error(message));
      },
    );
  }

  Future<void> loadComplaints() async {
    await executeApi(
      onLoading: () => emit(const ComplaintState.loading()),
      request: () => api.getComplaints(),
      onSuccess: (response) async {
        emit(ComplaintState.success(response));
      },
      onError: (message) {
        emit(ComplaintState.error(message));
      },
    );
  }

  Future<void> deleteComplaint(String id) async {
    await executeApi(
      onLoading: () => emit(const ComplaintState.loading()),
      request: () => api.deleteComplaint(id),
      onSuccess: (_) async {
        await loadComplaints();
      },
      onError: (message) {
        emit(ComplaintState.error(message));
      },
    );
  }

  Future<void> updateComplaint(String id) async {
    if (!validateForm()) return;
    await executeApi(
      onLoading: () => emit(const ComplaintState.loading()),
      request: () => api.updateComplaint(
        id,
        ComplaintRequestModel(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          attachmentUrl: null,
        ),
      ),
      onSuccess: (response) async {
        emit(ComplaintState.success(response));
        await loadComplaints();
      },
      onError: (message) {
        emit(ComplaintState.error(message));
      },
    );
  }
}
