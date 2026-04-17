import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mikrotic_customer/core/constants/enums.dart';
import 'package:mikrotic_customer/pages/auth/signin/model/signin_model.dart';

part 'signin_state.freezed.dart';

@freezed
abstract class SigninState with _$SigninState {
  const factory SigninState({
    @Default(RequestStatus.initial) RequestStatus status,
    SigninModel? data,
    @Default("") String errorMessage,
  }) = _SigninState;
}
