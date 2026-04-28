import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test_pro/flutter_internet_speed_test_pro.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';

enum SpeedTestPhase { idle, testingDownload, testingUpload, completed }

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({super.key});

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen>
    with TickerProviderStateMixin {
  final FlutterInternetSpeedTest _speedTest = FlutterInternetSpeedTest();

  SpeedTestPhase _testPhase = SpeedTestPhase.idle;
  double _downloadSpeed = 0.0;
  double _uploadSpeed = 0.0;
  double _currentSpeed = 0.0;
  double _downloadProgress = 0.0;
  double _uploadProgress = 0.0;
  String _unitText = 'Mbps';
  bool _isTestRunning = false;

  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _startTest() async {
    setState(() {
      _testPhase = SpeedTestPhase.testingDownload;
      _downloadSpeed = 0.0;
      _uploadSpeed = 0.0;
      _currentSpeed = 0.0;
      _downloadProgress = 0.0;
      _uploadProgress = 0.0;
      _isTestRunning = true;
    });

    _pulseController.repeat(reverse: true);
    _rotationController.repeat();

    await _speedTest.startTesting(
      onStarted: () {
        setState(() {
          _testPhase = SpeedTestPhase.testingDownload;
        });
      },
      onProgress: (double percent, TestResult data) {
        setState(() {
          _currentSpeed = data.transferRate;
          _unitText = data.unit == SpeedUnit.mbps ? 'Mbps' : 'Kbps';

          if (data.type == TestType.download) {
            _downloadProgress = percent / 100;
            _testPhase = SpeedTestPhase.testingDownload;
          } else {
            _uploadProgress = percent / 100;
            _testPhase = SpeedTestPhase.testingUpload;
          }
        });
      },
      onDownloadComplete: (TestResult data) {
        setState(() {
          _downloadSpeed = data.transferRate;
          _unitText = data.unit == SpeedUnit.mbps ? 'Mbps' : 'Kbps';
          _downloadProgress = 1.0;
          _testPhase = SpeedTestPhase.testingUpload;
          _currentSpeed = 0.0;
        });
      },
      onUploadComplete: (TestResult data) {
        setState(() {
          _uploadSpeed = data.transferRate;
          _unitText = data.unit == SpeedUnit.mbps ? 'Mbps' : 'Kbps';
          _uploadProgress = 1.0;
        });
      },
      onCompleted: (TestResult download, TestResult upload) {
        setState(() {
          _downloadSpeed = download.transferRate;
          _uploadSpeed = upload.transferRate;
          _testPhase = SpeedTestPhase.completed;
          _isTestRunning = false;
          _currentSpeed = 0.0;
        });
        _pulseController.stop();
        _rotationController.stop();
      },
      onError: (String errorMessage, String speedTestError) {
        _handleError(errorMessage);
      },
      onCancel: () {
        setState(() {
          _testPhase = SpeedTestPhase.idle;
          _isTestRunning = false;
        });
        _pulseController.stop();
        _rotationController.stop();
      },
    );
  }

  void _handleError(String errorMessage) {
    setState(() {
      _testPhase = SpeedTestPhase.idle;
      _isTestRunning = false;
    });
    _pulseController.stop();
    _rotationController.stop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  void _resetTest() {
    setState(() {
      _testPhase = SpeedTestPhase.idle;
      _downloadSpeed = 0.0;
      _uploadSpeed = 0.0;
      _currentSpeed = 0.0;
      _downloadProgress = 0.0;
      _uploadProgress = 0.0;
      _isTestRunning = false;
    });
    _pulseController.reset();
    _rotationController.reset();
  }

  double get _totalProgress {
    if (_testPhase == SpeedTestPhase.testingDownload) {
      return _downloadProgress * 0.5;
    } else if (_testPhase == SpeedTestPhase.testingUpload) {
      return 0.5 + (_uploadProgress * 0.5);
    } else if (_testPhase == SpeedTestPhase.completed) {
      return 1.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: AppText(
          t.speed_test,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Speed Results Cards at Top
              _buildSpeedResultsRow(t, theme),
              const SizedBox(height: 24),

              // Main Speed Gauge
              _buildSpeedGauge(t, theme),
              const SizedBox(height: 24),

              // Status Card
              _buildStatusCard(t, theme),
              const SizedBox(height: 24),

              // Action Button
              _buildActionButton(t, theme),
              const SizedBox(height: 24),

              // Additional Info Cards
              _buildInfoCards(t, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedResultsRow(AppLocalizations t, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _SpeedResultCard(
            icon: Icons.download_rounded,
            label: t.download_speed,
            value: _downloadSpeed,
            unit: _unitText,
            color: Colors.blue,
            isActive: _testPhase == SpeedTestPhase.testingDownload,
            progress: _downloadProgress,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SpeedResultCard(
            icon: Icons.upload_rounded,
            label: t.upload_speed,
            value: _uploadSpeed,
            unit: _unitText,
            color: Colors.green,
            isActive: _testPhase == SpeedTestPhase.testingUpload,
            progress: _uploadProgress,
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedGauge(AppLocalizations t, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            width: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring with progress
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _isTestRunning
                          ? _rotationController.value * 2 * pi
                          : 0,
                      child: child,
                    );
                  },
                  child: CustomPaint(
                    size: const Size(220, 220),
                    painter: _SpeedGaugePainter(
                      progress: _totalProgress,
                      isActive: _isTestRunning,
                      primaryColor: theme.colorScheme.primary,
                      downloadProgress: _downloadProgress,
                      uploadProgress: _uploadProgress,
                      phase: _testPhase,
                    ),
                  ),
                ),
                // Inner content
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isTestRunning ? _pulseAnimation.value : 1.0,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _getGaugeColors(theme),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getGaugeColors(theme)[0].withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          _currentSpeed.toStringAsFixed(2),
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kWhiteColor,
                        ),
                        AppText(
                          _unitText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kWhiteColor.withOpacity(0.8),
                        ),
                        if (_isTestRunning)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: AppText(
                              '${(_totalProgress * 100).toInt()}%',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.kWhiteColor.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGaugeColors(ThemeData theme) {
    switch (_testPhase) {
      case SpeedTestPhase.testingDownload:
        return [Colors.blue.shade600, Colors.blue.shade400];
      case SpeedTestPhase.testingUpload:
        return [Colors.green.shade600, Colors.green.shade400];
      case SpeedTestPhase.completed:
        return [Colors.green.shade600, Colors.teal.shade400];
      case SpeedTestPhase.idle:
        return [theme.colorScheme.primary, theme.colorScheme.secondary];
    }
  }

  Widget _buildStatusCard(AppLocalizations t, ThemeData theme) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (_testPhase) {
      case SpeedTestPhase.idle:
        statusText = t.idle;
        statusColor = AppColors.kGreyColor;
        statusIcon = Icons.play_circle_outline_rounded;
        break;
      case SpeedTestPhase.testingDownload:
        statusText = t.testing_download;
        statusColor = Colors.blue;
        statusIcon = Icons.download_rounded;
        break;
      case SpeedTestPhase.testingUpload:
        statusText = t.testing_upload;
        statusColor = Colors.green;
        statusIcon = Icons.upload_rounded;
        break;
      case SpeedTestPhase.completed:
        statusText = t.test_completed;
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isTestRunning)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            )
          else
            Icon(statusIcon, color: statusColor, size: 24),
          const SizedBox(width: 12),
          AppText(
            statusText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: statusColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(AppLocalizations t, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isTestRunning
            ? null
            : _testPhase == SpeedTestPhase.completed
                ? _resetTest
                : _startTest,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          disabledBackgroundColor: AppColors.kGreyColor.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: theme.colorScheme.primary.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isTestRunning
                  ? Icons.hourglass_empty_rounded
                  : _testPhase == SpeedTestPhase.completed
                      ? Icons.refresh_rounded
                      : Icons.play_arrow_rounded,
              color: AppColors.kWhiteColor,
            ),
            const SizedBox(width: 8),
            AppText(
              _isTestRunning
                  ? '${(_totalProgress * 100).toInt()}%'
                  : _testPhase == SpeedTestPhase.completed
                      ? t.test_again
                      : t.start_test,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.kWhiteColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards(AppLocalizations t, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.wifi_rounded,
            label: 'Connection',
            value: 'Wi-Fi',
            theme: theme,
          ),
          Divider(color: theme.colorScheme.outline.withOpacity(0.1)),
          _InfoRow(
            icon: Icons.cloud_rounded,
            label: 'Test Server',
            value: 'Auto Selected',
            theme: theme,
          ),
          if (_testPhase == SpeedTestPhase.completed) ...[
            Divider(color: theme.colorScheme.outline.withOpacity(0.1)),
            _InfoRow(
              icon: Icons.download_rounded,
              label: t.download_speed,
              value: '${_downloadSpeed.toStringAsFixed(2)} $_unitText',
              valueColor: Colors.blue,
              theme: theme,
            ),
            Divider(color: theme.colorScheme.outline.withOpacity(0.1)),
            _InfoRow(
              icon: Icons.upload_rounded,
              label: t.upload_speed,
              value: '${_uploadSpeed.toStringAsFixed(2)} $_unitText',
              valueColor: Colors.green,
              theme: theme,
            ),
          ],
        ],
      ),
    );
  }
}

class _SpeedResultCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final String unit;
  final Color color;
  final bool isActive;
  final double progress;

  const _SpeedResultCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.isActive,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? color : color.withOpacity(0.2),
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive ? color.withOpacity(0.2) : Colors.transparent,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              if (isActive)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 2,
                    backgroundColor: color.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          AppText(
            value > 0 ? value.toStringAsFixed(2) : '--',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
          AppText(
            unit,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.kGreyColor,
          ),
          const SizedBox(height: 4),
          AppText(
            label,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.kGreyColor,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final ThemeData theme;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          AppText(
            label,
            fontSize: 14,
            color: AppColors.kGreyColor,
          ),
          const Spacer(),
          AppText(
            value,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? theme.colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}

class _SpeedGaugePainter extends CustomPainter {
  final double progress;
  final bool isActive;
  final Color primaryColor;
  final double downloadProgress;
  final double uploadProgress;
  final SpeedTestPhase phase;

  _SpeedGaugePainter({
    required this.progress,
    required this.isActive,
    required this.primaryColor,
    required this.downloadProgress,
    required this.uploadProgress,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background arc
    final backgroundPaint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Download progress (blue) - first half
    if (downloadProgress > 0) {
      final downloadPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        downloadProgress * pi,
        false,
        downloadPaint,
      );
    }

    // Upload progress (green) - second half
    if (uploadProgress > 0) {
      final uploadPaint = Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        pi / 2,
        uploadProgress * pi,
        false,
        uploadPaint,
      );
    }

    // Animated dots when active
    if (isActive) {
      final dotColor = phase == SpeedTestPhase.testingDownload
          ? Colors.blue
          : Colors.green;
      for (int i = 0; i < 4; i++) {
        final angle = (i / 4) * 2 * pi - pi / 2 + (progress * 2 * pi);
        final dotCenter = Offset(
          center.dx + radius * cos(angle),
          center.dy + radius * sin(angle),
        );
        final dotPaint = Paint()
          ..color = dotColor.withOpacity(0.3 + (i * 0.15))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(dotCenter, 4, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SpeedGaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isActive != isActive ||
        oldDelegate.downloadProgress != downloadProgress ||
        oldDelegate.uploadProgress != uploadProgress ||
        oldDelegate.phase != phase;
  }
}
