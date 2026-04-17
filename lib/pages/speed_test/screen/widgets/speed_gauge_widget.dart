import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';

class SpeedGaugeWidget extends StatelessWidget {
  final double speed;
  final double maxSpeed;
  final double progress;
  final bool isActive;
  final String label;

  const SpeedGaugeWidget({
    super.key,
    required this.speed,
    this.maxSpeed = 100,
    this.progress = 0,
    this.isActive = false,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 220),
            painter: _GaugePainter(
              progress: (speed / maxSpeed).clamp(0.0, 1.0),
              isActive: isActive,
              isDark: isDark,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  speed.toStringAsFixed(1),
                  key: ValueKey(speed.toStringAsFixed(1)),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.kFontColor,
                  ),
                ),
              ),
              Text(
                'Mbps',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.kGreyColor,
                ),
              ),
              if (label.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: isActive
                        ? AppColors.kPrimaryColor
                        : AppColors.kGreyColor,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
              if (isActive && progress > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '${progress.toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.kGreyColor,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final bool isActive;
  final bool isDark;

  _GaugePainter({
    required this.progress,
    required this.isActive,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 15;

    final backgroundPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    if (progress > 0) {
      final progressPaint = Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: [
            AppColors.kPrimaryColor,
            AppColors.kSecondColor,
            AppColors.kPrimaryColor,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle * progress,
        false,
        progressPaint,
      );
    }

    // Draw tick marks
    final tickPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.3)
          : Colors.grey.withValues(alpha: 0.4)
      ..strokeWidth = 2;

    for (int i = 0; i <= 10; i++) {
      final angle = startAngle + (sweepAngle * i / 10);
      final innerRadius = radius - 20;
      final outerRadius = radius - 10;

      final start = Offset(
        center.dx + innerRadius * math.cos(angle),
        center.dy + innerRadius * math.sin(angle),
      );
      final end = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );

      canvas.drawLine(start, end, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isActive != isActive ||
        oldDelegate.isDark != isDark;
  }
}
