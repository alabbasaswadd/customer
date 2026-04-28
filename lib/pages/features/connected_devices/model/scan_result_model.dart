import 'package:json_annotation/json_annotation.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/device_model.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/network_info_model.dart';

part 'scan_result_model.g.dart';

@JsonSerializable()
class ScanResultModel {
  final NetworkInfoModel networkInfo;
  final List<DeviceModel> devices;
  final DateTime? scanStartTime;
  final DateTime? scanEndTime;
  final int totalHostsScanned;

  ScanResultModel({
    required this.networkInfo,
    this.devices = const [],
    this.scanStartTime,
    this.scanEndTime,
    this.totalHostsScanned = 0,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) =>
      _$ScanResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScanResultModelToJson(this);

  /// Create a copy with modified fields
  ScanResultModel copyWith({
    NetworkInfoModel? networkInfo,
    List<DeviceModel>? devices,
    DateTime? scanStartTime,
    DateTime? scanEndTime,
    int? totalHostsScanned,
  }) {
    return ScanResultModel(
      networkInfo: networkInfo ?? this.networkInfo,
      devices: devices ?? this.devices,
      scanStartTime: scanStartTime ?? this.scanStartTime,
      scanEndTime: scanEndTime ?? this.scanEndTime,
      totalHostsScanned: totalHostsScanned ?? this.totalHostsScanned,
    );
  }

  /// Get duration of the scan in seconds
  int get scanDurationSeconds {
    if (scanStartTime == null || scanEndTime == null) return 0;
    return scanEndTime!.difference(scanStartTime!).inSeconds;
  }

  /// Get count of online devices
  int get onlineDevicesCount => devices.where((d) => d.isOnline).length;

  /// Get count of offline devices
  int get offlineDevicesCount => devices.where((d) => !d.isOnline).length;

  /// Get devices filtered by online status
  List<DeviceModel> getDevicesByStatus({required bool onlineOnly}) {
    if (onlineOnly) {
      return devices.where((d) => d.isOnline).toList();
    }
    return devices;
  }
}
