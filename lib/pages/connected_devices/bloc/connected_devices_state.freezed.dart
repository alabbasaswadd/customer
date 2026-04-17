// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connected_devices_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectedDevicesState {

 ScanStatus get status; List<DeviceModel> get devices; double get scanProgress; String get searchQuery; DeviceFilter get filter; String get errorMessage; String? get currentDeviceIp;
/// Create a copy of ConnectedDevicesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectedDevicesStateCopyWith<ConnectedDevicesState> get copyWith => _$ConnectedDevicesStateCopyWithImpl<ConnectedDevicesState>(this as ConnectedDevicesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectedDevicesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.devices, devices)&&(identical(other.scanProgress, scanProgress) || other.scanProgress == scanProgress)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.currentDeviceIp, currentDeviceIp) || other.currentDeviceIp == currentDeviceIp));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(devices),scanProgress,searchQuery,filter,errorMessage,currentDeviceIp);

@override
String toString() {
  return 'ConnectedDevicesState(status: $status, devices: $devices, scanProgress: $scanProgress, searchQuery: $searchQuery, filter: $filter, errorMessage: $errorMessage, currentDeviceIp: $currentDeviceIp)';
}


}

/// @nodoc
abstract mixin class $ConnectedDevicesStateCopyWith<$Res>  {
  factory $ConnectedDevicesStateCopyWith(ConnectedDevicesState value, $Res Function(ConnectedDevicesState) _then) = _$ConnectedDevicesStateCopyWithImpl;
@useResult
$Res call({
 ScanStatus status, List<DeviceModel> devices, double scanProgress, String searchQuery, DeviceFilter filter, String errorMessage, String? currentDeviceIp
});




}
/// @nodoc
class _$ConnectedDevicesStateCopyWithImpl<$Res>
    implements $ConnectedDevicesStateCopyWith<$Res> {
  _$ConnectedDevicesStateCopyWithImpl(this._self, this._then);

  final ConnectedDevicesState _self;
  final $Res Function(ConnectedDevicesState) _then;

/// Create a copy of ConnectedDevicesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? devices = null,Object? scanProgress = null,Object? searchQuery = null,Object? filter = null,Object? errorMessage = null,Object? currentDeviceIp = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScanStatus,devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<DeviceModel>,scanProgress: null == scanProgress ? _self.scanProgress : scanProgress // ignore: cast_nullable_to_non_nullable
as double,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as DeviceFilter,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,currentDeviceIp: freezed == currentDeviceIp ? _self.currentDeviceIp : currentDeviceIp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectedDevicesState].
extension ConnectedDevicesStatePatterns on ConnectedDevicesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectedDevicesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectedDevicesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectedDevicesState value)  $default,){
final _that = this;
switch (_that) {
case _ConnectedDevicesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectedDevicesState value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectedDevicesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScanStatus status,  List<DeviceModel> devices,  double scanProgress,  String searchQuery,  DeviceFilter filter,  String errorMessage,  String? currentDeviceIp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectedDevicesState() when $default != null:
return $default(_that.status,_that.devices,_that.scanProgress,_that.searchQuery,_that.filter,_that.errorMessage,_that.currentDeviceIp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScanStatus status,  List<DeviceModel> devices,  double scanProgress,  String searchQuery,  DeviceFilter filter,  String errorMessage,  String? currentDeviceIp)  $default,) {final _that = this;
switch (_that) {
case _ConnectedDevicesState():
return $default(_that.status,_that.devices,_that.scanProgress,_that.searchQuery,_that.filter,_that.errorMessage,_that.currentDeviceIp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScanStatus status,  List<DeviceModel> devices,  double scanProgress,  String searchQuery,  DeviceFilter filter,  String errorMessage,  String? currentDeviceIp)?  $default,) {final _that = this;
switch (_that) {
case _ConnectedDevicesState() when $default != null:
return $default(_that.status,_that.devices,_that.scanProgress,_that.searchQuery,_that.filter,_that.errorMessage,_that.currentDeviceIp);case _:
  return null;

}
}

}

/// @nodoc


class _ConnectedDevicesState extends ConnectedDevicesState {
  const _ConnectedDevicesState({this.status = ScanStatus.idle, final  List<DeviceModel> devices = const [], this.scanProgress = 0.0, this.searchQuery = "", this.filter = DeviceFilter.all, this.errorMessage = "", this.currentDeviceIp}): _devices = devices,super._();
  

@override@JsonKey() final  ScanStatus status;
 final  List<DeviceModel> _devices;
@override@JsonKey() List<DeviceModel> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}

@override@JsonKey() final  double scanProgress;
@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  DeviceFilter filter;
@override@JsonKey() final  String errorMessage;
@override final  String? currentDeviceIp;

/// Create a copy of ConnectedDevicesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectedDevicesStateCopyWith<_ConnectedDevicesState> get copyWith => __$ConnectedDevicesStateCopyWithImpl<_ConnectedDevicesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectedDevicesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._devices, _devices)&&(identical(other.scanProgress, scanProgress) || other.scanProgress == scanProgress)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.currentDeviceIp, currentDeviceIp) || other.currentDeviceIp == currentDeviceIp));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_devices),scanProgress,searchQuery,filter,errorMessage,currentDeviceIp);

@override
String toString() {
  return 'ConnectedDevicesState(status: $status, devices: $devices, scanProgress: $scanProgress, searchQuery: $searchQuery, filter: $filter, errorMessage: $errorMessage, currentDeviceIp: $currentDeviceIp)';
}


}

/// @nodoc
abstract mixin class _$ConnectedDevicesStateCopyWith<$Res> implements $ConnectedDevicesStateCopyWith<$Res> {
  factory _$ConnectedDevicesStateCopyWith(_ConnectedDevicesState value, $Res Function(_ConnectedDevicesState) _then) = __$ConnectedDevicesStateCopyWithImpl;
@override @useResult
$Res call({
 ScanStatus status, List<DeviceModel> devices, double scanProgress, String searchQuery, DeviceFilter filter, String errorMessage, String? currentDeviceIp
});




}
/// @nodoc
class __$ConnectedDevicesStateCopyWithImpl<$Res>
    implements _$ConnectedDevicesStateCopyWith<$Res> {
  __$ConnectedDevicesStateCopyWithImpl(this._self, this._then);

  final _ConnectedDevicesState _self;
  final $Res Function(_ConnectedDevicesState) _then;

/// Create a copy of ConnectedDevicesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? devices = null,Object? scanProgress = null,Object? searchQuery = null,Object? filter = null,Object? errorMessage = null,Object? currentDeviceIp = freezed,}) {
  return _then(_ConnectedDevicesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScanStatus,devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<DeviceModel>,scanProgress: null == scanProgress ? _self.scanProgress : scanProgress // ignore: cast_nullable_to_non_nullable
as double,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as DeviceFilter,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,currentDeviceIp: freezed == currentDeviceIp ? _self.currentDeviceIp : currentDeviceIp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
