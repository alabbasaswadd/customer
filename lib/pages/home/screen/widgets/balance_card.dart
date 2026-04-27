import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final String currency;
  final VoidCallback? onRecharge;

  const BalanceCard({
    super.key,
    required this.balance,
    this.currency = 'ج.م',
    this.onRecharge,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.secondary,
            theme.colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.kWhiteColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.kWhiteColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppText(
                    t.current_balance,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.kWhiteColor.withOpacity(0.9),
                  ),
                ],
              ),
              if (onRecharge != null)
                _buildRechargeButton(context, t),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                balance.toStringAsFixed(2),
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: AppColors.kWhiteColor,
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppText(
                  currency,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.kWhiteColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRechargeButton(BuildContext context, AppLocalizations t) {
    return Material(
      color: AppColors.kWhiteColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onRecharge,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_circle_outline,
                color: AppColors.kWhiteColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              AppText(
                t.recharge,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.kWhiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
