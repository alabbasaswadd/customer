import 'dart:async';
import 'dart:io';

import 'package:mikrotic_customer/core/constants/model/error_model.dart';
import 'package:mikrotic_customer/core/networking/api_result.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/device_model.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/network_info_model.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ConnectedDevicesApi {
  final NetworkInfo _networkInfo = NetworkInfo();

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

  /// Scan the local network for connected devices using simple ping
  Future<ApiResult<List<DeviceModel>>> scanNetwork({
    required String subnet,
    required String currentDeviceIp,
    void Function(int progress)? onProgress,
    void Function(DeviceModel device)? onDeviceFound,
  }) async {
    try {
      if (subnet.isEmpty) {
        return ApiResult.failure(
          ErrorModel(message: 'Invalid subnet', errors: {}),
        );
      }

      final List<DeviceModel> devices = [];
      final List<Future<void>> futures = [];
      int scannedCount = 0;
      const totalHosts = 254;

      // Scan IPs 1-254 in the subnet concurrently
      for (int i = 1; i <= 254; i++) {
        final host = '$subnet.$i';

        futures.add(
          _pingHost(host).then((isReachable) {
            scannedCount++;
            final progress = ((scannedCount / totalHosts) * 100).round();
            onProgress?.call(progress);

            if (isReachable) {
              String macAddress = '';

              // Try ARP lookup for MAC address
              _lookupArp(host)
                  .then((mac) {
                    if (mac != null) macAddress = mac;
                  })
                  .catchError((_) {});

              final device = DeviceModel(
                ipAddress: host,
                macAddress: macAddress,
                hostName: _getHostId(host),
                vendor: '',
                isOnline: true,
                isCurrentDevice: host == currentDeviceIp,
              );

              final deviceWithType = device.copyWith(
                deviceType: device.inferDeviceType(),
              );

              devices.add(deviceWithType);
              onDeviceFound?.call(deviceWithType);
            }
          }),
        );
      }

      // Wait for all pings to complete
      await Future.wait(futures);

      onProgress?.call(100);

      // Sort devices: current device first, then by IP
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

  /// Ping a host to check if it's reachable
  Future<bool> _pingHost(String host) async {
    try {
      // Try to connect to common ports to detect if host is alive
      // This is more reliable than ICMP ping on mobile devices
      final socket =
          await Socket.connect(
                host,
                80, // HTTP port
                timeout: const Duration(milliseconds: 300),
              )
              .catchError((_) async {
                // Try port 443 (HTTPS) if 80 fails
                return Socket.connect(
                  host,
                  443,
                  timeout: const Duration(milliseconds: 300),
                );
              })
              .catchError((_) async {
                // Try port 22 (SSH) as fallback
                return Socket.connect(
                  host,
                  22,
                  timeout: const Duration(milliseconds: 200),
                );
              });

      socket.destroy();
      return true;
    } catch (_) {
      // If all connection attempts fail, try a raw socket connection
      try {
        final result = await InternetAddress.lookup(
          host,
        ).timeout(const Duration(milliseconds: 500));
        return result.isNotEmpty;
      } catch (_) {
        return false;
      }
    }
  }

  /// Get a simple host identifier from IP
  String _getHostId(String ip) {
    final parts = ip.split('.');
    if (parts.length == 4) {
      return 'Device ${parts[3]}';
    }
    return ip;
  }

  /// Try to lookup MAC address using ARP
  Future<String?> _lookupArp(String ipAddress) async {
    try {
      if (Platform.isAndroid || Platform.isLinux) {
        final arpFile = File('/proc/net/arp');
        if (await arpFile.exists()) {
          final contents = await arpFile.readAsString();
          final lines = contents.split('\n');
          for (final line in lines) {
            if (line.contains(ipAddress)) {
              final parts = line.split(RegExp(r'\s+'));
              if (parts.length >= 4) {
                final mac = parts[3];
                if (mac != '00:00:00:00:00:00' && mac.contains(':')) {
                  return mac.toUpperCase();
                }
              }
            }
          }
        }
      }
    } catch (_) {}
    return null;
  }

  /// Compare IP addresses for sorting
  int _compareIpAddresses(String ip1, String ip2) {
    final parts1 = ip1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final parts2 = ip2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    for (int i = 0; i < 4; i++) {
      if (parts1[i] != parts2[i]) {
        return parts1[i].compareTo(parts2[i]);
      }
    }
    return 0;
  }
}
