import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mikrotic_customer/core/components/app_alert_dialog.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/components/shimmer_widgets.dart';
import 'package:mikrotic_customer/core/constants/cached/user_session.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const SafeArea(child: SettingsShimmer());

    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              UserSession.user?.firstName ?? "",
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            AppText(
              t.settings,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 8),
            AppText(
              t.settings_subtitle,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.kGreyColor,
            ),
            const SizedBox(height: 32),
            _buildSettingsSection(
              context,
              title: t.account_settings,
              items: [
                _SettingsItem(
                  icon: Icons.person_outline_rounded,
                  title: t.profile,
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.lock_outline_rounded,
                  title: t.change_password,
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.notifications_outlined,
                  title: t.notifications,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              context,
              title: t.app_settings,
              items: [
                _SettingsItem(
                  icon: Icons.language_rounded,
                  title: t.language,
                  trailing: AppText(
                    t.arabic,
                    fontSize: 14,
                    color: AppColors.kGreyColor,
                  ),
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.dark_mode_outlined,
                  title: t.dark_mode,
                  trailing: Switch(
                    value: theme.brightness == Brightness.dark,
                    onChanged: (value) {},
                  ),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              context,
              title: t.other,
              items: [
                _SettingsItem(
                  icon: Icons.info_outline_rounded,
                  title: t.about,
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.help_outline_rounded,
                  title: t.help,
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.logout_rounded,
                  title: t.logout,
                  iconColor: AppColors.kRedColor,
                  titleColor: AppColors.kRedColor,
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => AppAlertDialog(
                      title: t.logout,
                      content: t.logout_confirmation,
                      onOk: () async {
                        Navigator.pop(context);
                        await UserSession.logout();
                        if (context.mounted) context.go('/signin');
                      },
                      onNo: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<_SettingsItem> items,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppText(
            title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.kGreyColor,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return Column(
                children: [
                  _buildSettingsItem(context, item),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: theme.colorScheme.outline.withOpacity(0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(BuildContext context, _SettingsItem item) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (item.iconColor ?? theme.colorScheme.primary)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  size: 22,
                  color: item.iconColor ?? theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: AppText(
                  item.title,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: item.titleColor ?? theme.colorScheme.onSurface,
                ),
              ),
              if (item.trailing != null) item.trailing!,
              if (item.trailing == null)
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.kGreyColor.withOpacity(0.5),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Color? iconColor;
  final Color? titleColor;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.iconColor,
    this.titleColor,
    required this.onTap,
  });
}
