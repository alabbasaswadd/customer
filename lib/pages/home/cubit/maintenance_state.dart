import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_state.freezed.dart';

@freezed
class MaintenanceState with _$MaintenanceState {
  const factory MaintenanceState.initial() = _MaintenanceInitial;
  const factory MaintenanceState.loading() = _MaintenanceLoading;
  const factory MaintenanceState.success() = _MaintenanceSuccess;
  const factory MaintenanceState.error(String errorMessage) = _MaintenanceError;
}
