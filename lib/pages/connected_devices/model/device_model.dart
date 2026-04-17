import 'package:json_annotation/json_annotation.dart';

part 'device_model.g.dart';

@JsonSerializable()
class DeviceModel {
  final String ipAddress;
  final String? macAddress;
  final String? hostname;
  final String? vendor;
  final bool isActive;
  final bool isCurrentDevice;
  final DateTime? lastSeen;

  DeviceModel({
    required this.ipAddress,
    this.macAddress,
    this.hostname,
    this.vendor,
    this.isActive = true,
    this.isCurrentDevice = false,
    this.lastSeen,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return _$DeviceModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeviceModelToJson(this);
  }

  DeviceModel copyWith({
    String? ipAddress,
    String? macAddress,
    String? hostname,
    String? vendor,
    bool? isActive,
    bool? isCurrentDevice,
    DateTime? lastSeen,
  }) {
    return DeviceModel(
      ipAddress: ipAddress ?? this.ipAddress,
      macAddress: macAddress ?? this.macAddress,
      hostname: hostname ?? this.hostname,
      vendor: vendor ?? this.vendor,
      isActive: isActive ?? this.isActive,
      isCurrentDevice: isCurrentDevice ?? this.isCurrentDevice,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceModel &&
          runtimeType == other.runtimeType &&
          ipAddress == other.ipAddress;

  @override
  int get hashCode => ipAddress.hashCode;
}
