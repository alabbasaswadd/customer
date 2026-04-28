import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/device_model.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/network_info_model.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/scan_result_model.dart';

part 'connected_devices_state.freezed.dart';

@freezed
sealed class ConnectedDevicesState with _$ConnectedDevicesState {
  const factory ConnectedDevicesState.initial() = ConnectedDevicesInitial;

  const factory ConnectedDevicesState.loadingNetworkInfo() = ConnectedDevicesLoadingNetworkInfo;

  const factory ConnectedDevicesState.scanning({
    required int progress,
    required NetworkInfoModel networkInfo,
    required List<DeviceModel> devicesFound,
  }) = ConnectedDevicesScanning;

  const factory ConnectedDevicesState.success(ScanResultModel data) = ConnectedDevicesSuccess;

  const factory ConnectedDevicesState.error(String message) = ConnectedDevicesError;
}
