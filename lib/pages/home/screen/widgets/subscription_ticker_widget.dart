import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mikrotic_customer/pages/features/account/model/subscription_model.dart';

class SubscriptionTickerWidget extends StatefulWidget {
  final SubscriptionModel subscription;

  const SubscriptionTickerWidget({super.key, required this.subscription});

  @override
  State<SubscriptionTickerWidget> createState() =>
      _SubscriptionTickerWidgetState();
}

class _SubscriptionTickerWidgetState extends State<SubscriptionTickerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late _TickerConfig _cfg;
  late double _contentWidth;

  static const _kTextStyle = TextStyle(
    fontFamily: 'Cairo-Bold',
    fontSize: 13,
    height: 1.0,
  );

  @override
  void initState() {
    super.initState();
    _cfg = _TickerConfig.from(widget.subscription);
    _contentWidth = _measure(_cfg.message);
    // speed ≈ 55 px/s, min 8 s
    final secs = max(8, (_contentWidth / 55).round());
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: secs),
    )..repeat();
  }

  static double _measure(String text) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: _kTextStyle),
      textDirection: TextDirection.rtl,
      maxLines: 1,
    )..layout(maxWidth: double.infinity);
    // icon(15) + gaps(20) + padding(24)
    return painter.width + 59;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _cfg.darkBg : _cfg.lightBg;
    final fgColor = isDark ? _cfg.darkFg : _cfg.lightFg;
    final borderColor = fgColor.withOpacity(0.25);

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 0.8),
          bottom: BorderSide(color: borderColor, width: 0.8),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final W = constraints.maxWidth;
          return ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Scrolls from dx=W (off-screen right) to dx=-_contentWidth (off-screen left)
                final dx = W - _controller.value * (W + _contentWidth);
                return Stack(
                  children: [
                    Positioned(
                      left: dx,
                      top: 0,
                      bottom: 0,
                      width: _contentWidth,
                      child: child!,
                    ),
                  ],
                );
              },
              child: _TickerContent(cfg: _cfg, fgColor: fgColor),
            ),
          );
        },
      ),
    );
  }
}

class _TickerContent extends StatelessWidget {
  final _TickerConfig cfg;
  final Color fgColor;

  const _TickerContent({required this.cfg, required this.fgColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 12),
        Icon(cfg.icon, color: fgColor, size: 15),
        const SizedBox(width: 8),
        Text(
          cfg.message,
          style: TextStyle(
            fontFamily: 'Cairo-Bold',
            fontSize: 13,
            color: fgColor,
            height: 1.0,
          ),
          maxLines: 1,
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}

class _TickerConfig {
  final String message;
  final IconData icon;
  final Color lightBg;
  final Color darkBg;
  final Color lightFg;
  final Color darkFg;

  const _TickerConfig({
    required this.message,
    required this.icon,
    required this.lightBg,
    required this.darkBg,
    required this.lightFg,
    required this.darkFg,
  });

  factory _TickerConfig.from(SubscriptionModel sub) {
    final name = sub.subscriptionType.name;
    final remaining = sub.endDate.difference(DateTime.now());
    final isExpired = remaining.isNegative;
    final days = remaining.inDays;

    if (isExpired) {
      return _TickerConfig(
        message: 'انتهى اشتراكك «$name»! يرجى التجديد الآن',
        icon: Icons.error_outline_rounded,
        lightBg: const Color(0xFFFFEBEE),
        darkBg: const Color(0x33D32F2F),
        lightFg: const Color(0xFFD32F2F),
        darkFg: const Color(0xFFEF9A9A),
      );
    } else if (days <= 3) {
      return _TickerConfig(
        message:
            'تنبيه عاجل  ·  اشتراكك «$name» سينتهي خلال $days ${days == 1 ? 'يوم' : 'أيام'} — جدّد الآن',
        icon: Icons.warning_amber_rounded,
        lightBg: const Color(0xFFFFF3E0),
        darkBg: const Color(0x33E65100),
        lightFg: const Color(0xFFE65100),
        darkFg: const Color(0xFFFFCC80),
      );
    } else if (days <= 7) {
      return _TickerConfig(
        message:
            'تذكير  ·  اشتراكك «$name» سينتهي خلال $days أيام — تأكد من التجديد في الوقت المناسب',
        icon: Icons.campaign_rounded,
        lightBg: const Color(0xFFFFFDE7),
        darkBg: const Color(0x33F9A825),
        lightFg: const Color(0xFFF57F17),
        darkFg: const Color(0xFFFFE082),
      );
    } else {
      return _TickerConfig(
        message: 'اشتراكك «$name»  ·  ينتهي خلال $days أيام',
        icon: Icons.info_outline_rounded,
        lightBg: const Color(0xFFE3F2FD),
        darkBg: const Color(0x331565C0),
        lightFg: const Color(0xFF1565C0),
        darkFg: const Color(0xFF90CAF9),
      );
    }
  }
}
