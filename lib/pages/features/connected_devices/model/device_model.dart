import 'package:json_annotation/json_annotation.dart';

part 'device_model.g.dart';

enum DeviceType {
  phone,
  laptop,
  tablet,
  tv,
  router,
  printer,
  camera,
  speaker,
  other,
}

@JsonSerializable()
class DeviceModel {
  final String ipAddress;
  final String macAddress;
  final String hostName;
  final String vendor;
  final DeviceType deviceType;
  final bool isOnline;
  final bool isCurrentDevice;

  DeviceModel({
    required this.ipAddress,
    this.macAddress = '',
    this.hostName = '',
    this.vendor = '',
    this.deviceType = DeviceType.other,
    this.isOnline = true,
    this.isCurrentDevice = false,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);

  /// Create a copy with modified fields
  DeviceModel copyWith({
    String? ipAddress,
    String? macAddress,
    String? hostName,
    String? vendor,
    DeviceType? deviceType,
    bool? isOnline,
    bool? isCurrentDevice,
  }) {
    return DeviceModel(
      ipAddress: ipAddress ?? this.ipAddress,
      macAddress: macAddress ?? this.macAddress,
      hostName: hostName ?? this.hostName,
      vendor: vendor ?? this.vendor,
      deviceType: deviceType ?? this.deviceType,
      isOnline: isOnline ?? this.isOnline,
      isCurrentDevice: isCurrentDevice ?? this.isCurrentDevice,
    );
  }

  /// Infer device type from vendor name and hostname
  DeviceType inferDeviceType() {
    final vendorLower = vendor.toLowerCase();
    final hostLower = hostName.toLowerCase();
    final combined = '$vendorLower $hostLower';

    // Phone manufacturers
    if (combined.contains('apple') &&
        (combined.contains('iphone') || combined.contains('ios'))) {
      return DeviceType.phone;
    }
    if (combined.contains('samsung') &&
        (combined.contains('galaxy') || combined.contains('android'))) {
      return DeviceType.phone;
    }
    if (combined.contains('xiaomi') ||
        combined.contains('huawei') ||
        combined.contains('oppo') ||
        combined.contains('vivo') ||
        combined.contains('oneplus') ||
        combined.contains('realme')) {
      return DeviceType.phone;
    }
    if (combined.contains('android') || combined.contains('phone')) {
      return DeviceType.phone;
    }

    // Laptops/Computers
    if (combined.contains('macbook') ||
        combined.contains('imac') ||
        combined.contains('mac-')) {
      return DeviceType.laptop;
    }
    if (combined.contains('dell') ||
        combined.contains('hp') ||
        combined.contains('lenovo') ||
        combined.contains('asus') ||
        combined.contains('acer') ||
        combined.contains('thinkpad') ||
        combined.contains('laptop') ||
        combined.contains('desktop') ||
        combined.contains('pc')) {
      return DeviceType.laptop;
    }

    // Tablets
    if (combined.contains('ipad') || combined.contains('tablet')) {
      return DeviceType.tablet;
    }

    // TVs
    if (combined.contains('tv') ||
        combined.contains('roku') ||
        combined.contains('chromecast') ||
        combined.contains('firestick') ||
        combined.contains('android-tv') ||
        combined.contains('smart-tv') ||
        combined.contains('lg') && combined.contains('webos')) {
      return DeviceType.tv;
    }

    // Routers/Network
    if (combined.contains('router') ||
        combined.contains('gateway') ||
        combined.contains('mikrotik') ||
        combined.contains('ubiquiti') ||
        combined.contains('netgear') ||
        combined.contains('tp-link') ||
        combined.contains('tplink') ||
        combined.contains('d-link') ||
        combined.contains('dlink') ||
        combined.contains('cisco')) {
      return DeviceType.router;
    }

    // Printers
    if (combined.contains('printer') ||
        combined.contains('epson') ||
        combined.contains('canon') ||
        combined.contains('brother') ||
        combined.contains('xerox')) {
      return DeviceType.printer;
    }

    // Cameras
    if (combined.contains('camera') ||
        combined.contains('hikvision') ||
        combined.contains('dahua') ||
        combined.contains('ring') ||
        combined.contains('nest') ||
        combined.contains('wyze')) {
      return DeviceType.camera;
    }

    // Speakers
    if (combined.contains('speaker') ||
        combined.contains('sonos') ||
        combined.contains('alexa') ||
        combined.contains('echo') ||
        combined.contains('homepod') ||
        combined.contains('google-home')) {
      return DeviceType.speaker;
    }

    return DeviceType.other;
  }

  /// Get the display name - prefer hostname, fallback to vendor, then IP
  String get displayName {
    if (hostName.isNotEmpty) return hostName;
    if (vendor.isNotEmpty) return vendor;
    return ipAddress;
  }
}
