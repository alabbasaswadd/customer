// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanResultModel _$ScanResultModelFromJson(Map<String, dynamic> json) =>
    ScanResultModel(
      networkInfo: NetworkInfoModel.fromJson(
        json['networkInfo'] as Map<String, dynamic>,
      ),
      devices:
          (json['devices'] as List<dynamic>?)
              ?.map((e) => DeviceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      scanStartTime: json['scanStartTime'] == null
          ? null
          : DateTime.parse(json['scanStartTime'] as String),
      scanEndTime: json['scanEndTime'] == null
          ? null
          : DateTime.parse(json['scanEndTime'] as String),
      totalHostsScanned: (json['totalHostsScanned'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ScanResultModelToJson(ScanResultModel instance) =>
    <String, dynamic>{
      'networkInfo': instance.networkInfo,
      'devices': instance.devices,
      'scanStartTime': instance.scanStartTime?.toIso8601String(),
      'scanEndTime': instance.scanEndTime?.toIso8601String(),
      'totalHostsScanned': instance.totalHostsScanned,
    };
