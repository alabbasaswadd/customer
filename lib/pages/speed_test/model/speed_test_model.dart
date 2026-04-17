import 'package:json_annotation/json_annotation.dart';

part 'speed_test_model.g.dart';

@JsonSerializable()
class SpeedTestModel {
  final double downloadSpeed;
  final double uploadSpeed;
  final int ping;
  final DateTime testDate;
  final String? serverName;
  final String? serverLocation;

  SpeedTestModel({
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.ping,
    required this.testDate,
    this.serverName,
    this.serverLocation,
  });

  factory SpeedTestModel.fromJson(Map<String, dynamic> json) {
    return _$SpeedTestModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SpeedTestModelToJson(this);
  }

  SpeedTestModel copyWith({
    double? downloadSpeed,
    double? uploadSpeed,
    int? ping,
    DateTime? testDate,
    String? serverName,
    String? serverLocation,
  }) {
    return SpeedTestModel(
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      uploadSpeed: uploadSpeed ?? this.uploadSpeed,
      ping: ping ?? this.ping,
      testDate: testDate ?? this.testDate,
      serverName: serverName ?? this.serverName,
      serverLocation: serverLocation ?? this.serverLocation,
    );
  }
}
