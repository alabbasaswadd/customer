// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speed_test_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeedTestState {

 SpeedTestPhase get phase; double get currentDownloadSpeed; double get currentUploadSpeed; int get ping; double get downloadProgress; double get uploadProgress; double get finalDownloadSpeed; double get finalUploadSpeed; SpeedTestModel? get result; String get errorMessage;
/// Create a copy of SpeedTestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeedTestStateCopyWith<SpeedTestState> get copyWith => _$SpeedTestStateCopyWithImpl<SpeedTestState>(this as SpeedTestState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeedTestState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.currentDownloadSpeed, currentDownloadSpeed) || other.currentDownloadSpeed == currentDownloadSpeed)&&(identical(other.currentUploadSpeed, currentUploadSpeed) || other.currentUploadSpeed == currentUploadSpeed)&&(identical(other.ping, ping) || other.ping == ping)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.finalDownloadSpeed, finalDownloadSpeed) || other.finalDownloadSpeed == finalDownloadSpeed)&&(identical(other.finalUploadSpeed, finalUploadSpeed) || other.finalUploadSpeed == finalUploadSpeed)&&(identical(other.result, result) || other.result == result)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,phase,currentDownloadSpeed,currentUploadSpeed,ping,downloadProgress,uploadProgress,finalDownloadSpeed,finalUploadSpeed,result,errorMessage);

@override
String toString() {
  return 'SpeedTestState(phase: $phase, currentDownloadSpeed: $currentDownloadSpeed, currentUploadSpeed: $currentUploadSpeed, ping: $ping, downloadProgress: $downloadProgress, uploadProgress: $uploadProgress, finalDownloadSpeed: $finalDownloadSpeed, finalUploadSpeed: $finalUploadSpeed, result: $result, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SpeedTestStateCopyWith<$Res>  {
  factory $SpeedTestStateCopyWith(SpeedTestState value, $Res Function(SpeedTestState) _then) = _$SpeedTestStateCopyWithImpl;
@useResult
$Res call({
 SpeedTestPhase phase, double currentDownloadSpeed, double currentUploadSpeed, int ping, double downloadProgress, double uploadProgress, double finalDownloadSpeed, double finalUploadSpeed, SpeedTestModel? result, String errorMessage
});




}
/// @nodoc
class _$SpeedTestStateCopyWithImpl<$Res>
    implements $SpeedTestStateCopyWith<$Res> {
  _$SpeedTestStateCopyWithImpl(this._self, this._then);

  final SpeedTestState _self;
  final $Res Function(SpeedTestState) _then;

/// Create a copy of SpeedTestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? currentDownloadSpeed = null,Object? currentUploadSpeed = null,Object? ping = null,Object? downloadProgress = null,Object? uploadProgress = null,Object? finalDownloadSpeed = null,Object? finalUploadSpeed = null,Object? result = freezed,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as SpeedTestPhase,currentDownloadSpeed: null == currentDownloadSpeed ? _self.currentDownloadSpeed : currentDownloadSpeed // ignore: cast_nullable_to_non_nullable
as double,currentUploadSpeed: null == currentUploadSpeed ? _self.currentUploadSpeed : currentUploadSpeed // ignore: cast_nullable_to_non_nullable
as double,ping: null == ping ? _self.ping : ping // ignore: cast_nullable_to_non_nullable
as int,downloadProgress: null == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as double,uploadProgress: null == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double,finalDownloadSpeed: null == finalDownloadSpeed ? _self.finalDownloadSpeed : finalDownloadSpeed // ignore: cast_nullable_to_non_nullable
as double,finalUploadSpeed: null == finalUploadSpeed ? _self.finalUploadSpeed : finalUploadSpeed // ignore: cast_nullable_to_non_nullable
as double,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as SpeedTestModel?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeedTestState].
extension SpeedTestStatePatterns on SpeedTestState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeedTestState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeedTestState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeedTestState value)  $default,){
final _that = this;
switch (_that) {
case _SpeedTestState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeedTestState value)?  $default,){
final _that = this;
switch (_that) {
case _SpeedTestState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SpeedTestPhase phase,  double currentDownloadSpeed,  double currentUploadSpeed,  int ping,  double downloadProgress,  double uploadProgress,  double finalDownloadSpeed,  double finalUploadSpeed,  SpeedTestModel? result,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeedTestState() when $default != null:
return $default(_that.phase,_that.currentDownloadSpeed,_that.currentUploadSpeed,_that.ping,_that.downloadProgress,_that.uploadProgress,_that.finalDownloadSpeed,_that.finalUploadSpeed,_that.result,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SpeedTestPhase phase,  double currentDownloadSpeed,  double currentUploadSpeed,  int ping,  double downloadProgress,  double uploadProgress,  double finalDownloadSpeed,  double finalUploadSpeed,  SpeedTestModel? result,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SpeedTestState():
return $default(_that.phase,_that.currentDownloadSpeed,_that.currentUploadSpeed,_that.ping,_that.downloadProgress,_that.uploadProgress,_that.finalDownloadSpeed,_that.finalUploadSpeed,_that.result,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SpeedTestPhase phase,  double currentDownloadSpeed,  double currentUploadSpeed,  int ping,  double downloadProgress,  double uploadProgress,  double finalDownloadSpeed,  double finalUploadSpeed,  SpeedTestModel? result,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SpeedTestState() when $default != null:
return $default(_that.phase,_that.currentDownloadSpeed,_that.currentUploadSpeed,_that.ping,_that.downloadProgress,_that.uploadProgress,_that.finalDownloadSpeed,_that.finalUploadSpeed,_that.result,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SpeedTestState implements SpeedTestState {
  const _SpeedTestState({this.phase = SpeedTestPhase.idle, this.currentDownloadSpeed = 0.0, this.currentUploadSpeed = 0.0, this.ping = 0, this.downloadProgress = 0.0, this.uploadProgress = 0.0, this.finalDownloadSpeed = 0.0, this.finalUploadSpeed = 0.0, this.result, this.errorMessage = ""});
  

@override@JsonKey() final  SpeedTestPhase phase;
@override@JsonKey() final  double currentDownloadSpeed;
@override@JsonKey() final  double currentUploadSpeed;
@override@JsonKey() final  int ping;
@override@JsonKey() final  double downloadProgress;
@override@JsonKey() final  double uploadProgress;
@override@JsonKey() final  double finalDownloadSpeed;
@override@JsonKey() final  double finalUploadSpeed;
@override final  SpeedTestModel? result;
@override@JsonKey() final  String errorMessage;

/// Create a copy of SpeedTestState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeedTestStateCopyWith<_SpeedTestState> get copyWith => __$SpeedTestStateCopyWithImpl<_SpeedTestState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeedTestState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.currentDownloadSpeed, currentDownloadSpeed) || other.currentDownloadSpeed == currentDownloadSpeed)&&(identical(other.currentUploadSpeed, currentUploadSpeed) || other.currentUploadSpeed == currentUploadSpeed)&&(identical(other.ping, ping) || other.ping == ping)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.finalDownloadSpeed, finalDownloadSpeed) || other.finalDownloadSpeed == finalDownloadSpeed)&&(identical(other.finalUploadSpeed, finalUploadSpeed) || other.finalUploadSpeed == finalUploadSpeed)&&(identical(other.result, result) || other.result == result)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,phase,currentDownloadSpeed,currentUploadSpeed,ping,downloadProgress,uploadProgress,finalDownloadSpeed,finalUploadSpeed,result,errorMessage);

@override
String toString() {
  return 'SpeedTestState(phase: $phase, currentDownloadSpeed: $currentDownloadSpeed, currentUploadSpeed: $currentUploadSpeed, ping: $ping, downloadProgress: $downloadProgress, uploadProgress: $uploadProgress, finalDownloadSpeed: $finalDownloadSpeed, finalUploadSpeed: $finalUploadSpeed, result: $result, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SpeedTestStateCopyWith<$Res> implements $SpeedTestStateCopyWith<$Res> {
  factory _$SpeedTestStateCopyWith(_SpeedTestState value, $Res Function(_SpeedTestState) _then) = __$SpeedTestStateCopyWithImpl;
@override @useResult
$Res call({
 SpeedTestPhase phase, double currentDownloadSpeed, double currentUploadSpeed, int ping, double downloadProgress, double uploadProgress, double finalDownloadSpeed, double finalUploadSpeed, SpeedTestModel? result, String errorMessage
});




}
/// @nodoc
class __$SpeedTestStateCopyWithImpl<$Res>
    implements _$SpeedTestStateCopyWith<$Res> {
  __$SpeedTestStateCopyWithImpl(this._self, this._then);

  final _SpeedTestState _self;
  final $Res Function(_SpeedTestState) _then;

/// Create a copy of SpeedTestState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? currentDownloadSpeed = null,Object? currentUploadSpeed = null,Object? ping = null,Object? downloadProgress = null,Object? uploadProgress = null,Object? finalDownloadSpeed = null,Object? finalUploadSpeed = null,Object? result = freezed,Object? errorMessage = null,}) {
  return _then(_SpeedTestState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as SpeedTestPhase,currentDownloadSpeed: null == currentDownloadSpeed ? _self.currentDownloadSpeed : currentDownloadSpeed // ignore: cast_nullable_to_non_nullable
as double,currentUploadSpeed: null == currentUploadSpeed ? _self.currentUploadSpeed : currentUploadSpeed // ignore: cast_nullable_to_non_nullable
as double,ping: null == ping ? _self.ping : ping // ignore: cast_nullable_to_non_nullable
as int,downloadProgress: null == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as double,uploadProgress: null == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double,finalDownloadSpeed: null == finalDownloadSpeed ? _self.finalDownloadSpeed : finalDownloadSpeed // ignore: cast_nullable_to_non_nullable
as double,finalUploadSpeed: null == finalUploadSpeed ? _self.finalUploadSpeed : finalUploadSpeed // ignore: cast_nullable_to_non_nullable
as double,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as SpeedTestModel?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
