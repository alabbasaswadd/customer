import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscriptions_state.freezed.dart';

@freezed
class SubscriptionsState<T> with _$SubscriptionsState<T> {
  const factory SubscriptionsState.initial() = _Initial;
  const factory SubscriptionsState.loading() = Loading;
  const factory SubscriptionsState.success(T data) = Success<T>;
  const factory SubscriptionsState.error(String errorMessage) = Error;
}
