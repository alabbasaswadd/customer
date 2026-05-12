import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/cubit/connected_devices_cubit.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/cubit/connected_devices_state.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/device_model.dart';
import 'package:mikrotic_customer/pages/features/connected_devices/model/network_info_model.dart';
import 'package:permission_handler/permission_handler.dart';

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  State<ConnectedDevicesScreen> createState() => _ConnectedDevicesScreenState();
}

class _ConnectedDevicesScreenState extends State<ConnectedDevicesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();

    // Request location permission for WiFi name access on Android 12+
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startScan() {
    context.read<ConnectedDevicesCubit>().startScan();
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
          t.connected_devices,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<ConnectedDevicesCubit, ConnectedDevicesState>(
            builder: (context, state) {
              final isScanning = state.maybeWhen(
                scanning: (_, __, ___) => true,
                orElse: () => false,
              );
              return IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: theme.colorScheme.primary,
                ),
                onPressed: isScanning ? null : _startScan,
              );
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: BlocBuilder<ConnectedDevicesCubit, ConnectedDevicesState>(
          builder: (context, state) {
            return state.when(
              initial: () => _buildInitialState(t, theme),
              loadingNetworkInfo: () => _buildLoadingState(t, theme),
              scanning: (progress, networkInfo, devices) => _buildScanningState(
                t,
                theme,
                progress,
                networkInfo,
                devices,
              ),
              success: (data) => _buildSuccessState(
                t,
                theme,
                data.networkInfo,
                data.devices,
              ),
              error: (message) => _buildErrorState(t, theme, message),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInitialState(AppLocalizations t, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_find_rounded,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          AppText(
            t.scan_network,
            fontSize: 16,
            color: AppColors.kGreyColor,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _startScan,
            icon: const Icon(Icons.search_rounded),
            label: Text(t.scan_network),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(AppLocalizations t, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          const AppText(
            'Loading network info...',
            fontSize: 16,
            color: AppColors.kGreyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildScanningState(
    AppLocalizations t,
    ThemeData theme,
    int progress,
    NetworkInfoModel networkInfo,
    List<DeviceModel> devices,
  ) {
    final cubit = context.read<ConnectedDevicesCubit>();
    final filteredDevices = cubit.getFilteredDevices(devices);

    return Column(
      children: [
        _buildNetworkInfoCard(t, theme, networkInfo),
        _buildStatsHeader(t, theme, devices),
        _buildFilterTabs(t, theme),
        _buildScanningProgress(t, theme, progress),
        Expanded(
          child: _buildDevicesList(t, theme, filteredDevices),
        ),
      ],
    );
  }

  Widget _buildSuccessState(
    AppLocalizations t,
    ThemeData theme,
    NetworkInfoModel networkInfo,
    List<DeviceModel> devices,
  ) {
    final cubit = context.read<ConnectedDevicesCubit>();
    final filteredDevices = cubit.getFilteredDevices(devices);

    return Column(
      children: [
        _buildNetworkInfoCard(t, theme, networkInfo),
        _buildStatsHeader(t, theme, devices),
        _buildFilterTabs(t, theme),
        Expanded(
          child: _buildDevicesList(t, theme, filteredDevices),
        ),
      ],
    );
  }

  Widget _buildErrorState(AppLocalizations t, ThemeData theme, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            AppText(
              message,
              fontSize: 16,
              color: AppColors.kGreyColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _startScan,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(t.scan_network),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkInfoCard(
    AppLocalizations t,
    ThemeData theme,
    NetworkInfoModel networkInfo,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.wifi_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      networkInfo.cleanWifiName,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      networkInfo.isConnected ? 'Connected' : 'Not Connected',
                      fontSize: 12,
                      color: networkInfo.isConnected
                          ? Colors.green
                          : AppColors.kGreyColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _NetworkInfoItem(
                  label: t.ip_address,
                  value: networkInfo.ipAddress.isNotEmpty
                      ? networkInfo.ipAddress
                      : '-',
                  theme: theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _NetworkInfoItem(
                  label: 'Gateway',
                  value: networkInfo.gatewayIp.isNotEmpty
                      ? networkInfo.gatewayIp
                      : '-',
                  theme: theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(
    AppLocalizations t,
    ThemeData theme,
    List<DeviceModel> devices,
  ) {
    final onlineCount = devices.where((d) => d.isOnline).length;
    final totalCount = devices.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.devices_rounded,
              label: 'Total Devices',
              value: totalCount.toString(),
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: AppColors.kWhiteColor.withOpacity(0.3),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.wifi_rounded,
              label: 'Online Now',
              value: onlineCount.toString(),
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: AppColors.kWhiteColor.withOpacity(0.3),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.wifi_off_rounded,
              label: 'Offline',
              value: (totalCount - onlineCount).toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(AppLocalizations t, ThemeData theme) {
    final cubit = context.read<ConnectedDevicesCubit>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _FilterTab(
            label: t.filter_all,
            isSelected: cubit.currentFilter == DeviceFilter.all,
            onTap: () => cubit.setFilter(DeviceFilter.all),
            theme: theme,
          ),
          const SizedBox(width: 12),
          _FilterTab(
            label: t.filter_active,
            isSelected: cubit.currentFilter == DeviceFilter.active,
            onTap: () => cubit.setFilter(DeviceFilter.active),
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildScanningProgress(
    AppLocalizations t,
    ThemeData theme,
    int progress,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              AppText(
                t.scan_progress(progress),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesList(
    AppLocalizations t,
    ThemeData theme,
    List<DeviceModel> devices,
  ) {
    if (devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.devices_other_rounded,
              size: 64,
              color: AppColors.kGreyColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            AppText(
              t.no_devices_found,
              fontSize: 16,
              color: AppColors.kGreyColor,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _startScan,
              icon: const Icon(Icons.search_rounded),
              label: Text(t.scan_network),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: _DeviceCard(
            device: devices[index],
            theme: theme,
            t: t,
            onTap: () => _showDeviceDetails(devices[index]),
          ),
        );
      },
    );
  }

  void _showDeviceDetails(DeviceModel device) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.kGreyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: device.isOnline
                    ? Colors.green.withOpacity(0.1)
                    : AppColors.kGreyColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getDeviceIcon(device.deviceType),
                size: 40,
                color: device.isOnline ? Colors.green : AppColors.kGreyColor,
              ),
            ),
            const SizedBox(height: 16),
            AppText(
              device.displayName,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            if (device.isCurrentDevice)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppText(
                  t.this_device,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            const SizedBox(height: 24),
            _DetailRow(
              label: t.ip_address,
              value: device.ipAddress,
              icon: Icons.language_rounded,
              theme: theme,
            ),
            if (device.macAddress.isNotEmpty)
              _DetailRow(
                label: t.mac_address,
                value: device.macAddress,
                icon: Icons.router_rounded,
                theme: theme,
              ),
            if (device.vendor.isNotEmpty)
              _DetailRow(
                label: 'Vendor',
                value: device.vendor,
                icon: Icons.business_rounded,
                theme: theme,
              ),
            _DetailRow(
              label: 'Status',
              value: device.isOnline ? t.active : 'Offline',
              icon: Icons.circle,
              iconColor: device.isOnline ? Colors.green : AppColors.kGreyColor,
              theme: theme,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.phone:
        return Icons.phone_android_rounded;
      case DeviceType.laptop:
        return Icons.laptop_mac_rounded;
      case DeviceType.tablet:
        return Icons.tablet_mac_rounded;
      case DeviceType.tv:
        return Icons.tv_rounded;
      case DeviceType.router:
        return Icons.router_rounded;
      case DeviceType.printer:
        return Icons.print_rounded;
      case DeviceType.camera:
        return Icons.videocam_rounded;
      case DeviceType.speaker:
        return Icons.speaker_rounded;
      case DeviceType.other:
        return Icons.devices_other_rounded;
    }
  }
}

class _NetworkInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _NetworkInfoItem({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          fontSize: 11,
          color: AppColors.kGreyColor,
        ),
        const SizedBox(height: 2),
        AppText(
          value,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.kWhiteColor, size: 24),
        const SizedBox(height: 8),
        AppText(
          value,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.kWhiteColor,
        ),
        AppText(
          label,
          fontSize: 10,
          color: AppColors.kWhiteColor.withOpacity(0.8),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? theme.colorScheme.primary : theme.cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: AppText(
            label,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? AppColors.kWhiteColor
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final DeviceModel device;
  final ThemeData theme;
  final AppLocalizations t;
  final VoidCallback onTap;

  const _DeviceCard({
    required this.device,
    required this.theme,
    required this.t,
    required this.onTap,
  });

  IconData get _icon {
    switch (device.deviceType) {
      case DeviceType.phone:
        return Icons.phone_android_rounded;
      case DeviceType.laptop:
        return Icons.laptop_mac_rounded;
      case DeviceType.tablet:
        return Icons.tablet_mac_rounded;
      case DeviceType.tv:
        return Icons.tv_rounded;
      case DeviceType.router:
        return Icons.router_rounded;
      case DeviceType.printer:
        return Icons.print_rounded;
      case DeviceType.camera:
        return Icons.videocam_rounded;
      case DeviceType.speaker:
        return Icons.speaker_rounded;
      case DeviceType.other:
        return Icons.devices_other_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: device.isCurrentDevice
                    ? theme.colorScheme.primary.withOpacity(0.5)
                    : theme.colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: device.isOnline
                        ? Colors.green.withOpacity(0.1)
                        : AppColors.kGreyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _icon,
                    color: device.isOnline ? Colors.green : AppColors.kGreyColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: AppText(
                              device.displayName,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
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
                                color: theme.colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: AppText(
                                t.this_device,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        device.ipAddress,
                        fontSize: 13,
                        color: AppColors.kGreyColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: device.isOnline
                        ? Colors.green.withOpacity(0.1)
                        : AppColors.kGreyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: device.isOnline
                              ? Colors.green
                              : AppColors.kGreyColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      AppText(
                        device.isOnline ? t.active : 'Offline',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: device.isOnline
                            ? Colors.green
                            : AppColors.kGreyColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final ThemeData theme;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor ?? theme.colorScheme.primary,
          ),
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
            color: theme.colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}
