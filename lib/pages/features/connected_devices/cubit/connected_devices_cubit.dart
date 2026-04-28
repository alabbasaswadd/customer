import 'package:bloc/bloc.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/api/connected_devices_api.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/cubit/connected_devices_state.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/device_model.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/network_info_model.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/scan_result_model.dart';

enum DeviceFilter { all, active }

class ConnectedDevicesCubit extends Cubit<ConnectedDevicesState> {
  final ConnectedDevicesApi api;

  NetworkInfoModel? _networkInfo;
  List<DeviceModel> _devices = [];
  DeviceFilter _filter = DeviceFilter.all;
  bool _isScanning = false;

  ConnectedDevicesCubit(this.api) : super(const ConnectedDevicesState.initial());

  NetworkInfoModel? get networkInfo => _networkInfo;
  DeviceFilter get currentFilter => _filter;
  bool get isScanning => _isScanning;

  /// Load network information only (quick operation)
  Future<void> loadNetworkInfo() async {
    emit(const ConnectedDevicesState.loadingNetworkInfo());

    final result = await api.getNetworkInfo();

    switch (result) {
      case Success(data: final networkInfo):
        _networkInfo = networkInfo;
        emit(ConnectedDevicesState.success(
          ScanResultModel(
            networkInfo: networkInfo,
            devices: [],
          ),
        ));
      case Failure(error: final error):
        emit(ConnectedDevicesState.error(error.message ?? 'Failed to get network info'));
    }
  }

  /// Start a full network scan
  Future<void> startScan() async {
    if (_isScanning) return;

    // First get network info if we don't have it
    if (_networkInfo == null) {
      final networkResult = await api.getNetworkInfo();
      switch (networkResult) {
        case Success(data: final info):
          _networkInfo = info;
        case Failure(error: final error):
          emit(ConnectedDevicesState.error(error.message ?? 'Failed to get network info'));
          return;
      }
    }

    if (_networkInfo == null || !_networkInfo!.isConnected) {
      emit(const ConnectedDevicesState.error('Not connected to a network'));
      return;
    }

    _isScanning = true;
    _devices = [];
    final scanStartTime = DateTime.now();

    emit(ConnectedDevicesState.scanning(
      progress: 0,
      networkInfo: _networkInfo!,
      devicesFound: [],
    ));

    final result = await api.scanNetwork(
      subnet: _networkInfo!.subnet,
      currentDeviceIp: _networkInfo!.ipAddress,
      onProgress: (progress) {
        if (!_isScanning) return;
        emit(ConnectedDevicesState.scanning(
          progress: progress,
          networkInfo: _networkInfo!,
          devicesFound: List.from(_devices),
        ));
      },
      onDeviceFound: (device) {
        if (!_isScanning) return;
        _devices.add(device);
        emit(ConnectedDevicesState.scanning(
          progress: (_devices.length * 10).clamp(0, 99),
          networkInfo: _networkInfo!,
          devicesFound: List.from(_devices),
        ));
      },
    );

    _isScanning = false;

    switch (result) {
      case Success(data: final devices):
        _devices = devices;
        emit(ConnectedDevicesState.success(
          ScanResultModel(
            networkInfo: _networkInfo!,
            devices: devices,
            scanStartTime: scanStartTime,
            scanEndTime: DateTime.now(),
            totalHostsScanned: 254,
          ),
        ));
      case Failure(error: final error):
        emit(ConnectedDevicesState.error(error.message ?? 'Scan failed'));
    }
  }

  /// Set filter for devices
  void setFilter(DeviceFilter filter) {
    _filter = filter;

    // Re-emit current state to trigger UI rebuild using the extension method
    state.whenOrNull(
      success: (data) {
        emit(ConnectedDevicesState.success(data));
      },
      scanning: (progress, networkInfo, devices) {
        emit(ConnectedDevicesState.scanning(
          progress: progress,
          networkInfo: networkInfo,
          devicesFound: devices,
        ));
      },
    );
  }

  /// Get filtered devices based on current filter
  List<DeviceModel> getFilteredDevices(List<DeviceModel> devices) {
    switch (_filter) {
      case DeviceFilter.all:
        return devices;
      case DeviceFilter.active:
        return devices.where((d) => d.isOnline).toList();
    }
  }

  /// Cancel ongoing scan
  void cancelScan() {
    _isScanning = false;
  }

  @override
  Future<void> close() {
    cancelScan();
    return super.close();
  }
}
