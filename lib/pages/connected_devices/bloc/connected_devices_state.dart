import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mikrotic_customer/pages/connected_devices/bloc/connected_devices_event.dart';
import 'package:mikrotic_customer/pages/connected_devices/model/device_model.dart';

part 'connected_devices_state.freezed.dart';

enum ScanStatus { idle, scanning, completed, error }

@freezed
abstract class ConnectedDevicesState with _$ConnectedDevicesState {
  const ConnectedDevicesState._();

  const factory ConnectedDevicesState({
    @Default(ScanStatus.idle) ScanStatus status,
    @Default([]) List<DeviceModel> devices,
    @Default(0.0) double scanProgress,
    @Default("") String searchQuery,
    @Default(DeviceFilter.all) DeviceFilter filter,
    @Default("") String errorMessage,
    String? currentDeviceIp,
  }) = _ConnectedDevicesState;

  List<DeviceModel> get filteredDevices {
    var filtered = devices;

    // Apply filter
    if (filter == DeviceFilter.active) {
      filtered = filtered.where((d) => d.isActive).toList();
    }

    // Apply search
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((d) {
        return d.ipAddress.toLowerCase().contains(query) ||
            (d.hostname?.toLowerCase().contains(query) ?? false) ||
            (d.macAddress?.toLowerCase().contains(query) ?? false) ||
            (d.vendor?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Sort: current device first, then by IP
    filtered.sort((a, b) {
      if (a.isCurrentDevice && !b.isCurrentDevice) return -1;
      if (!a.isCurrentDevice && b.isCurrentDevice) return 1;
      return _compareIpAddresses(a.ipAddress, b.ipAddress);
    });

    return filtered;
  }

  int _compareIpAddresses(String ip1, String ip2) {
    final parts1 = ip1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final parts2 = ip2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    for (int i = 0; i < 4; i++) {
      if (parts1[i] != parts2[i]) {
        return parts1[i].compareTo(parts2[i]);
      }
    }
    return 0;
  }
}
