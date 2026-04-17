import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikrotic_customer/core/components/app_button.dart';
import 'package:mikrotic_customer/core/components/custom_appbar.dart' as appbar;
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/core/di/service_locator.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';
import 'package:mikrotic_customer/pages/speed_test/bloc/speed_test_bloc.dart';
import 'package:mikrotic_customer/pages/speed_test/bloc/speed_test_event.dart';
import 'package:mikrotic_customer/pages/speed_test/bloc/speed_test_state.dart';
import 'package:mikrotic_customer/pages/speed_test/screen/widgets/speed_gauge_widget.dart';
import 'package:mikrotic_customer/pages/speed_test/screen/widgets/speed_result_card.dart';

class SpeedTestScreen extends StatelessWidget {
  const SpeedTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SpeedTestBloc>(),
      child: const _SpeedTestView(),
    );
  }
}

class _SpeedTestView extends StatelessWidget {
  const _SpeedTestView();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: appbar.CustomAppBar(title: t.speed_test),
      body: BlocBuilder<SpeedTestBloc, SpeedTestState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildGauge(context, state, t),
                const SizedBox(height: 40),
                _buildResultCards(context, state, t),
                const SizedBox(height: 40),
                _buildActionButton(context, state, t),
                if (state.phase == SpeedTestPhase.error) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage,
                    style: TextStyle(
                      color: AppColors.kRedColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGauge(
    BuildContext context,
    SpeedTestState state,
    AppLocalizations t,
  ) {
    String label;
    double speed;
    double progress;
    bool isActive;

    switch (state.phase) {
      case SpeedTestPhase.idle:
        label = t.idle;
        speed = 0;
        progress = 0;
        isActive = false;
        break;
      case SpeedTestPhase.testingPing:
        label = t.ping;
        speed = 0;
        progress = 0;
        isActive = true;
        break;
      case SpeedTestPhase.testingDownload:
        label = t.testing_download;
        speed = state.currentDownloadSpeed;
        progress = state.downloadProgress;
        isActive = true;
        break;
      case SpeedTestPhase.testingUpload:
        label = t.testing_upload;
        speed = state.currentUploadSpeed;
        progress = state.uploadProgress;
        isActive = true;
        break;
      case SpeedTestPhase.completed:
        label = t.test_completed;
        speed = state.finalDownloadSpeed;
        progress = 100;
        isActive = false;
        break;
      case SpeedTestPhase.error:
        label = '';
        speed = 0;
        progress = 0;
        isActive = false;
        break;
    }

    return Center(
      child: SpeedGaugeWidget(
        speed: speed,
        progress: progress,
        isActive: isActive,
        label: label,
      ),
    );
  }

  Widget _buildResultCards(
    BuildContext context,
    SpeedTestState state,
    AppLocalizations t,
  ) {
    final isCompleted = state.phase == SpeedTestPhase.completed;
    final showDownload = state.phase == SpeedTestPhase.testingDownload ||
        state.phase == SpeedTestPhase.testingUpload ||
        isCompleted;
    final showUpload = state.phase == SpeedTestPhase.testingUpload || isCompleted;

    return Column(
      children: [
        SpeedResultCard(
          title: t.ping,
          value: state.ping.toString(),
          unit: t.ms,
          icon: Icons.speed,
          iconColor: Colors.orange,
          isCompleted: state.ping > 0,
        ),
        const SizedBox(height: 12),
        SpeedResultCard(
          title: t.download_speed,
          value: showDownload
              ? (isCompleted
                  ? state.finalDownloadSpeed.toStringAsFixed(1)
                  : state.currentDownloadSpeed.toStringAsFixed(1))
              : '-',
          unit: t.mbps,
          icon: Icons.download,
          iconColor: Colors.blue,
          isCompleted: isCompleted,
        ),
        const SizedBox(height: 12),
        SpeedResultCard(
          title: t.upload_speed,
          value: showUpload
              ? (isCompleted
                  ? state.finalUploadSpeed.toStringAsFixed(1)
                  : state.currentUploadSpeed.toStringAsFixed(1))
              : '-',
          unit: t.mbps,
          icon: Icons.upload,
          iconColor: Colors.green,
          isCompleted: isCompleted,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    SpeedTestState state,
    AppLocalizations t,
  ) {
    final bloc = context.read<SpeedTestBloc>();
    final isRunning = state.phase == SpeedTestPhase.testingDownload ||
        state.phase == SpeedTestPhase.testingUpload ||
        state.phase == SpeedTestPhase.testingPing;

    if (isRunning) {
      return SizedBox(
        width: double.infinity,
        child: AppButton(
          text: t.stop_test,
          onPressed: () => bloc.add(StopSpeedTest()),
          color: AppColors.kRedColor,
          icon: Icons.stop,
          height: 54,
          borderRadius: 27,
          padding: EdgeInsets.zero,
        ),
      );
    }

    final buttonText = state.phase == SpeedTestPhase.completed ||
            state.phase == SpeedTestPhase.error
        ? t.test_again
        : t.start_test;

    return SizedBox(
      width: double.infinity,
      child: AppButton(
        text: buttonText,
        onPressed: () => bloc.add(StartSpeedTest()),
        icon: Icons.play_arrow,
        height: 54,
        borderRadius: 27,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
