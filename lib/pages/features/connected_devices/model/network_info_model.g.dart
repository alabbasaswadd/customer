// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkInfoModel _$NetworkInfoModelFromJson(Map<String, dynamic> json) =>
    NetworkInfoModel(
      wifiName: json['wifiName'] as String? ?? '',
      wifiBSSID: json['wifiBSSID'] as String? ?? '',
      ipAddress: json['ipAddress'] as String? ?? '',
      gatewayIp: json['gatewayIp'] as String? ?? '',
      subnetMask: json['subnetMask'] as String? ?? '',
      broadcast: json['broadcast'] as String? ?? '',
      isConnected: json['isConnected'] as bool? ?? false,
    );

Map<String, dynamic> _$NetworkInfoModelToJson(NetworkInfoModel instance) =>
    <String, dynamic>{
      'wifiName': instance.wifiName,
      'wifiBSSID': instance.wifiBSSID,
      'ipAddress': instance.ipAddress,
      'gatewayIp': instance.gatewayIp,
      'subnetMask': instance.subnetMask,
      'broadcast': instance.broadcast,
      'isConnected': instance.isConnected,
    };
