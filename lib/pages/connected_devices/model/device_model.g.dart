// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) => DeviceModel(
  ipAddress: json['ipAddress'] as String,
  macAddress: json['macAddress'] as String?,
  hostname: json['hostname'] as String?,
  vendor: json['vendor'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  isCurrentDevice: json['isCurrentDevice'] as bool? ?? false,
  lastSeen: json['lastSeen'] == null
      ? null
      : DateTime.parse(json['lastSeen'] as String),
);

Map<String, dynamic> _$DeviceModelToJson(DeviceModel instance) =>
    <String, dynamic>{
      'ipAddress': instance.ipAddress,
      'macAddress': instance.macAddress,
      'hostname': instance.hostname,
      'vendor': instance.vendor,
      'isActive': instance.isActive,
      'isCurrentDevice': instance.isCurrentDevice,
      'lastSeen': instance.lastSeen?.toIso8601String(),
    };
