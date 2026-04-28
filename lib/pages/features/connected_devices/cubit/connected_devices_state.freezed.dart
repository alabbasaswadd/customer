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





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectedDevicesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectedDevicesState()';
}


}

/// @nodoc
class $ConnectedDevicesStateCopyWith<$Res>  {
$ConnectedDevicesStateCopyWith(ConnectedDevicesState _, $Res Function(ConnectedDevicesState) __);
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ConnectedDevicesInitial value)?  initial,TResult Function( ConnectedDevicesLoadingNetworkInfo value)?  loadingNetworkInfo,TResult Function( ConnectedDevicesScanning value)?  scanning,TResult Function( ConnectedDevicesSuccess value)?  success,TResult Function( ConnectedDevicesError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ConnectedDevicesInitial() when initial != null:
return initial(_that);case ConnectedDevicesLoadingNetworkInfo() when loadingNetworkInfo != null:
return loadingNetworkInfo(_that);case ConnectedDevicesScanning() when scanning != null:
return scanning(_that);case ConnectedDevicesSuccess() when success != null:
return success(_that);case ConnectedDevicesError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ConnectedDevicesInitial value)  initial,required TResult Function( ConnectedDevicesLoadingNetworkInfo value)  loadingNetworkInfo,required TResult Function( ConnectedDevicesScanning value)  scanning,required TResult Function( ConnectedDevicesSuccess value)  success,required TResult Function( ConnectedDevicesError value)  error,}){
final _that = this;
switch (_that) {
case ConnectedDevicesInitial():
return initial(_that);case ConnectedDevicesLoadingNetworkInfo():
return loadingNetworkInfo(_that);case ConnectedDevicesScanning():
return scanning(_that);case ConnectedDevicesSuccess():
return success(_that);case ConnectedDevicesError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ConnectedDevicesInitial value)?  initial,TResult? Function( ConnectedDevicesLoadingNetworkInfo value)?  loadingNetworkInfo,TResult? Function( ConnectedDevicesScanning value)?  scanning,TResult? Function( ConnectedDevicesSuccess value)?  success,TResult? Function( ConnectedDevicesError value)?  error,}){
final _that = this;
switch (_that) {
case ConnectedDevicesInitial() when initial != null:
return initial(_that);case ConnectedDevicesLoadingNetworkInfo() when loadingNetworkInfo != null:
return loadingNetworkInfo(_that);case ConnectedDevicesScanning() when scanning != null:
return scanning(_that);case ConnectedDevicesSuccess() when success != null:
return success(_that);case ConnectedDevicesError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loadingNetworkInfo,TResult Function( int progress,  NetworkInfoModel networkInfo,  List<DeviceModel> devicesFound)?  scanning,TResult Function( ScanResultModel data)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ConnectedDevicesInitial() when initial != null:
return initial();case ConnectedDevicesLoadingNetworkInfo() when loadingNetworkInfo != null:
return loadingNetworkInfo();case ConnectedDevicesScanning() when scanning != null:
return scanning(_that.progress,_that.networkInfo,_that.devicesFound);case ConnectedDevicesSuccess() when success != null:
return success(_that.data);case ConnectedDevicesError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loadingNetworkInfo,required TResult Function( int progress,  NetworkInfoModel networkInfo,  List<DeviceModel> devicesFound)  scanning,required TResult Function( ScanResultModel data)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ConnectedDevicesInitial():
return initial();case ConnectedDevicesLoadingNetworkInfo():
return loadingNetworkInfo();case ConnectedDevicesScanning():
return scanning(_that.progress,_that.networkInfo,_that.devicesFound);case ConnectedDevicesSuccess():
return success(_that.data);case ConnectedDevicesError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loadingNetworkInfo,TResult? Function( int progress,  NetworkInfoModel networkInfo,  List<DeviceModel> devicesFound)?  scanning,TResult? Function( ScanResultModel data)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ConnectedDevicesInitial() when initial != null:
return initial();case ConnectedDevicesLoadingNetworkInfo() when loadingNetworkInfo != null:
return loadingNetworkInfo();case ConnectedDevicesScanning() when scanning != null:
return scanning(_that.progress,_that.networkInfo,_that.devicesFound);case ConnectedDevicesSuccess() when success != null:
return success(_that.data);case ConnectedDevicesError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ConnectedDevicesInitial implements ConnectedDevicesState {
  const ConnectedDevicesInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectedDevicesInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectedDevicesState.initial()';
}


}




/// @nodoc


class ConnectedDevicesLoadingNetworkInfo implements ConnectedDevicesState {
  const ConnectedDevicesLoadingNetworkInfo();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectedDevicesLoadingNetworkInfo);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectedDevicesState.loadingNetworkInfo()';
}


}




/// @nodoc


class ConnectedDevicesScanning implements ConnectedDevicesState {
  const ConnectedDevicesScanning({required this.progress, required this.networkInfo, required final  List<DeviceModel> devicesFound}): _devicesFound = devicesFound;
  

 final  int progress;
 final  NetworkInfoModel networkInfo;
 final  List<DeviceModel> _devicesFound;
 List<DeviceModel> get devicesFound {
  if (_devicesFound is EqualUnmodifiableListView) return _devicesFound;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devicesFound);
}


/// Create a copy of ConnectedDevicesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectedDevicesScanningCopyWith<ConnectedDevicesScanning> get copyWith => _$ConnectedDevicesScanningCopyWithImpl<ConnectedDevicesScanning>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectedDevicesScanning&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.networkInfo, networkInfo) || other.networkInfo == networkInfo)&&const DeepCollectionEquality().equals(other._devicesFound, _devicesFound));
}


@override
int get hashCode => Object.hash(runtimeType,progress,networkInfo,const DeepCollectionEquality().hash(_devicesFound));

@override
String toString() {
  return 'ConnectedDevicesState.scanning(progress: $progress, networkInfo: $networkInfo, devicesFound: $devicesFound)';
}


}

/// @nodoc
abstract mixin class $ConnectedDevicesScanningCopyWith<$Res> implements $ConnectedDevicesStateCopyWith<$Res> {
  factory $ConnectedDevicesScanningCopyWith(ConnectedDevicesScanning value, $Res Function(ConnectedDevicesScanning) _then) = _$ConnectedDevicesScanningCopyWithImpl;
@useResult
$Res call({
 int progress, NetworkInfoModel networkInfo, List<DeviceModel> devicesFound
});




}
/// @nodoc
class _$ConnectedDevicesScanningCopyWithImpl<$Res>
    implements $ConnectedDevicesScanningCopyWith<$Res> {
  _$ConnectedDevicesScanningCopyWithImpl(this._self, this._then);

  final ConnectedDevicesScanning _self;
  final $Res Function(ConnectedDevicesScanning) _then;

/// Create a copy of ConnectedDevicesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? progress = null,Object? networkInfo = null,Object? devicesFound = null,}) {
  return _then(ConnectedDevicesScanning(
progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,networkInfo: null == networkInfo ? _self.networkInfo : networkInfo // ignore: cast_nullable_to_non_nullable
as NetworkInfoModel,devicesFound: null == devicesFound ? _self._devicesFound : devicesFound // ignore: cast_nullable_to_non_nullable
as List<DeviceModel>,
  ));
}


}

/// @nodoc


class ConnectedDevicesSuccess implements ConnectedDevicesState {
  const ConnectedDevicesSuccess(this.data);
  

 final  ScanResultModel data;

/// Create a copy of ConnectedDevicesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectedDevicesSuccessCopyWith<ConnectedDevicesSuccess> get copyWith => _$ConnectedDevicesSuccessCopyWithImpl<ConnectedDevicesSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectedDevicesSuccess&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ConnectedDevicesState.success(data: $data)';
}


}

/// @nodoc
abstract mixin class $ConnectedDevicesSuccessCopyWith<$Res> implements $ConnectedDevicesStateCopyWith<$Res> {
  factory $ConnectedDevicesSuccessCopyWith(ConnectedDevicesSuccess value, $Res Function(ConnectedDevicesSuccess) _then) = _$ConnectedDevicesSuccessCopyWithImpl;
@useResult
$Res call({
 ScanResultModel data
});




}
/// @nodoc
class _$ConnectedDevicesSuccessCopyWithImpl<$Res>
    implements $ConnectedDevicesSuccessCopyWith<$Res> {
  _$ConnectedDevicesSuccessCopyWithImpl(this._self, this._then);

  final ConnectedDevicesSuccess _self;
  final $Res Function(ConnectedDevicesSuccess) _then;

/// Create a copy of ConnectedDevicesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(ConnectedDevicesSuccess(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ScanResultModel,
  ));
}


}

/// @nodoc


class ConnectedDevicesError implements ConnectedDevicesState {
  const ConnectedDevicesError(this.message);
  

 final  String message;

/// Create a copy of ConnectedDevicesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectedDevicesErrorCopyWith<ConnectedDevicesError> get copyWith => _$ConnectedDevicesErrorCopyWithImpl<ConnectedDevicesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectedDevicesError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ConnectedDevicesState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ConnectedDevicesErrorCopyWith<$Res> implements $ConnectedDevicesStateCopyWith<$Res> {
  factory $ConnectedDevicesErrorCopyWith(ConnectedDevicesError value, $Res Function(ConnectedDevicesError) _then) = _$ConnectedDevicesErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ConnectedDevicesErrorCopyWithImpl<$Res>
    implements $ConnectedDevicesErrorCopyWith<$Res> {
  _$ConnectedDevicesErrorCopyWithImpl(this._self, this._then);

  final ConnectedDevicesError _self;
  final $Res Function(ConnectedDevicesError) _then;

/// Create a copy of ConnectedDevicesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ConnectedDevicesError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
