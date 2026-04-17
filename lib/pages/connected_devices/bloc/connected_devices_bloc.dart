import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mikrotic_customer/pages/connected_devices/bloc/connected_devices_event.dart';
import 'package:mikrotic_customer/pages/connected_devices/bloc/connected_devices_state.dart';
import 'package:mikrotic_customer/pages/connected_devices/model/device_model.dart';
import 'package:mikrotic_customer/pages/connected_devices/service/network_scanner_service.dart';

class ConnectedDevicesBloc
    extends Bloc<ConnectedDevicesEvent, ConnectedDevicesState> {
  final NetworkScannerService _scannerService;
  StreamSubscription<DeviceModel>? _deviceSubscription;
  StreamSubscription<double>? _progressSubscription;

  ConnectedDevicesBloc(this._scannerService)
      : super(const ConnectedDevicesState()) {
    on<StartNetworkScan>(_onStartNetworkScan);
    on<StopNetworkScan>(_onStopNetworkScan);
    on<DeviceFound>(_onDeviceFound);
    on<UpdateScanProgress>(_onUpdateScanProgress);
    on<ScanCompleted>(_onScanCompleted);
    on<ScanError>(_onScanError);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
    on<UpdateFilter>(_onUpdateFilter);
  }

  Future<void> _onStartNetworkScan(
    StartNetworkScan event,
    Emitter<ConnectedDevicesState> emit,
  ) async {
    final deviceIp = await _scannerService.getDeviceIp();

    emit(state.copyWith(
      status: ScanStatus.scanning,
      devices: [],
      scanProgress: 0,
      errorMessage: "",
      currentDeviceIp: deviceIp,
    ));

    _deviceSubscription?.cancel();
    _progressSubscription?.cancel();

    _deviceSubscription = _scannerService.deviceStream.listen(
      (device) => add(DeviceFound(device: device)),
      onError: (e) => add(ScanError(message: e.toString())),
    );

    _progressSubscription = _scannerService.progressStream.listen(
      (progress) => add(UpdateScanProgress(progress: progress)),
    );

    try {
      final devices = await _scannerService.startScan();
      add(ScanCompleted(devices: devices));
    } catch (e) {
      add(ScanError(message: e.toString()));
    }
  }

  void _onStopNetworkScan(
    StopNetworkScan event,
    Emitter<ConnectedDevicesState> emit,
  ) {
    _scannerService.stopScan();
    _deviceSubscription?.cancel();
    _progressSubscription?.cancel();

    emit(state.copyWith(
      status: ScanStatus.idle,
      scanProgress: 0,
    ));
  }

  void _onDeviceFound(
    DeviceFound event,
    Emitter<ConnectedDevicesState> emit,
  ) {
    final updatedDevices = List<DeviceModel>.from(state.devices);
    final existingIndex =
        updatedDevices.indexWhere((d) => d.ipAddress == event.device.ipAddress);

    if (existingIndex >= 0) {
      updatedDevices[existingIndex] = event.device;
    } else {
      updatedDevices.add(event.device);
    }

    emit(state.copyWith(devices: updatedDevices));
  }

  void _onUpdateScanProgress(
    UpdateScanProgress event,
    Emitter<ConnectedDevicesState> emit,
  ) {
    emit(state.copyWith(scanProgress: event.progress));
  }

  void _onScanCompleted(
    ScanCompleted event,
    Emitter<ConnectedDevicesState> emit,
  ) {
    emit(state.copyWith(
      status: ScanStatus.completed,
      scanProgress: 100,
    ));
  }

  void _onScanError(
    ScanError event,
    Emitter<ConnectedDevicesState> emit,
  ) {
    emit(state.copyWith(
      status: ScanStatus.error,
      errorMessage: event.message,
    ));
  }

  void _onUpdateSearchQuery(
    UpdateSearchQuery event,
    Emitter<ConnectedDevicesState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onUpdateFilter(
    UpdateFilter event,
    Emitter<ConnectedDevicesState> emit,
  ) {
    emit(state.copyWith(filter: event.filter));
  }

  @override
  Future<void> close() {
    _deviceSubscription?.cancel();
    _progressSubscription?.cancel();
    return super.close();
  }
}
