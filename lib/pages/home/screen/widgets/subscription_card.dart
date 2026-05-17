import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';
import 'package:mikrotic_customer/pages/features/account/model/subscription_model.dart';

class SubscriptionCard extends StatefulWidget {
  final SubscriptionModel? subscription;
  final VoidCallback? onRenew;

  const SubscriptionCard({super.key, required this.subscription, this.onRenew});

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = _calcRemaining();
    _startTimer();
  }

  Duration _calcRemaining() {
    final end = widget.subscription?.endDate;
    if (end == null) return Duration.zero;
    final diff = end.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _remainingTime = _calcRemaining();
          if (_remainingTime == Duration.zero) _timer.cancel();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SubscriptionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subscription?.endDate != widget.subscription?.endDate) {
      _remainingTime = _calcRemaining();
    }
  }

  bool get _isExpired => widget.subscription == null || _remainingTime == Duration.zero;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isExpired
              ? AppColors.kRedColor.withOpacity(0.3)
              : theme.colorScheme.primary.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(t, theme),
          const SizedBox(height: 16),
          _buildSubscriptionName(theme),
          const SizedBox(height: 20),
          _buildCountdown(t, theme),
          if (_isExpired && widget.onRenew != null) ...[
            const SizedBox(height: 16),
            _buildRenewButton(t, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations t, ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _isExpired
                ? AppColors.kRedColor.withOpacity(0.1)
                : theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _isExpired ? Icons.warning_amber_rounded : Icons.wifi_rounded,
            color: _isExpired ? AppColors.kRedColor : theme.colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                t.subscription,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.kGreyColor,
              ),
              const SizedBox(height: 2),
              AppText(
                _isExpired ? t.subscription_expired : t.subscription_active,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _isExpired ? AppColors.kRedColor : Colors.green,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.monetization_on_outlined,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              AppText(
                widget.subscription != null
                    ? '${widget.subscription!.subscriptionType.price.toStringAsFixed(0)} \$'
                    : '—',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionName(ThemeData theme) {
    return AppText(
      widget.subscription?.subscriptionType.name ?? '—',
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface,
    );
  }

  Widget _buildCountdown(AppLocalizations t, ThemeData theme) {
    if (_isExpired) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.kRedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.kRedColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            AppText(
              t.subscription_expired_message,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.kRedColor,
            ),
          ],
        ),
      );
    }

    final days = _remainingTime.inDays;
    final hours = _remainingTime.inHours % 24;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          t.time_remaining,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.kGreyColor,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTimeUnit(days.toString().padLeft(2, '0'), t.days, theme),
            _buildTimeSeparator(theme),
            _buildTimeUnit(hours.toString().padLeft(2, '0'), t.hours, theme),
            _buildTimeSeparator(theme),
            _buildTimeUnit(minutes.toString().padLeft(2, '0'), t.minutes, theme),
            _buildTimeSeparator(theme),
            _buildTimeUnit(seconds.toString().padLeft(2, '0'), t.seconds, theme),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeUnit(String value, String label, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: AppText(
            value,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        AppText(
          label,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.kGreyColor,
        ),
      ],
    );
  }

  Widget _buildTimeSeparator(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: AppText(
        ':',
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.primary.withOpacity(0.5),
      ),
    );
  }

  Widget _buildRenewButton(AppLocalizations t, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onRenew,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: AppColors.kWhiteColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.autorenew_rounded, size: 20),
            const SizedBox(width: 8),
            AppText(
              t.renew_subscription,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.kWhiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
