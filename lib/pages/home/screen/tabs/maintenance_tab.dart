import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikrotic_customer/core/components/app_button.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/components/app_text_form_field.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/pages/home/cubit/maintenance_cubit.dart';
import 'package:mikrotic_customer/pages/home/cubit/maintenance_state.dart';

// ---------------------------------------------------------------------------
// Data helpers
// ---------------------------------------------------------------------------

class _IssueType {
  final String label;
  final IconData icon;
  const _IssueType(this.label, this.icon);
}

const _issueTypes = [
  _IssueType('انقطاع الإنترنت', Icons.wifi_off_rounded),
  _IssueType('بطء الشبكة', Icons.speed_rounded),
  _IssueType('مشكلة الراوتر', Icons.router_rounded),
  _IssueType('تذبذب الاتصال', Icons.signal_wifi_statusbar_connected_no_internet_4_rounded),
  _IssueType('أخرى', Icons.more_horiz_rounded),
];

class _Priority {
  final String label;
  final Color color;
  const _Priority(this.label, this.color);
}

const _priorities = [
  _Priority('منخفضة', Colors.green),
  _Priority('متوسطة', Colors.orange),
  _Priority('عالية', Colors.red),
];

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

  String? _selectedIssueType;
  String? _selectedPriority;
  bool _isDiagnosing = false;

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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _animationController.forward();
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

  void _submitForm() {
    if (_selectedIssueType == null) {
      _showSnackBar('الرجاء اختيار نوع المشكلة', isError: true);
      return;
    }
    if (_selectedPriority == null) {
      _showSnackBar('الرجاء اختيار درجة الأولوية', isError: true);
      return;
    }
    context.read<MaintenanceCubit>().submitRequest(
          issueType: _selectedIssueType!,
          priority: _selectedPriority!,
        );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.kRedColor : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<MaintenanceCubit>();

    return BlocListener<MaintenanceCubit, MaintenanceState>(
      listener: (context, state) {
        state.maybeWhen(
          success: () {
            setState(() {
              _selectedIssueType = null;
              _selectedPriority = null;
            });
            _showSnackBar('تم إرسال طلب الصيانة بنجاح');
            cubit.resetState();
          },
          error: (message) {
            _showSnackBar(message, isError: true);
            cubit.resetState();
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
                  _buildRequestForm(theme, cubit),
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
          'تشخيص الشبكة وإدارة طلبات الصيانة',
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
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
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
          // 2 × 2 grid
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
        color: item.color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: item.color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.15),
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
            color: _isDiagnosing ? AppColors.kGreyColor : theme.colorScheme.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: _isDiagnosing
                ? AppColors.kGreyColor.withOpacity(0.3)
                : theme.colorScheme.primary.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Request form card
  // --------------------------------------------------------------------------

  Widget _buildRequestForm(ThemeData theme, MaintenanceCubit cubit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
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
            _buildCardHeader(
              icon: Icons.build_rounded,
              title: 'طلب صيانة',
              theme: theme,
            ),
            const SizedBox(height: 20),

            // Issue type
            _buildSectionLabel('نوع المشكلة', theme),
            const SizedBox(height: 10),
            _buildIssueTypeChips(theme),
            const SizedBox(height: 20),

            // Priority
            _buildSectionLabel('درجة الأولوية', theme),
            const SizedBox(height: 10),
            _buildPriorityChips(theme),
            const SizedBox(height: 20),

            // Description
            AppTextFormField(
              label: 'وصف المشكلة',
              controller: cubit.descriptionController,
              icon: Icons.description_outlined,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              borderRadius: 12,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال وصف للمشكلة';
                }
                if (value.trim().length < 10) {
                  return 'الوصف قصير جداً، أدخل 10 أحرف على الأقل';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Submit button
            BlocBuilder<MaintenanceCubit, MaintenanceState>(
              builder: (context, state) {
                final isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );
                return SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: 'إرسال طلب الصيانة',
                    onPressed: _submitForm,
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

  Widget _buildSectionLabel(String label, ThemeData theme) {
    return AppText(
      label,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.kGreyColor,
    );
  }

  Widget _buildIssueTypeChips(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _issueTypes.map((type) {
        final isSelected = _selectedIssueType == type.label;
        return GestureDetector(
          onTap: () => setState(() => _selectedIssueType = type.label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  type.icon,
                  size: 16,
                  color: isSelected
                      ? AppColors.kWhiteColor
                      : theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                AppText(
                  type.label,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.kWhiteColor
                      : theme.colorScheme.onSurface,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriorityChips(ThemeData theme) {
    return Row(
      children: _priorities.asMap().entries.map((entry) {
        final priority = entry.value;
        final isLast = entry.key == _priorities.length - 1;
        final isSelected = _selectedPriority == priority.label;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPriority = priority.label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? priority.color
                      : priority.color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? priority.color
                        : priority.color.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _priorityIcon(priority.label),
                      size: 18,
                      color: isSelected ? AppColors.kWhiteColor : priority.color,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      priority.label,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color:
                          isSelected ? AppColors.kWhiteColor : priority.color,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _priorityIcon(String label) {
    switch (label) {
      case 'منخفضة':
        return Icons.arrow_downward_rounded;
      case 'متوسطة':
        return Icons.remove_rounded;
      case 'عالية':
        return Icons.arrow_upward_rounded;
      default:
        return Icons.circle_outlined;
    }
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
            color: theme.colorScheme.primary.withOpacity(0.1),
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
