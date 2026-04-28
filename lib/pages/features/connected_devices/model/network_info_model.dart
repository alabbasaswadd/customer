import 'package:json_annotation/json_annotation.dart';

part 'network_info_model.g.dart';

@JsonSerializable()
class NetworkInfoModel {
  final String wifiName;
  final String wifiBSSID;
  final String ipAddress;
  final String gatewayIp;
  final String subnetMask;
  final String broadcast;
  final bool isConnected;

  NetworkInfoModel({
    this.wifiName = '',
    this.wifiBSSID = '',
    this.ipAddress = '',
    this.gatewayIp = '',
    this.subnetMask = '',
    this.broadcast = '',
    this.isConnected = false,
  });

  factory NetworkInfoModel.fromJson(Map<String, dynamic> json) =>
      _$NetworkInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkInfoModelToJson(this);

  /// Create a copy with modified fields
  NetworkInfoModel copyWith({
    String? wifiName,
    String? wifiBSSID,
    String? ipAddress,
    String? gatewayIp,
    String? subnetMask,
    String? broadcast,
    bool? isConnected,
  }) {
    return NetworkInfoModel(
      wifiName: wifiName ?? this.wifiName,
      wifiBSSID: wifiBSSID ?? this.wifiBSSID,
      ipAddress: ipAddress ?? this.ipAddress,
      gatewayIp: gatewayIp ?? this.gatewayIp,
      subnetMask: subnetMask ?? this.subnetMask,
      broadcast: broadcast ?? this.broadcast,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  /// Extract subnet prefix for network scanning (e.g., "192.168.1")
  String get subnet {
    if (ipAddress.isEmpty) return '';
    final parts = ipAddress.split('.');
    if (parts.length != 4) return '';
    return '${parts[0]}.${parts[1]}.${parts[2]}';
  }

  /// Get the last octet of the IP address
  int get lastOctet {
    if (ipAddress.isEmpty) return 0;
    final parts = ipAddress.split('.');
    if (parts.length != 4) return 0;
    return int.tryParse(parts[3]) ?? 0;
  }

  /// Clean WiFi name (remove quotes if present)
  String get cleanWifiName {
    if (wifiName.isEmpty) return 'Unknown Network';
    // network_info_plus sometimes returns WiFi name with quotes
    return wifiName.replaceAll('"', '').replaceAll('<', '').replaceAll('>', '');
  }
}
