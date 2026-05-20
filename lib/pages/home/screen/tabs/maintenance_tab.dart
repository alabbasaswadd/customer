import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mikrotic_customer/core/components/app_button.dart';
import 'package:mikrotic_customer/core/components/app_snackbar.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/components/app_text_form_field.dart';
import 'package:mikrotic_customer/core/components/shimmer_widgets.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/pages/features/complaint/cubit/complaint_cubit.dart';
import 'package:mikrotic_customer/pages/features/complaint/cubit/complaint_state.dart';

// ---------------------------------------------------------------------------
// Diagnostics data
// ---------------------------------------------------------------------------

class _DiagnosticItem {
  final String label;
  final String value;
  final String busyValue;
  final IconData icon;
  final Color color;
  const _DiagnosticItem({
    required this.label,
    required this.value,
    required this.busyValue,
    required this.icon,
    required this.color,
  });
}

const _diagnostics = [
  _DiagnosticItem(
    label: 'الاتصال بالإنترنت',
    value: 'متصل',
    busyValue: 'جاري الفحص...',
    icon: Icons.wifi_rounded,
    color: Colors.green,
  ),
  _DiagnosticItem(
    label: 'حالة الراوتر',
    value: 'يعمل بكفاءة',
    busyValue: 'جاري الفحص...',
    icon: Icons.router_rounded,
    color: Colors.green,
  ),
  _DiagnosticItem(
    label: 'خادم DNS',
    value: '8.8.8.8',
    busyValue: 'جاري الفحص...',
    icon: Icons.dns_rounded,
    color: Colors.blue,
  ),
  _DiagnosticItem(
    label: 'زمن الاستجابة',
    value: '42 ms',
    busyValue: 'جاري الفحص...',
    icon: Icons.timer_outlined,
    color: Colors.orange,
  ),
];

// ---------------------------------------------------------------------------
// Tab widget
// ---------------------------------------------------------------------------

class MaintenanceTab extends StatefulWidget {
  const MaintenanceTab({super.key});

  @override
  State<MaintenanceTab> createState() => _MaintenanceTabState();
}

class _MaintenanceTabState extends State<MaintenanceTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isDiagnosing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _runDiagnostic() async {
    setState(() => _isDiagnosing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isDiagnosing = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const SafeArea(child: MaintenanceShimmer());
    }

    return BlocListener<ComplaintCubit, ComplaintState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (_) {
            AppSnackbar.showSuccess(context, 'تم إرسال الشكوى بنجاح');
            context.read<ComplaintCubit>().resetState();
          },
          error: (message) {
            AppSnackbar.showError(context, message);
            context.read<ComplaintCubit>().resetState();
          },
          orElse: () {},
        );
      },
      child: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(theme),
                  const SizedBox(height: 24),
                  _buildDiagnosticsCard(theme),
                  const SizedBox(height: 16),
                  _buildComplaintForm(theme),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Header
  // --------------------------------------------------------------------------

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'الصيانة والتشخيص',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
        const SizedBox(height: 8),
        const AppText(
          'تشخيص الشبكة وتقديم الشكاوى',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.kGreyColor,
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // Diagnostics card
  // --------------------------------------------------------------------------

  Widget _buildDiagnosticsCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            icon: Icons.monitor_heart_rounded,
            title: 'تشخيص الشبكة',
            theme: theme,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDiagnosticCell(_diagnostics[0], theme)),
              const SizedBox(width: 12),
              Expanded(child: _buildDiagnosticCell(_diagnostics[1], theme)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDiagnosticCell(_diagnostics[2], theme)),
              const SizedBox(width: 12),
              Expanded(child: _buildDiagnosticCell(_diagnostics[3], theme)),
            ],
          ),
          const SizedBox(height: 16),
          _buildRunDiagnosticButton(theme),
        ],
      ),
    );
  }

  Widget _buildDiagnosticCell(_DiagnosticItem item, ThemeData theme) {
    final displayValue = _isDiagnosing ? item.busyValue : item.value;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: item.color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, color: item.color, size: 16),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isDiagnosing ? Colors.grey : item.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: AppText(
              displayValue,
              key: ValueKey(displayValue),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _isDiagnosing ? AppColors.kGreyColor : item.color,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 2),
          AppText(
            item.label,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.kGreyColor,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildRunDiagnosticButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _isDiagnosing ? null : _runDiagnostic,
        icon: _isDiagnosing
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                ),
              )
            : const Icon(Icons.play_arrow_rounded),
        label: Text(
          _isDiagnosing ? 'جاري التشخيص...' : 'إجراء تشخيص',
          style: TextStyle(
            fontFamily: 'Cairo-Bold',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _isDiagnosing
                ? AppColors.kGreyColor
                : theme.colorScheme.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: _isDiagnosing
                ? AppColors.kGreyColor.withValues(alpha: 0.3)
                : theme.colorScheme.primary.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Complaint form card
  // --------------------------------------------------------------------------

  Widget _buildComplaintForm(ThemeData theme) {
    final cubit = context.read<ComplaintCubit>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: cubit.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCardHeader(
                  icon: Icons.edit_note_rounded,
                  title: 'تقديم شكوى',
                  theme: theme,
                ),
                IconButton(
                  onPressed: () {
                    context.push('/complaints/history');
                  },
                  icon: const Icon(Icons.history),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppTextFormField(
              label: 'عنوان الشكوى',
              controller: context.read<ComplaintCubit>().titleController,
              icon: Icons.title_rounded,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال عنوان الشكوى';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              label: 'وصف الشكوى',
              controller: context.read<ComplaintCubit>().descriptionController,
              icon: Icons.description_outlined,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              borderRadius: 12,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال وصف الشكوى';
                }
                if (value.trim().length < 10) {
                  return 'الوصف قصير جداً، أدخل 10 أحرف على الأقل';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            BlocBuilder<ComplaintCubit, ComplaintState>(
              builder: (context, state) {
                final isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );
                return SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: 'إرسال الشكوى',
                    onPressed: () =>
                        context.read<ComplaintCubit>().addComplaint(),
                    isLoading: isLoading,
                    icon: Icons.send_rounded,
                    height: 54,
                    borderRadius: 12,
                    padding: EdgeInsets.zero,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Shared helpers
  // --------------------------------------------------------------------------

  Widget _buildCardHeader({
    required IconData icon,
    required String title,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 12),
        AppText(
          title,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
      ],
    );
  }
}
