import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikrotic_customer/core/components/app_button.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/components/app_text_form_field.dart';
import 'package:mikrotic_customer/core/components/custom_appbar.dart' as appbar;
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/core/di/service_locator.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';
import 'package:mikrotic_customer/pages/connected_devices/bloc/connected_devices_bloc.dart';
import 'package:mikrotic_customer/pages/connected_devices/bloc/connected_devices_event.dart';
import 'package:mikrotic_customer/pages/connected_devices/bloc/connected_devices_state.dart';
import 'package:mikrotic_customer/pages/connected_devices/screen/widgets/device_list_tile.dart';

class ConnectedDevicesScreen extends StatelessWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ConnectedDevicesBloc>(),
      child: const _ConnectedDevicesView(),
    );
  }
}

class _ConnectedDevicesView extends StatefulWidget {
  const _ConnectedDevicesView();

  @override
  State<_ConnectedDevicesView> createState() => _ConnectedDevicesViewState();
}

class _ConnectedDevicesViewState extends State<_ConnectedDevicesView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: appbar.CustomAppBar(title: t.connected_devices),
      body: BlocBuilder<ConnectedDevicesBloc, ConnectedDevicesState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildHeader(context, state, t),
              if (state.status == ScanStatus.scanning) _buildProgress(state, t),
              _buildFilterChips(context, state, t),
              Expanded(
                child: _buildContent(context, state, t, isDark),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ConnectedDevicesState state,
    AppLocalizations t,
  ) {
    final bloc = context.read<ConnectedDevicesBloc>();
    final isScanning = state.status == ScanStatus.scanning;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: isScanning ? t.stop_scan : t.scan_network,
              onPressed: () {
                if (isScanning) {
                  bloc.add(StopNetworkScan());
                } else {
                  bloc.add(StartNetworkScan());
                }
              },
              icon: isScanning ? Icons.stop : Icons.wifi_find,
              color: isScanning ? AppColors.kRedColor : AppColors.kPrimaryColor,
              isLoading: false,
              height: 48,
              borderRadius: 12,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 12),
          AppTextFormField(
            label: t.search_devices,
            controller: _searchController,
            icon: Icons.search,
            onChanged: (value) {
              bloc.add(UpdateSearchQuery(query: value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(ConnectedDevicesState state, AppLocalizations t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: state.scanProgress / 100,
            backgroundColor: AppColors.kGreyColor.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation(AppColors.kPrimaryColor),
          ),
          const SizedBox(height: 8),
          AppText(
            t.scan_progress(state.scanProgress.toInt()),
            fontSize: 12,
            color: AppColors.kGreyColor,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildFilterChips(
    BuildContext context,
    ConnectedDevicesState state,
    AppLocalizations t,
  ) {
    final bloc = context.read<ConnectedDevicesBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip(
            label: t.filter_all,
            isSelected: state.filter == DeviceFilter.all,
            onTap: () => bloc.add(UpdateFilter(filter: DeviceFilter.all)),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: t.filter_active,
            isSelected: state.filter == DeviceFilter.active,
            onTap: () => bloc.add(UpdateFilter(filter: DeviceFilter.active)),
          ),
          const Spacer(),
          if (state.devices.isNotEmpty)
            AppText(
              t.devices_found(state.filteredDevices.length),
              fontSize: 12,
              color: AppColors.kGreyColor,
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kPrimaryColor
              : AppColors.kGreyColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: AppText(
          label,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : AppColors.kGreyColor,
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ConnectedDevicesState state,
    AppLocalizations t,
    bool isDark,
  ) {
    if (state.status == ScanStatus.idle && state.devices.isEmpty) {
      return _buildEmptyState(t, isDark);
    }

    if (state.status == ScanStatus.error) {
      return _buildErrorState(state, t, isDark);
    }

    final devices = state.filteredDevices;

    if (devices.isEmpty && state.searchQuery.isNotEmpty) {
      return _buildNoResultsState(t, isDark);
    }

    if (devices.isEmpty && state.status == ScanStatus.completed) {
      return _buildNoDevicesFoundState(t, isDark);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return DeviceListTile(device: devices[index]);
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations t, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_find,
            size: 80,
            color: AppColors.kGreyColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          AppText(
            t.scan_network,
            fontSize: 16,
            color: AppColors.kGreyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    ConnectedDevicesState state,
    AppLocalizations t,
    bool isDark,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: AppColors.kRedColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          AppText(
            t.network_error,
            fontSize: 16,
            color: AppColors.kRedColor,
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          if (state.errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: AppText(
                state.errorMessage,
                fontSize: 12,
                color: AppColors.kGreyColor,
                maxLines: 3,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(AppLocalizations t, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.kGreyColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          AppText(
            t.no_devices_found,
            fontSize: 16,
            color: AppColors.kGreyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNoDevicesFoundState(AppLocalizations t, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices_other,
            size: 80,
            color: AppColors.kGreyColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          AppText(
            t.no_devices_found,
            fontSize: 16,
            color: AppColors.kGreyColor,
          ),
        ],
      ),
    );
  }
}
