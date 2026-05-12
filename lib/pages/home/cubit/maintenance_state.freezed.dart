// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$maintenanceIdentity<T>(T value) => value;

/// @nodoc
mixin _$MaintenanceState {

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType && other is MaintenanceState);
}

@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MaintenanceState()';
}

}

/// @nodoc
class $MaintenanceStateCopyWith<$Res> {
  $MaintenanceStateCopyWith(MaintenanceState _, $Res Function(MaintenanceState) __);
}

/// Adds pattern-matching-related methods to [MaintenanceState].
extension MaintenanceStatePatterns on MaintenanceState {

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_MaintenanceInitial value)? initial,
    TResult Function(_MaintenanceLoading value)? loading,
    TResult Function(_MaintenanceSuccess value)? success,
    TResult Function(_MaintenanceError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MaintenanceInitial() when initial != null:
        return initial(_that);
      case _MaintenanceLoading() when loading != null:
        return loading(_that);
      case _MaintenanceSuccess() when success != null:
        return success(_that);
      case _MaintenanceError() when error != null:
        return error(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_MaintenanceInitial value) initial,
    required TResult Function(_MaintenanceLoading value) loading,
    required TResult Function(_MaintenanceSuccess value) success,
    required TResult Function(_MaintenanceError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case _MaintenanceInitial():
        return initial(_that);
      case _MaintenanceLoading():
        return loading(_that);
      case _MaintenanceSuccess():
        return success(_that);
      case _MaintenanceError():
        return error(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_MaintenanceInitial value)? initial,
    TResult? Function(_MaintenanceLoading value)? loading,
    TResult? Function(_MaintenanceSuccess value)? success,
    TResult? Function(_MaintenanceError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _MaintenanceInitial() when initial != null:
        return initial(_that);
      case _MaintenanceLoading() when loading != null:
        return loading(_that);
      case _MaintenanceSuccess() when success != null:
        return success(_that);
      case _MaintenanceError() when error != null:
        return error(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function(String errorMessage)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MaintenanceInitial() when initial != null:
        return initial();
      case _MaintenanceLoading() when loading != null:
        return loading();
      case _MaintenanceSuccess() when success != null:
        return success();
      case _MaintenanceError() when error != null:
        return error(_that.errorMessage);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function(String errorMessage) error,
  }) {
    final _that = this;
    switch (_that) {
      case _MaintenanceInitial():
        return initial();
      case _MaintenanceLoading():
        return loading();
      case _MaintenanceSuccess():
        return success();
      case _MaintenanceError():
        return error(_that.errorMessage);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function(String errorMessage)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _MaintenanceInitial() when initial != null:
        return initial();
      case _MaintenanceLoading() when loading != null:
        return loading();
      case _MaintenanceSuccess() when success != null:
        return success();
      case _MaintenanceError() when error != null:
        return error(_that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc
class _MaintenanceInitial implements MaintenanceState {
  const _MaintenanceInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _MaintenanceInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'MaintenanceState.initial()';
}

/// @nodoc
class _MaintenanceLoading implements MaintenanceState {
  const _MaintenanceLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _MaintenanceLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'MaintenanceState.loading()';
}

/// @nodoc
class _MaintenanceSuccess implements MaintenanceState {
  const _MaintenanceSuccess();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _MaintenanceSuccess);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'MaintenanceState.success()';
}

/// @nodoc
class _MaintenanceError implements MaintenanceState {
  const _MaintenanceError(this.errorMessage);

  final String errorMessage;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $_MaintenanceErrorCopyWith<_MaintenanceError> get copyWith =>
      _$$MaintenanceErrorCopyWithImpl<_MaintenanceError>(
          this, _$maintenanceIdentity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MaintenanceError &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMessage);

  @override
  String toString() =>
      'MaintenanceState.error(errorMessage: $errorMessage)';
}

/// @nodoc
abstract mixin class $_MaintenanceErrorCopyWith<$Res>
    implements $MaintenanceStateCopyWith<$Res> {
  factory $_MaintenanceErrorCopyWith(
          _MaintenanceError value, $Res Function(_MaintenanceError) _then) =
      _$$MaintenanceErrorCopyWithImpl;

  @useResult
  $Res call({String errorMessage});
}

/// @nodoc
class _$$MaintenanceErrorCopyWithImpl<$Res>
    implements $_MaintenanceErrorCopyWith<$Res> {
  _$$MaintenanceErrorCopyWithImpl(this._self, this._then);

  final _MaintenanceError _self;
  final $Res Function(_MaintenanceError) _then;

  @pragma('vm:prefer-inline')
  $Res call({Object? errorMessage = null}) {
    return _then(_MaintenanceError(
      null == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
