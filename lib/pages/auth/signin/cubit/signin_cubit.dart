import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/constants/cached/cached_helper.dart';
import 'package:mikrotic_customer/core/constants/cached/user_session.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/core/networking/dio_factory.dart';
import 'package:mikrotic_customer/pages/auth/signin/api/signin_api.dart';
import 'package:mikrotic_customer/pages/auth/signin/cubit/signin_state.dart';
import 'package:mikrotic_customer/pages/auth/signin/model/signin_request_model.dart';

class SigninCubit extends Cubit<SigninState> {
  final SigninApi api;

  SigninCubit(this.api) : super(const SigninState.initial());
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signin() async {
    if (!(formKey.currentState as FormState).validate()) return;
    emit(const SigninState.loading());
    final response = await api.signin(
      SigninRequestModel(
        email: emailController.text,
        password: passwordController.text,
      ),
    );

    response.when(
      success: (response) async {
        if (response.succeeded == true) {
          final token = response.data!.token;
          UserSession.saveUser(response.data!);
          await CacheHelper.setString('token', token);
          DioFactory.setTokenIntoHeaderAfterLogin(token);
          emit(SigninState.success(response));
        } else {
          final message = response.error?.message ?? 'فشل تسجيل الدخول';
          emit(SigninState.error(message));
        }
      },
      failure: (error) {
        emit(SigninState.error(error.message ?? 'حدث خطأ، حاول مرة أخرى'));
      },
    );
  }
}
