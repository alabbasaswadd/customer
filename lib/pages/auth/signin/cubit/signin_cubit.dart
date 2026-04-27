import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/pages/auth/signin/api/signin_api.dart';
import 'package:mikrotic_customer/pages/auth/signin/cubit/signin_state.dart';
import 'package:mikrotic_customer/pages/auth/signin/model/signin_request_model.dart';

class SigninCubit extends Cubit<SigninState> {
  final SigninApi api;

  SigninCubit(this.api) : super(const SigninState.initial());
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<void> signin() async {
    emit(const SigninState.loading());
    final response = await api.signin(
      SigninRequestModel(
        username: usernameController.text,
        password: passwordController.text,
      ),
    );

    response.when(
      success: (response) {
        emit(SigninState.success(response));
      },
      failure: (error) {
        emit(SigninState.error(error.message ?? error.toString()));
      },
    );
  }
}
