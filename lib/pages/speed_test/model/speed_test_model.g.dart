// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speed_test_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeedTestModel _$SpeedTestModelFromJson(Map<String, dynamic> json) =>
    SpeedTestModel(
      downloadSpeed: (json['downloadSpeed'] as num).toDouble(),
      uploadSpeed: (json['uploadSpeed'] as num).toDouble(),
      ping: (json['ping'] as num).toInt(),
      testDate: DateTime.parse(json['testDate'] as String),
      serverName: json['serverName'] as String?,
      serverLocation: json['serverLocation'] as String?,
    );

Map<String, dynamic> _$SpeedTestModelToJson(SpeedTestModel instance) =>
    <String, dynamic>{
      'downloadSpeed': instance.downloadSpeed,
      'uploadSpeed': instance.uploadSpeed,
      'ping': instance.ping,
      'testDate': instance.testDate.toIso8601String(),
      'serverName': instance.serverName,
      'serverLocation': instance.serverLocation,
    };
