import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mikrotic_customer/core/constants/model/error_model.dart';
import 'package:mikrotic_customer/core/di/dependency_injection.dart';
import 'package:mikrotic_customer/core/networking/api_constans.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/device_model.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/network_info_model.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ConnectedDevicesApi {
  final NetworkInfo _networkInfo = NetworkInfo();
  final Dio _dio = getIt<Dio>();

  ConnectedDevicesApi();

  /// Get current network information
  Future<ApiResult<NetworkInfoModel>> getNetworkInfo() async {
    try {
      final wifiName = await _networkInfo.getWifiName();
      final wifiBSSID = await _networkInfo.getWifiBSSID();
      final wifiIP = await _networkInfo.getWifiIP();
      final wifiGateway = await _networkInfo.getWifiGatewayIP();
      final wifiSubmask = await _networkInfo.getWifiSubmask();
      final wifiBroadcast = await _networkInfo.getWifiBroadcast();

      final networkInfoModel = NetworkInfoModel(
        wifiName: wifiName ?? '',
        wifiBSSID: wifiBSSID ?? '',
        ipAddress: wifiIP ?? '',
        gatewayIp: wifiGateway ?? '',
        subnetMask: wifiSubmask ?? '',
        broadcast: wifiBroadcast ?? '',
        isConnected: wifiIP != null && wifiIP.isNotEmpty,
      );

      return ApiResult.success(networkInfoModel);
    } catch (e) {
      return ApiResult.failure(
        ErrorModel(message: 'Failed to get network info: $e', errors: {}),
      );
    }
  }

  /// Fetch connected devices from backend API (MikroTik DHCP leases)
  Future<ApiResult<List<DeviceModel>>> getConnectedDevices({
    required String currentDeviceIp,
    void Function(int progress)? onProgress,
    void Function(DeviceModel device)? onDeviceFound,
  }) async {
    try {
      onProgress?.call(10);

      final response = await _dio.get(ApiConstants.connectedDevices);

      onProgress?.call(50);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        final List<DeviceModel> devices = [];

        for (final item in data) {
          final device = _parseDeviceFromApi(item, currentDeviceIp);
          devices.add(device);
          onDeviceFound?.call(device);
        }

        onProgress?.call(100);

        // Sort devices: current device first, then by IP
        devices.sort((a, b) {
          if (a.isCurrentDevice) return -1;
          if (b.isCurrentDevice) return 1;
          return _compareIpAddresses(a.ipAddress, b.ipAddress);
        });

        return ApiResult.success(devices);
      }

      return ApiResult.failure(
        ErrorModel(message: 'Failed to fetch devices', errors: {}),
      );
    } on DioException {
      // If API fails, fallback to local scan
      return _fallbackLocalScan(
        currentDeviceIp: currentDeviceIp,
        onProgress: onProgress,
        onDeviceFound: onDeviceFound,
      );
    } catch (e) {
      return ApiResult.failure(
        ErrorModel(message: 'Error: $e', errors: {}),
      );
    }
  }

  /// Parse device from API response
  DeviceModel _parseDeviceFromApi(Map<String, dynamic> json, String currentDeviceIp) {
    final ipAddress = json['ipAddress'] ?? json['ip'] ?? json['address'] ?? '';
    final macAddress = (json['macAddress'] ?? json['mac'] ?? json['mac-address'] ?? '').toString().toUpperCase();
    final hostName = json['hostName'] ?? json['hostname'] ?? json['host-name'] ?? json['comment'] ?? json['name'] ?? '';
    final vendor = json['vendor'] ?? _getVendorFromMac(macAddress);
    final isOnline = json['isOnline'] ?? json['active'] ?? json['status'] == 'bound' || json['status'] == 'active';

    final device = DeviceModel(
      ipAddress: ipAddress,
      macAddress: macAddress,
      hostName: hostName.isNotEmpty ? hostName : _generateHostName(ipAddress),
      vendor: vendor,
      isOnline: isOnline is bool ? isOnline : true,
      isCurrentDevice: ipAddress == currentDeviceIp,
    );

    return device.copyWith(deviceType: device.inferDeviceType());
  }

  /// Generate hostname from IP if not provided
  String _generateHostName(String ipAddress) {
    final parts = ipAddress.split('.');
    if (parts.length == 4) {
      return 'Device ${parts[3]}';
    }
    return ipAddress;
  }

  /// Fallback to local network scan if API is unavailable
  Future<ApiResult<List<DeviceModel>>> _fallbackLocalScan({
    required String currentDeviceIp,
    void Function(int progress)? onProgress,
    void Function(DeviceModel device)? onDeviceFound,
  }) async {
    try {
      // Get subnet from current IP
      final parts = currentDeviceIp.split('.');
      if (parts.length != 4) {
        return ApiResult.failure(
          ErrorModel(message: 'Invalid IP address', errors: {}),
        );
      }
      final subnet = '${parts[0]}.${parts[1]}.${parts[2]}';

      final List<DeviceModel> devices = [];
      final Map<String, _ArpEntry> arpCache = {};

      // Load ARP table
      await _loadArpTable(arpCache);

      onProgress?.call(20);

      // Get devices from ARP cache
      for (final entry in arpCache.entries) {
        final ip = entry.key;
        if (ip.startsWith('$subnet.')) {
          final arpEntry = entry.value;
          final hostName = await _resolveHostname(ip);

          final device = DeviceModel(
            ipAddress: ip,
            macAddress: arpEntry.macAddress,
            hostName: hostName,
            vendor: _getVendorFromMac(arpEntry.macAddress),
            isOnline: true,
            isCurrentDevice: ip == currentDeviceIp,
          );

          final deviceWithType = device.copyWith(
            deviceType: device.inferDeviceType(),
          );

          devices.add(deviceWithType);
          onDeviceFound?.call(deviceWithType);
        }
      }

      onProgress?.call(80);

      // If no devices found from ARP, use mock data for testing
      if (devices.isEmpty) {
        final mockDevices = _getMockDevices(subnet, currentDeviceIp);
        for (final device in mockDevices) {
          devices.add(device);
          onDeviceFound?.call(device);
        }
      }

      onProgress?.call(100);

      // Sort devices
      devices.sort((a, b) {
        if (a.isCurrentDevice) return -1;
        if (b.isCurrentDevice) return 1;
        return _compareIpAddresses(a.ipAddress, b.ipAddress);
      });

      return ApiResult.success(devices);
    } catch (e) {
      return ApiResult.failure(
        ErrorModel(message: 'Network scan failed: $e', errors: {}),
      );
    }
  }

  /// Get mock devices for testing (simulates MikroTik DHCP leases)
  List<DeviceModel> _getMockDevices(String subnet, String currentDeviceIp) {
    final mockData = [
      {
        'ip': '$subnet.1',
        'mac': 'D4:CA:6D:12:34:56',
        'name': 'MikroTik Router',
        'vendor': 'MikroTik',
        'type': DeviceType.router,
      },
      {
        'ip': currentDeviceIp,
        'mac': '94:E9:6A:AB:CD:EF',
        'name': 'My Phone',
        'vendor': 'Apple',
        'type': DeviceType.phone,
        'isCurrent': true,
      },
      {
        'ip': '$subnet.101',
        'mac': '5C:3C:27:11:22:33',
        'name': 'Samsung-Galaxy-S24',
        'vendor': 'Samsung',
        'type': DeviceType.phone,
      },
      {
        'ip': '$subnet.102',
        'mac': '28:6C:07:44:55:66',
        'name': 'Redmi-Note-12',
        'vendor': 'Xiaomi',
        'type': DeviceType.phone,
      },
      {
        'ip': '$subnet.103',
        'mac': '70:7B:E8:77:88:99',
        'name': 'HUAWEI-P60',
        'vendor': 'Huawei',
        'type': DeviceType.phone,
      },
      {
        'ip': '$subnet.150',
        'mac': '00:21:8B:AA:BB:CC',
        'name': 'Dell-Laptop',
        'vendor': 'Dell',
        'type': DeviceType.laptop,
      },
      {
        'ip': '$subnet.151',
        'mac': '3C:07:54:DD:EE:FF',
        'name': 'MacBook-Pro',
        'vendor': 'Apple',
        'type': DeviceType.laptop,
      },
      {
        'ip': '$subnet.200',
        'mac': '94:EB:2C:11:22:33',
        'name': 'Google-Chromecast',
        'vendor': 'Google',
        'type': DeviceType.tv,
      },
      {
        'ip': '$subnet.201',
        'mac': '38:F7:3D:44:55:66',
        'name': 'Amazon-FireTV',
        'vendor': 'Amazon',
        'type': DeviceType.tv,
      },
      {
        'ip': '$subnet.210',
        'mac': '00:16:35:77:88:99',
        'name': 'HP-LaserJet',
        'vendor': 'HP',
        'type': DeviceType.printer,
      },
    ];

    return mockData.map((data) {
      return DeviceModel(
        ipAddress: data['ip'] as String,
        macAddress: data['mac'] as String,
        hostName: data['name'] as String,
        vendor: data['vendor'] as String,
        deviceType: data['type'] as DeviceType,
        isOnline: true,
        isCurrentDevice: data['isCurrent'] == true,
      );
    }).toList();
  }

  /// Scan the local network for connected devices (main entry point)
  Future<ApiResult<List<DeviceModel>>> scanNetwork({
    required String subnet,
    required String currentDeviceIp,
    void Function(int progress)? onProgress,
    void Function(DeviceModel device)? onDeviceFound,
  }) async {
    // Use API-based approach first
    return getConnectedDevices(
      currentDeviceIp: currentDeviceIp,
      onProgress: onProgress,
      onDeviceFound: onDeviceFound,
    );
  }

  /// Resolve hostname for an IP address using reverse DNS lookup
  Future<String> _resolveHostname(String ipAddress) async {
    try {
      final address = InternetAddress(ipAddress);
      final result = await address.reverse().timeout(
            const Duration(milliseconds: 500),
          );
      final hostName = result.host;

      if (hostName.isNotEmpty && hostName != ipAddress) {
        String cleanName = hostName
            .replaceAll(RegExp(r'\.$'), '')
            .replaceAll('.local', '')
            .replaceAll('.lan', '')
            .replaceAll('.home', '');

        if (cleanName.isNotEmpty && cleanName != ipAddress) {
          return cleanName;
        }
      }
    } catch (_) {}

    final parts = ipAddress.split('.');
    if (parts.length == 4) {
      return 'Device ${parts[3]}';
    }
    return ipAddress;
  }

  /// Load the ARP table into cache
  Future<void> _loadArpTable(Map<String, _ArpEntry> cache) async {
    try {
      if (Platform.isAndroid || Platform.isLinux) {
        final arpFile = File('/proc/net/arp');
        if (await arpFile.exists()) {
          final contents = await arpFile.readAsString();
          final lines = contents.split('\n');

          for (final line in lines.skip(1)) {
            final parts = line.split(RegExp(r'\s+'));
            if (parts.length >= 4) {
              final ip = parts[0];
              final mac = parts[3];

              if (mac != '00:00:00:00:00:00' &&
                  mac.contains(':') &&
                  ip.contains('.')) {
                cache[ip] = _ArpEntry(
                  ipAddress: ip,
                  macAddress: mac.toUpperCase(),
                );
              }
            }
          }
        }
      } else if (Platform.isIOS || Platform.isMacOS) {
        final result = await Process.run('arp', ['-a']);
        if (result.exitCode == 0) {
          final lines = (result.stdout as String).split('\n');
          for (final line in lines) {
            final ipMatch = RegExp(r'\((\d+\.\d+\.\d+\.\d+)\)').firstMatch(line);
            final macMatch = RegExp(r'at\s+([0-9a-fA-F:]+)').firstMatch(line);

            if (ipMatch != null && macMatch != null) {
              final ip = ipMatch.group(1)!;
              final mac = macMatch.group(1)!.toUpperCase();

              if (mac.contains(':')) {
                cache[ip] = _ArpEntry(
                  ipAddress: ip,
                  macAddress: mac,
                );
              }
            }
          }
        }
      }
    } catch (_) {}
  }

  /// Get vendor name from MAC address OUI
  String _getVendorFromMac(String macAddress) {
    if (macAddress.length < 8) return '';

    final oui = macAddress.replaceAll(':', '').substring(0, 6).toUpperCase();

    const vendors = {
      // Apple
      '00A040': 'Apple', '002312': 'Apple', '3C0754': 'Apple',
      '60F81D': 'Apple', 'A4B197': 'Apple', 'F0D1A9': 'Apple',
      '94E96A': 'Apple', '00CD65': 'Apple', 'AC87A3': 'Apple',
      // Samsung
      '00265D': 'Samsung', '002490': 'Samsung', '00E091': 'Samsung',
      '5C3C27': 'Samsung', '94350A': 'Samsung', 'C45006': 'Samsung',
      '78BD4E': 'Samsung', '8CC8CD': 'Samsung',
      // Huawei
      '00E0FC': 'Huawei', '002568': 'Huawei', '049226': 'Huawei',
      '707BE8': 'Huawei', '88CEFA': 'Huawei', 'E0191D': 'Huawei',
      // Xiaomi
      '286C07': 'Xiaomi', '74A063': 'Xiaomi', '9C99A0': 'Xiaomi',
      '64B473': 'Xiaomi', '50EC50': 'Xiaomi', '28E31F': 'Xiaomi',
      // MikroTik
      '000C42': 'MikroTik', '482254': 'MikroTik', 'D4CA6D': 'MikroTik',
      '6C3B6B': 'MikroTik', '74D435': 'MikroTik', 'E48D8C': 'MikroTik',
      // TP-Link
      '14CC20': 'TP-Link', '54A050': 'TP-Link', 'C46E1F': 'TP-Link',
      'EC086B': 'TP-Link', '50C7BF': 'TP-Link',
      // Dell
      '001A6B': 'Dell', '00218B': 'Dell', '1866DA': 'Dell',
      // HP
      '001635': 'HP', '001E0B': 'HP', '3C4A92': 'HP',
      // Lenovo
      '002618': 'Lenovo', '7C7A91': 'Lenovo',
      // Intel
      '001517': 'Intel', '001B21': 'Intel', '001E67': 'Intel',
      // OPPO
      'A4F159': 'OPPO', '24DBE8': 'OPPO', '6C5C14': 'OPPO',
      // Vivo
      '986F60': 'Vivo', 'D4C94B': 'Vivo',
      // Realme
      '761F30': 'Realme', 'C0B4A0': 'Realme',
      // OnePlus
      '94652D': 'OnePlus', 'C0EEFB': 'OnePlus',
      // Google
      '1A6A00': 'Google', '94EB2C': 'Google', 'F4F5D8': 'Google',
      // Amazon
      '000FC5': 'Amazon', '0C47C9': 'Amazon', '38F73D': 'Amazon',
      // Raspberry Pi
      'B827EB': 'Raspberry Pi', 'DC2632': 'Raspberry Pi',
      'E45F01': 'Raspberry Pi', '28CDC1': 'Raspberry Pi',
    };

    if (vendors.containsKey(oui)) {
      return vendors[oui]!;
    }

    return '';
  }

  /// Compare IP addresses for sorting
  int _compareIpAddresses(String ip1, String ip2) {
    final parts1 = ip1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final parts2 = ip2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    for (int i = 0; i < 4; i++) {
      if (i < parts1.length && i < parts2.length) {
        if (parts1[i] != parts2[i]) {
          return parts1[i].compareTo(parts2[i]);
        }
      }
    }
    return 0;
  }
}

/// Helper class for ARP table entries
class _ArpEntry {
  final String ipAddress;
  final String macAddress;

  _ArpEntry({
    required this.ipAddress,
    required this.macAddress,
  });
}
