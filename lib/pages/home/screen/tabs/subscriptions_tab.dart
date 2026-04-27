import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';
import 'package:mikrotic_customer/pages/home/cubit/subscriptions_cubit.dart';
import 'package:mikrotic_customer/pages/home/cubit/subscriptions_state.dart';
import 'package:mikrotic_customer/pages/home/model/subscription_plan_model.dart';
import 'package:mikrotic_customer/pages/home/screen/widgets/home_error_widget.dart';
import 'package:mikrotic_customer/pages/home/screen/widgets/home_loading_widget.dart';

class SubscriptionsTab extends StatefulWidget {
  const SubscriptionsTab({super.key});

  @override
  State<SubscriptionsTab> createState() => _SubscriptionsTabState();
}

class _SubscriptionsTabState extends State<SubscriptionsTab>
    with SingleTickerProviderStateMixin {
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
    context.read<SubscriptionsCubit>().loadPlans();
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

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(t, theme),
            Expanded(
              child: BlocBuilder<SubscriptionsCubit,
                  SubscriptionsState<List<SubscriptionPlanModel>>>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const HomeLoadingWidget(),
                    loading: () => const HomeLoadingWidget(),
                    success: (plans) => _buildPlansList(plans, t, theme),
                    error: (message) => HomeErrorWidget(
                      errorMessage: message,
                      onRetry: () =>
                          context.read<SubscriptionsCubit>().loadPlans(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations t, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            t.subscriptions,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 8),
          AppText(
            t.subscriptions_subtitle,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.kGreyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList(
      List<SubscriptionPlanModel> plans, AppLocalizations t, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 100)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: _PlanCard(
            plan: plans[index],
            onSelect: () => _onSelectPlan(plans[index]),
          ),
        );
      },
    );
  }

  void _onSelectPlan(SubscriptionPlanModel plan) {
    final t = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PlanDetailsSheet(plan: plan),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final VoidCallback onSelect;

  const _PlanCard({
    required this.plan,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: plan.isCurrentPlan
              ? theme.colorScheme.primary
              : plan.isPopular
                  ? Colors.amber
                  : theme.colorScheme.outline.withOpacity(0.1),
          width: plan.isCurrentPlan || plan.isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: AppText(
                                  plan.name,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              if (plan.isCurrentPlan) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: AppText(
                                    t.current_plan,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.kWhiteColor,
                                  ),
                                ),
                              ],
                              if (plan.isPopular && !plan.isCurrentPlan) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: AppText(
                                    t.popular,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.kBlackColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            plan.description,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.kGreyColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.speed_rounded,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          AppText(
                            '${plan.speed.toInt()} ${plan.speedUnit}',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          AppText(
                            '${plan.durationDays} ${t.days}',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppText(
                          plan.price.toStringAsFixed(0),
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: AppText(
                            ' ${plan.currency}/${t.month}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.kGreyColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: plan.isCurrentPlan
                            ? AppColors.kGreyColor.withOpacity(0.2)
                            : theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AppText(
                        plan.isCurrentPlan ? t.current : t.select_plan,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: plan.isCurrentPlan
                            ? AppColors.kGreyColor
                            : AppColors.kWhiteColor,
                      ),
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
}

class _PlanDetailsSheet extends StatelessWidget {
  final SubscriptionPlanModel plan;

  const _PlanDetailsSheet({required this.plan});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.kGreyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          AppText(
            plan.name,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 8),
          AppText(
            plan.description,
            fontSize: 14,
            color: AppColors.kGreyColor,
          ),
          const SizedBox(height: 24),
          AppText(
            t.plan_features,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 12),
          ...plan.features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppText(
                        feature,
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: plan.isCurrentPlan
                  ? null
                  : () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(t.plan_selected),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                disabledBackgroundColor: AppColors.kGreyColor.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: AppText(
                plan.isCurrentPlan ? t.current_plan : t.subscribe_now,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.kWhiteColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
