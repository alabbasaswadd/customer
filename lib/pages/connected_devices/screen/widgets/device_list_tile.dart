import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/components/app_card.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';
import 'package:mikrotic_customer/pages/connected_devices/model/device_model.dart';

class DeviceListTile extends StatelessWidget {
  final DeviceModel device;
  final VoidCallback? onTap;

  const DeviceListTile({
    super.key,
    required this.device,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      onTap: onTap ?? () => _showDeviceDetails(context, t),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: Row(
        children: [
          _buildIcon(isDark),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        device.hostname ?? device.ipAddress,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.kFontColor,
                        maxLines: 1,
                      ),
                    ),
                    if (device.isCurrentDevice) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AppText(
                          t.this_device,
                          fontSize: 10,
                          color: AppColors.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                AppText(
                  device.ipAddress,
                  fontSize: 14,
                  color: AppColors.kGreyColor,
                ),
                if (device.vendor != null) ...[
                  const SizedBox(height: 2),
                  AppText(
                    device.vendor!,
                    fontSize: 12,
                    color: AppColors.kGreyColor.withValues(alpha: 0.7),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.kGreyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(bool isDark) {
    IconData iconData;
    Color iconColor;

    if (device.isCurrentDevice) {
      iconData = Icons.phone_android;
      iconColor = AppColors.kPrimaryColor;
    } else {
      iconData = Icons.devices;
      iconColor = Colors.blue;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  void _showDeviceDetails(BuildContext context, AppLocalizations t) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildIcon(isDark),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          t.device_details,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.kFontColor,
                        ),
                        if (device.isCurrentDevice)
                          AppText(
                            t.this_device,
                            fontSize: 12,
                            color: AppColors.kPrimaryColor,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailRow(t.ip_address, device.ipAddress, isDark),
              if (device.hostname != null)
                _buildDetailRow(t.hostname, device.hostname!, isDark),
              if (device.macAddress != null)
                _buildDetailRow(t.mac_address, device.macAddress!, isDark),
              if (device.vendor != null)
                _buildDetailRow(t.vendor, device.vendor!, isDark),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: AppText(
              label,
              fontSize: 14,
              color: AppColors.kGreyColor,
            ),
          ),
          Expanded(
            child: AppText(
              value,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : AppColors.kFontColor,
            ),
          ),
        ],
      ),
    );
  }
}
