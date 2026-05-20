import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mikrotic_customer/core/components/app_button.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/components/app_text_form_field.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/pages/features/complaint/cubit/complaint_cubit.dart';
import 'package:mikrotic_customer/pages/features/complaint/cubit/complaint_state.dart';
import 'package:mikrotic_customer/pages/features/complaint/model/complaint_list_response_model.dart';
import 'package:mikrotic_customer/pages/features/complaint/model/complaint_model.dart';
import 'package:shimmer/shimmer.dart';

class ComplaintHistory extends StatefulWidget {
  const ComplaintHistory({super.key});

  @override
  State<ComplaintHistory> createState() => _ComplaintHistoryState();
}

class _ComplaintHistoryState extends State<ComplaintHistory> {
  @override
  void initState() {
    super.initState();
    context.read<ComplaintCubit>().loadComplaints();
  }

  Future<void> _onRefresh() async {
    context.read<ComplaintCubit>().loadComplaints();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<ComplaintCubit, ComplaintState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(theme, state),
              SliverToBoxAdapter(child: _buildBody(state, theme)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme, ComplaintState state) {
    int? count;
    state.maybeWhen(
      success: (data) {
        if (data is ComplaintListResponseModel) {
          count = data.data?.length;
        }
      },
      orElse: () {},
    );

    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.kPrimaryColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(
          start: 56,
          bottom: 16,
          end: 16,
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const AppText(
              'سجل الشكاوى',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            if (count != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppText(
                  '$count',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.kPrimaryColor,
                AppColors.kSecondColor,
                Color(0xFF42A5F5),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                right: 30,
                bottom: 30,
                child: Icon(
                  Icons.history_rounded,
                  size: 90,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ComplaintState state, ThemeData theme) {
    return state.when(
      initial: () => const SizedBox(height: 400),
      loading: () => _buildShimmer(theme),
      success: (data) {
        if (data is ComplaintListResponseModel) {
          final complaints = data.data ?? [];
          if (complaints.isEmpty) return _buildEmptyState(theme);
          return _buildComplaintList(complaints, theme);
        }
        return _buildShimmer(theme);
      },
      error: (message) => _buildErrorState(message, theme),
    );
  }

  Widget _buildComplaintList(List<ComplaintModel> complaints, ThemeData theme) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: theme.colorScheme.primary,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          final complaint = complaints[index];
          return _ComplaintCard(
            key: ValueKey(complaint.id ?? index),
            complaint: complaint,
            index: index,
            theme: theme,
            onEdit: () => _showEditSheet(complaint),
            onDelete: () => _confirmDelete(complaint),
          );
        },
      ),
    );
  }

  void _showEditSheet(ComplaintModel complaint) {
    final cubit = context.read<ComplaintCubit>();
    cubit.titleController.text = complaint.title ?? '';
    cubit.descriptionController.text = complaint.description ?? '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _EditComplaintSheet(
          complaintId: complaint.id ?? '',
          theme: Theme.of(context),
        ),
      ),
    );
  }

  void _confirmDelete(ComplaintModel complaint) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            AppText(
              'حذف الشكوى',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ],
        ),
        content: AppText(
          'هل أنت متأكد من حذف "${complaint.title ?? 'هذه الشكوى'}"؟ لا يمكن التراجع عن هذا الإجراء.',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.kGreyColor,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const AppText(
              'إلغاء',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.kGreyColor,
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.read<ComplaintCubit>().deleteComplaint(
                complaint.id ?? '',
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const AppText(
              'حذف',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return SizedBox(
      height: 500,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_rounded,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.45),
              ),
            ),
            const SizedBox(height: 24),
            AppText(
              'لا توجد شكاوى',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 8),
            const AppText(
              'لم تقم بتقديم أي شكاوى بعد',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.kGreyColor,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text(
                'تقديم شكوى',
                style: TextStyle(fontFamily: 'Cairo-Bold'),
              ),
              style: OutlinedButton.styleFrom(
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

  Widget _buildErrorState(String message, ThemeData theme) {
    return SizedBox(
      height: 500,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 56,
                  color: Colors.red.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 20),
              AppText(
                'حدث خطأ',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(height: 8),
              AppText(
                message,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.kGreyColor,
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () =>
                    context.read<ComplaintCubit>().loadComplaints(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(fontFamily: 'Cairo-Bold'),
                ),
                style: FilledButton.styleFrom(
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
      ),
    );
  }

  Widget _buildShimmer(ThemeData theme) {
    final baseColor = theme.brightness == Brightness.dark
        ? Colors.grey[800]!
        : Colors.grey[300]!;
    final highlightColor = theme.brightness == Brightness.dark
        ? Colors.grey[700]!
        : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: List.generate(
            5,
            (i) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Complaint card with swipe-to-delete
// ---------------------------------------------------------------------------

class _ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  final int index;
  final ThemeData theme;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ComplaintCard({
    super.key,
    required this.complaint,
    required this.index,
    required this.theme,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + index * 70),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - value)),
          child: child,
        ),
      ),
      child: Dismissible(
        key: ValueKey(complaint.id ?? index),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          onDelete();
          return false; // Cubit handles the actual deletion
        },
        background: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: AlignmentDirectional.centerEnd,
          padding: const EdgeInsetsDirectional.only(end: 20),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
              SizedBox(height: 4),
              AppText(
                'حذف',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ],
          ),
        ),
        child: _buildCard(context),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final isActive = complaint.isActive ?? true;
    final statusColor = isActive ? Colors.green : Colors.grey;
    final statusLabel = isActive ? 'نشطة' : 'مغلقة';
    final formattedDate = _formatDate(complaint.createdOn);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showDetail(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.report_problem_rounded,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            complaint.title ?? 'بدون عنوان',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            complaint.description ?? 'لا يوجد وصف',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.kGreyColor,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(label: statusLabel, color: statusColor),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: theme.colorScheme.outline.withValues(alpha: 0.08),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppColors.kGreyColor.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    AppText(
                      formattedDate.isNotEmpty
                          ? formattedDate
                          : 'تاريخ غير متاح',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.kGreyColor,
                    ),
                    const Spacer(),
                    _ActionButton(
                      icon: Icons.edit_outlined,
                      label: 'تعديل',
                      color: theme.colorScheme.primary,
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.delete_outline_rounded,
                      label: 'حذف',
                      color: Colors.red,
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ComplaintDetailSheet(
        complaint: complaint,
        theme: theme,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null) return '';
    try {
      final date = DateTime.parse(raw);
      return DateFormat('dd/MM/yyyy', 'ar').format(date);
    } catch (_) {
      return raw;
    }
  }
}

// ---------------------------------------------------------------------------
// Inline action button
// ---------------------------------------------------------------------------

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            AppText(
              label,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status badge
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 5),
          AppText(
            label,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Detail bottom sheet
// ---------------------------------------------------------------------------

class _ComplaintDetailSheet extends StatelessWidget {
  final ComplaintModel complaint;
  final ThemeData theme;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ComplaintDetailSheet({
    required this.complaint,
    required this.theme,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = complaint.isActive ?? true;
    final statusColor = isActive ? Colors.green : Colors.grey;
    final formattedDate = _formatDate(complaint.createdOn);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppText(
                          complaint.title ?? 'بدون عنوان',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _StatusBadge(
                        label: isActive ? 'نشطة' : 'مغلقة',
                        color: statusColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _InfoRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'تاريخ التقديم',
                    value: formattedDate.isNotEmpty
                        ? formattedDate
                        : 'غير متاح',
                    theme: theme,
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: theme.colorScheme.outline.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            AppText(
                              'الوصف',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        AppText(
                          complaint.description ?? 'لا يوجد وصف',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.kGreyColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onEdit();
                          },
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text(
                            'تعديل',
                            style: TextStyle(fontFamily: 'Cairo-Bold'),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onDelete();
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                          ),
                          label: const Text(
                            'حذف',
                            style: TextStyle(fontFamily: 'Cairo-Bold'),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null) return '';
    try {
      final date = DateTime.parse(raw);
      return DateFormat('dd/MM/yyyy – HH:mm').format(date);
    } catch (_) {
      return raw;
    }
  }
}

// ---------------------------------------------------------------------------
// Edit bottom sheet
// ---------------------------------------------------------------------------

class _EditComplaintSheet extends StatefulWidget {
  final String complaintId;
  final ThemeData theme;

  const _EditComplaintSheet({required this.complaintId, required this.theme});

  @override
  State<_EditComplaintSheet> createState() => _EditComplaintSheetState();
}

class _EditComplaintSheetState extends State<_EditComplaintSheet> {
  bool _popped = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ComplaintCubit>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: widget.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: widget.theme.colorScheme.outline.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.theme.colorScheme.primary.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.edit_note_rounded,
                        color: widget.theme.colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppText(
                      'تعديل الشكوى',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: widget.theme.colorScheme.onSurface,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AppTextFormField(
                  label: 'عنوان الشكوى',
                  controller: cubit.titleController,
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
                  controller: cubit.descriptionController,
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
                BlocConsumer<ComplaintCubit, ComplaintState>(
                  listenWhen: (previous, current) => previous.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  ),
                  listener: (context, state) {
                    state.maybeWhen(
                      success: (_) {
                        if (!_popped) {
                          _popped = true;
                          Navigator.of(context).pop();
                        }
                      },
                      error: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              message,
                              style: const TextStyle(fontFamily: 'Cairo-Bold'),
                            ),
                            backgroundColor: Colors.red.shade400,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      orElse: () {},
                    );
                  },
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                    return SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'حفظ التعديلات',
                        onPressed: () => context
                            .read<ComplaintCubit>()
                            .updateComplaint(widget.complaintId),
                        isLoading: isLoading,
                        icon: Icons.save_rounded,
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
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info row
// ---------------------------------------------------------------------------

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              label,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.kGreyColor,
            ),
            const SizedBox(height: 2),
            AppText(
              value,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ],
        ),
      ],
    );
  }
}
