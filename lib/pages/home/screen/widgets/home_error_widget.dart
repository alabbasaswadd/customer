import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/components/app_button.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';

class HomeErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const HomeErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.kRedColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.kRedColor,
              ),
            ),
            const SizedBox(height: 24),
            AppText(
              t.error_occurred,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            AppText(
              errorMessage,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.kGreyColor,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: AppButton(
                text: t.retry,
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
                height: 48,
                borderRadius: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
