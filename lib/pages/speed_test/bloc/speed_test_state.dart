import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mikrotic_customer/pages/speed_test/model/speed_test_model.dart';

part 'speed_test_state.freezed.dart';

enum SpeedTestPhase {
  idle,
  testingPing,
  testingDownload,
  testingUpload,
  completed,
  error,
}

@freezed
abstract class SpeedTestState with _$SpeedTestState {
  const factory SpeedTestState({
    @Default(SpeedTestPhase.idle) SpeedTestPhase phase,
    @Default(0.0) double currentDownloadSpeed,
    @Default(0.0) double currentUploadSpeed,
    @Default(0) int ping,
    @Default(0.0) double downloadProgress,
    @Default(0.0) double uploadProgress,
    @Default(0.0) double finalDownloadSpeed,
    @Default(0.0) double finalUploadSpeed,
    SpeedTestModel? result,
    @Default("") String errorMessage,
  }) = _SpeedTestState;
}
