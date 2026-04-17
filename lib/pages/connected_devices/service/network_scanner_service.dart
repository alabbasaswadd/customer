import 'dart:async';
import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_tools/network_tools.dart';
import 'package:mikrotic_customer/pages/connected_devices/model/device_model.dart';

class NetworkScannerService {
  final NetworkInfo _networkInfo = NetworkInfo();
  StreamController<DeviceModel>? _deviceStreamController;
  StreamController<double>? _progressStreamController;
  bool _isScanning = false;

  bool get isScanning => _isScanning;

  Future<String?> getDeviceIp() async {
    try {
      return await _networkInfo.getWifiIP();
    } catch (e) {
      return null;
    }
  }

  Future<String?> getSubnet() async {
    final ip = await getDeviceIp();
    if (ip == null) return null;

    final parts = ip.split('.');
    if (parts.length != 4) return null;

    return '${parts[0]}.${parts[1]}.${parts[2]}';
  }

  Stream<DeviceModel> get deviceStream {
    _deviceStreamController ??= StreamController<DeviceModel>.broadcast();
    return _deviceStreamController!.stream;
  }

  Stream<double> get progressStream {
    _progressStreamController ??= StreamController<double>.broadcast();
    return _progressStreamController!.stream;
  }

  Future<List<DeviceModel>> startScan() async {
    if (_isScanning) {
      return [];
    }

    _isScanning = true;
    _deviceStreamController = StreamController<DeviceModel>.broadcast();
    _progressStreamController = StreamController<double>.broadcast();

    final List<DeviceModel> devices = [];
    final deviceIp = await getDeviceIp();
    final subnet = await getSubnet();

    if (subnet == null || deviceIp == null) {
      _isScanning = false;
      return devices;
    }

    try {
      final stream = HostScanner.getAllPingableDevices(
        subnet,
        progressCallback: (progress) {
          _progressStreamController?.add(progress * 100);
        },
      );

      await for (final host in stream) {
        if (!_isScanning) break;

        String? hostname;
        try {
          final result = await InternetAddress(host.address)
              .reverse()
              .timeout(const Duration(seconds: 2));
          hostname = result.host;
        } catch (_) {
          hostname = null;
        }

        final device = DeviceModel(
          ipAddress: host.address,
          hostname: hostname,
          isActive: true,
          isCurrentDevice: host.address == deviceIp,
          lastSeen: DateTime.now(),
        );

        devices.add(device);
        _deviceStreamController?.add(device);
      }

      _progressStreamController?.add(100);
    } catch (e) {
      // Scanning error
    } finally {
      _isScanning = false;
    }

    return devices;
  }

  void stopScan() {
    _isScanning = false;
    _deviceStreamController?.close();
    _progressStreamController?.close();
    _deviceStreamController = null;
    _progressStreamController = null;
  }

  void dispose() {
    stopScan();
  }
}
