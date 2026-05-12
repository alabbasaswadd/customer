import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';

class WalletSectionWidget extends StatelessWidget {
  final double balance;
  final double income;
  final double expenses;

  const WalletSectionWidget({
    super.key,
    required this.balance,
    required this.income,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'المحفظة',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          _buildBalanceCard(context, theme),
          const SizedBox(height: 12),
          _buildSummaryRow(theme),
          const SizedBox(height: 16),
          _buildRecentActivity(context, theme),
          const SizedBox(height: 16),
          _buildQuickActions(context, theme),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.kWhiteColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: AppColors.kWhiteColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  AppText(
                    'رصيد المحفظة',
                    fontSize: 14,
                    color: AppColors.kWhiteColor.withOpacity(0.9),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.kWhiteColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.greenAccent,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const AppText(
                      'نشط',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kWhiteColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                balance.toStringAsFixed(2),
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: AppColors.kWhiteColor,
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: AppText(
                  'EGP',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.kWhiteColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'وارد',
            value: '+${income.toStringAsFixed(0)}',
            icon: Icons.arrow_downward_rounded,
            color: Colors.green,
            theme: theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'صادر',
            value: '-${expenses.toStringAsFixed(0)}',
            icon: Icons.arrow_upward_rounded,
            color: AppColors.kRedColor,
            theme: theme,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context, ThemeData theme) {
    final activities = [
      const _ActivityItem(
        title: 'شحن رصيد',
        amount: '+100 EGP',
        isPositive: true,
        time: 'منذ ساعتين',
      ),
      const _ActivityItem(
        title: 'تجديد الاشتراك',
        amount: '-200 EGP',
        isPositive: false,
        time: 'منذ 5 ساعات',
      ),
      const _ActivityItem(
        title: 'شحن رصيد',
        amount: '+50 EGP',
        isPositive: true,
        time: 'أمس',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                'آخر العمليات',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              GestureDetector(
                onTap: () => context.push('/invoice'),
                child: AppText(
                  'عرض الكل',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...activities.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (a.isPositive ? Colors.green : AppColors.kRedColor)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      a.isPositive
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      color: a.isPositive ? Colors.green : AppColors.kRedColor,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          a.title,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        AppText(
                          a.time,
                          fontSize: 11,
                          color: AppColors.kGreyColor,
                        ),
                      ],
                    ),
                  ),
                  AppText(
                    a.amount,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: a.isPositive ? Colors.green : AppColors.kRedColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.add_rounded,
            label: 'إضافة رصيد',
            color: Colors.green,
            onTap: () => context.push('/payment'),
            theme: theme,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.swap_horiz_rounded,
            label: 'تحويل',
            color: Colors.blue,
            onTap: () {},
            theme: theme,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.history_rounded,
            label: 'السجل',
            color: Colors.purple,
            onTap: () => context.push('/invoice'),
            theme: theme,
          ),
        ),
      ],
    );
  }
}

class _ActivityItem {
  final String title;
  final String amount;
  final bool isPositive;
  final String time;

  const _ActivityItem({
    required this.title,
    required this.amount,
    required this.isPositive,
    required this.time,
  });
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final ThemeData theme;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  fontSize: 12,
                  color: AppColors.kGreyColor,
                ),
                AppText(
                  value,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final ThemeData theme;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.theme,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.color.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(widget.icon, color: widget.color, size: 22),
              const SizedBox(height: 6),
              AppText(
                widget.label,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: widget.color,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
