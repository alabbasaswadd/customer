import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mikrotic_customer/core/components/app_button.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/components/app_text_form_field.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';
import 'package:mikrotic_customer/pages/home/cubit/support_cubit.dart';
import 'package:mikrotic_customer/pages/home/cubit/support_state.dart';

class SupportTab extends StatefulWidget {
  const SupportTab({super.key});

  @override
  State<SupportTab> createState() => _SupportTabState();
}

class _SupportTabState extends State<SupportTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
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

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocListener<SupportCubit, SupportState>(
      listener: (context, state) {
        state.maybeWhen(
          success: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.complaint_submitted),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<SupportCubit>().resetState();
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.kRedColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<SupportCubit>().resetState();
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
                  _buildHeader(t, theme),
                  const SizedBox(height: 24),
                  _buildLiveChatCard(theme),
                  const SizedBox(height: 16),
                  _buildComplaintForm(t, theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations t, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          t.support,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
        const SizedBox(height: 8),
        AppText(
          t.support_subtitle,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.kGreyColor,
        ),
      ],
    );
  }

  // Widget _buildContactInfo(AppLocalizations t, ThemeData theme) {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           theme.colorScheme.primary,
  //           theme.colorScheme.primary.withOpacity(0.8),
  //         ],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: theme.colorScheme.primary.withOpacity(0.3),
  //           blurRadius: 15,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 color: AppColors.kWhiteColor.withOpacity(0.2),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: const Icon(
  //                 Icons.support_agent_rounded,
  //                 color: AppColors.kWhiteColor,
  //                 size: 28,
  //               ),
  //             ),
  //             const SizedBox(width: 16),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   AppText(
  //                     t.contact_support,
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w700,
  //                     color: AppColors.kWhiteColor,
  //                   ),
  //                   const SizedBox(height: 4),
  //                   AppText(
  //                     t.available_24_7,
  //                     fontSize: 13,
  //                     fontWeight: FontWeight.w400,
  //                     color: AppColors.kWhiteColor.withOpacity(0.8),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: _buildContactButton(
  //                 icon: Icons.phone_rounded,
  //                 label: t.call_us,
  //                 onTap: () {},
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: _buildContactButton(
  //                 icon: Icons.chat_rounded,
  //                 label: t.whatsapp,
  //                 onTap: () {},
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.kWhiteColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.kWhiteColor, size: 20),
              const SizedBox(width: 8),
              AppText(
                label,
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

  Widget _buildLiveChatCard(ThemeData theme) {
    return GestureDetector(
      onTap: () => context.push('/chat'),
      child: Container(
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
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.kWhiteColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: AppColors.kWhiteColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'الدردشة مع الدعم الفني',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kWhiteColor,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    'تواصل مباشرة • يعمل دون إنترنت',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.kWhiteColor.withOpacity(0.85),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.kWhiteColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.kWhiteColor,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintForm(AppLocalizations t, ThemeData theme) {
    final cubit = context.read<SupportCubit>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.edit_note_rounded,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                AppText(
                  t.submit_complaint,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ],
            ),

            const SizedBox(height: 16),
            AppTextFormField(
              label: t.message,
              controller: cubit.messageController,
              icon: Icons.message_outlined,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return t.message_required;
                }
                if (value.length < 10) {
                  return t.message_too_short;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            BlocBuilder<SupportCubit, SupportState>(
              builder: (context, state) {
                final isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );
                return SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: t.submit,
                    onPressed: () => cubit.submitComplaint(),
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
}
