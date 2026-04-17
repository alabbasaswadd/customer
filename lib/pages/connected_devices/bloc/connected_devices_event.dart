import 'package:mikrotic_customer/pages/connected_devices/model/device_model.dart';

abstract class ConnectedDevicesEvent {}

class StartNetworkScan extends ConnectedDevicesEvent {}

class StopNetworkScan extends ConnectedDevicesEvent {}

class DeviceFound extends ConnectedDevicesEvent {
  final DeviceModel device;

  DeviceFound({required this.device});
}

class UpdateScanProgress extends ConnectedDevicesEvent {
  final double progress;

  UpdateScanProgress({required this.progress});
}

class ScanCompleted extends ConnectedDevicesEvent {
  final List<DeviceModel> devices;

  ScanCompleted({required this.devices});
}

class ScanError extends ConnectedDevicesEvent {
  final String message;

  ScanError({required this.message});
}

class UpdateSearchQuery extends ConnectedDevicesEvent {
  final String query;

  UpdateSearchQuery({required this.query});
}

class UpdateFilter extends ConnectedDevicesEvent {
  final DeviceFilter filter;

  UpdateFilter({required this.filter});
}

enum DeviceFilter { all, active }
