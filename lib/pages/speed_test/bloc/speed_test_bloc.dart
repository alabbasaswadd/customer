import 'package:bloc/bloc.dart';
import 'package:flutter_internet_speed_test_pro/flutter_internet_speed_test_pro.dart';
import 'package:mikrotic_customer/pages/speed_test/bloc/speed_test_event.dart';
import 'package:mikrotic_customer/pages/speed_test/bloc/speed_test_state.dart';
import 'package:mikrotic_customer/pages/speed_test/model/speed_test_model.dart';

class SpeedTestBloc extends Bloc<SpeedTestEvent, SpeedTestState> {
  final FlutterInternetSpeedTest _speedTest = FlutterInternetSpeedTest();

  SpeedTestBloc() : super(const SpeedTestState()) {
    on<StartSpeedTest>(_onStartSpeedTest);
    on<StopSpeedTest>(_onStopSpeedTest);
    on<UpdateDownloadSpeed>(_onUpdateDownloadSpeed);
    on<UpdateUploadSpeed>(_onUpdateUploadSpeed);
    on<UpdatePing>(_onUpdatePing);
    on<DownloadTestComplete>(_onDownloadTestComplete);
    on<UploadTestComplete>(_onUploadTestComplete);
    on<SpeedTestCompleted>(_onSpeedTestCompleted);
    on<SpeedTestError>(_onSpeedTestError);
    on<ResetSpeedTest>(_onResetSpeedTest);
  }

  Future<void> _onStartSpeedTest(
    StartSpeedTest event,
    Emitter<SpeedTestState> emit,
  ) async {
    emit(state.copyWith(
      phase: SpeedTestPhase.testingDownload,
      currentDownloadSpeed: 0,
      currentUploadSpeed: 0,
      ping: 0,
      downloadProgress: 0,
      uploadProgress: 0,
      finalDownloadSpeed: 0,
      finalUploadSpeed: 0,
      errorMessage: "",
      result: null,
    ));

    try {
      await _speedTest.startTesting(
        onStarted: () {},
        onCompleted: (TestResult download, TestResult upload) {
          add(SpeedTestCompleted());
        },
        onProgress: (double percent, TestResult data) {
          if (data.type == TestType.download) {
            // Update ping from durationInMillis if available (approximation)
            if (data.durationInMillis > 0 && percent < 10) {
              add(UpdatePing(ping: (data.durationInMillis / 10).round()));
            }
            add(UpdateDownloadSpeed(
              speed: data.transferRate,
              progress: percent,
            ));
          } else {
            add(UpdateUploadSpeed(
              speed: data.transferRate,
              progress: percent,
            ));
          }
        },
        onError: (String errorMessage, String speedTestError) {
          add(SpeedTestError(message: errorMessage));
        },
        onDefaultServerSelectionInProgress: () {},
        onDefaultServerSelectionDone: (Client? client) {
          // Ping is measured during the download test
        },
        onDownloadComplete: (TestResult data) {
          add(DownloadTestComplete(speed: data.transferRate));
        },
        onUploadComplete: (TestResult data) {
          add(UploadTestComplete(speed: data.transferRate));
        },
        onCancel: () {
          add(ResetSpeedTest());
        },
      );
    } catch (e) {
      add(SpeedTestError(message: e.toString()));
    }
  }

  Future<void> _onStopSpeedTest(
    StopSpeedTest event,
    Emitter<SpeedTestState> emit,
  ) async {
    _speedTest.cancelTest();
    emit(state.copyWith(phase: SpeedTestPhase.idle));
  }

  void _onUpdateDownloadSpeed(
    UpdateDownloadSpeed event,
    Emitter<SpeedTestState> emit,
  ) {
    emit(state.copyWith(
      phase: SpeedTestPhase.testingDownload,
      currentDownloadSpeed: event.speed,
      downloadProgress: event.progress,
    ));
  }

  void _onUpdateUploadSpeed(
    UpdateUploadSpeed event,
    Emitter<SpeedTestState> emit,
  ) {
    emit(state.copyWith(
      phase: SpeedTestPhase.testingUpload,
      currentUploadSpeed: event.speed,
      uploadProgress: event.progress,
    ));
  }

  void _onUpdatePing(
    UpdatePing event,
    Emitter<SpeedTestState> emit,
  ) {
    emit(state.copyWith(ping: event.ping));
  }

  void _onDownloadTestComplete(
    DownloadTestComplete event,
    Emitter<SpeedTestState> emit,
  ) {
    emit(state.copyWith(
      finalDownloadSpeed: event.speed,
      downloadProgress: 100,
      phase: SpeedTestPhase.testingUpload,
    ));
  }

  void _onUploadTestComplete(
    UploadTestComplete event,
    Emitter<SpeedTestState> emit,
  ) {
    emit(state.copyWith(
      finalUploadSpeed: event.speed,
      uploadProgress: 100,
    ));
  }

  void _onSpeedTestCompleted(
    SpeedTestCompleted event,
    Emitter<SpeedTestState> emit,
  ) {
    final result = SpeedTestModel(
      downloadSpeed: state.finalDownloadSpeed,
      uploadSpeed: state.finalUploadSpeed,
      ping: state.ping,
      testDate: DateTime.now(),
    );

    emit(state.copyWith(
      phase: SpeedTestPhase.completed,
      result: result,
    ));
  }

  void _onSpeedTestError(
    SpeedTestError event,
    Emitter<SpeedTestState> emit,
  ) {
    emit(state.copyWith(
      phase: SpeedTestPhase.error,
      errorMessage: event.message,
    ));
  }

  void _onResetSpeedTest(
    ResetSpeedTest event,
    Emitter<SpeedTestState> emit,
  ) {
    emit(const SpeedTestState());
  }

  @override
  Future<void> close() {
    _speedTest.cancelTest();
    return super.close();
  }
}
