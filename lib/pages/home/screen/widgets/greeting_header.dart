import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';

class GreetingHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onNotificationTap;
  final int notificationCount;

  const GreetingHeader({
    super.key,
    required this.userName,
    required this.onNotificationTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    '${t.hello_user}, $userName',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kWhiteColor,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    t.home_subtitle,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.kWhiteColor.withOpacity(0.8),
                  ),
                ],
              ),
            ),
            _buildNotificationButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.kWhiteColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onNotificationTap,
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.kWhiteColor,
              size: 28,
            ),
          ),
        ),
        if (notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.kRedColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                notificationCount > 9 ? '9+' : '$notificationCount',
                style: const TextStyle(
                  color: AppColors.kWhiteColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
