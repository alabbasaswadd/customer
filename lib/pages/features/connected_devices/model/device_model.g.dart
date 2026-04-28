// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) => DeviceModel(
  ipAddress: json['ipAddress'] as String,
  macAddress: json['macAddress'] as String? ?? '',
  hostName: json['hostName'] as String? ?? '',
  vendor: json['vendor'] as String? ?? '',
  deviceType:
      $enumDecodeNullable(_$DeviceTypeEnumMap, json['deviceType']) ??
      DeviceType.other,
  isOnline: json['isOnline'] as bool? ?? true,
  isCurrentDevice: json['isCurrentDevice'] as bool? ?? false,
);

Map<String, dynamic> _$DeviceModelToJson(DeviceModel instance) =>
    <String, dynamic>{
      'ipAddress': instance.ipAddress,
      'macAddress': instance.macAddress,
      'hostName': instance.hostName,
      'vendor': instance.vendor,
      'deviceType': _$DeviceTypeEnumMap[instance.deviceType]!,
      'isOnline': instance.isOnline,
      'isCurrentDevice': instance.isCurrentDevice,
    };

const _$DeviceTypeEnumMap = {
  DeviceType.phone: 'phone',
  DeviceType.laptop: 'laptop',
  DeviceType.tablet: 'tablet',
  DeviceType.tv: 'tv',
  DeviceType.router: 'router',
  DeviceType.printer: 'printer',
  DeviceType.camera: 'camera',
  DeviceType.speaker: 'speaker',
  DeviceType.other: 'other',
};
