import 'package:bloc/bloc.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/core/constants/enums.dart';
import 'package:mikrotic_customer/pages/auth/signin/api/signin_api.dart';
import 'package:mikrotic_customer/pages/auth/signin/bloc/signin_event.dart';
import 'package:mikrotic_customer/pages/auth/signin/bloc/signin_state.dart';
import 'package:mikrotic_customer/pages/auth/signin/model/signin_request_model.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final SigninApi api;

  SigninBloc(this.api) : super(const SigninState()) {
    on<SigninRequested>(_signin);
  }

  Future<void> _signin(SigninRequested event, Emitter<SigninState> emit) async {
    emit(state.copyWith(status: RequestStatus.loading));

    final result = await api.signin(
      request: SigninRequestModel(
        username: event.username,
        password: event.password,
      ),
    );

    result.when(
      success: (response) {
        if (response.succeeded == true) {
          emit(
            state.copyWith(status: RequestStatus.success, data: response.data),
          );
        } else {
          emit(
            state.copyWith(
              status: RequestStatus.error,
              errorMessage: response.error?.message ?? "Unknown error",
            ),
          );
        }
      },
      failure: (error) {
        emit(state.copyWith(status: RequestStatus.error, errorMessage: error));
      },
    );
  }
}
