import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_state.freezed.dart';

@freezed
class SupportState with _$SupportState {
  const factory SupportState.initial() = _Initial;
  const factory SupportState.loading() = Loading;
  const factory SupportState.success() = Success;
  const factory SupportState.error(String errorMessage) = Error;
}
