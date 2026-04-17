abstract class SpeedTestEvent {}

class StartSpeedTest extends SpeedTestEvent {}

class StopSpeedTest extends SpeedTestEvent {}

class UpdateDownloadSpeed extends SpeedTestEvent {
  final double speed;
  final double progress;

  UpdateDownloadSpeed({required this.speed, required this.progress});
}

class UpdateUploadSpeed extends SpeedTestEvent {
  final double speed;
  final double progress;

  UpdateUploadSpeed({required this.speed, required this.progress});
}

class UpdatePing extends SpeedTestEvent {
  final int ping;

  UpdatePing({required this.ping});
}

class DownloadTestComplete extends SpeedTestEvent {
  final double speed;

  DownloadTestComplete({required this.speed});
}

class UploadTestComplete extends SpeedTestEvent {
  final double speed;

  UploadTestComplete({required this.speed});
}

class SpeedTestCompleted extends SpeedTestEvent {}

class SpeedTestError extends SpeedTestEvent {
  final String message;

  SpeedTestError({required this.message});
}

class ResetSpeedTest extends SpeedTestEvent {}
