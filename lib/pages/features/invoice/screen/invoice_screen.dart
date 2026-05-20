import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/components/shimmer_widgets.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';

enum LogCategory { all, transactions, passwordChanges, resets, admin }

enum LogEntryType { transaction, passwordChange, reset, admin }

class LogEntry {
  final String id;
  final String title;
  final String subtitle;
  final String detail;
  final DateTime date;
  final LogEntryType type;
  final double? amount;
  final bool isSuccess;

  const LogEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.date,
    required this.type,
    this.amount,
    this.isSuccess = true,
  });
}

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final _searchController = TextEditingController();
  LogCategory _selectedCategory = LogCategory.all;
  String _searchQuery = '';
  final Set<String> _expandedIds = {};
  bool _isLoading = true;

  final List<LogEntry> _allEntries = [
    LogEntry(
      id: '1',
      title: 'شحن رصيد',
      subtitle: '+100 EGP',
      detail: 'تم شحن المحفظة بمبلغ 100 جنيه عبر Fawry',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      type: LogEntryType.transaction,
      amount: 100,
      isSuccess: true,
    ),
    LogEntry(
      id: '2',
      title: 'تجديد الاشتراك',
      subtitle: '-200 EGP',
      detail: 'تم تجديد باقة بريميوم 100 ميجا لمدة شهر',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      type: LogEntryType.transaction,
      amount: -200,
      isSuccess: true,
    ),
    LogEntry(
      id: '3',
      title: 'تغيير كلمة مرور الراوتر',
      subtitle: 'تم بنجاح',
      detail: 'تم تغيير كلمة مرور الراوتر من الجهاز 192.168.1.5',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: LogEntryType.passwordChange,
      isSuccess: true,
    ),
    LogEntry(
      id: '4',
      title: 'شحن رصيد',
      subtitle: '+50 EGP',
      detail: 'تم شحن المحفظة بمبلغ 50 جنيه عبر Vodafone Cash',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: LogEntryType.transaction,
      amount: 50,
      isSuccess: true,
    ),
    LogEntry(
      id: '5',
      title: 'إعادة تشغيل الراوتر',
      subtitle: 'Soft Reset',
      detail: 'تمت إعادة تشغيل الراوتر بنجاح، جميع الإعدادات محفوظة',
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: LogEntryType.reset,
      isSuccess: true,
    ),
    LogEntry(
      id: '6',
      title: 'تسجيل الدخول',
      subtitle: 'جهاز جديد',
      detail: 'تسجيل دخول من جهاز Android - IP: 192.168.1.12',
      date: DateTime.now().subtract(const Duration(days: 4)),
      type: LogEntryType.admin,
      isSuccess: true,
    ),
    LogEntry(
      id: '7',
      title: 'محاولة تغيير كلمة المرور',
      subtitle: 'فشل',
      detail: 'فشل تغيير كلمة مرور الراوتر - كلمة المرور الحالية خاطئة',
      date: DateTime.now().subtract(const Duration(days: 5)),
      type: LogEntryType.passwordChange,
      isSuccess: false,
    ),
    LogEntry(
      id: '8',
      title: 'خصم اشتراك',
      subtitle: '-150 EGP',
      detail: 'تم خصم مبلغ 150 جنيه لتجديد باقة 50 ميجا',
      date: DateTime.now().subtract(const Duration(days: 7)),
      type: LogEntryType.transaction,
      amount: -150,
      isSuccess: true,
    ),
    LogEntry(
      id: '9',
      title: 'إعادة الضبط الكامل',
      subtitle: 'Factory Reset',
      detail: 'تمت إعادة ضبط الراوتر للإعدادات الافتراضية',
      date: DateTime.now().subtract(const Duration(days: 10)),
      type: LogEntryType.reset,
      isSuccess: true,
    ),
    LogEntry(
      id: '10',
      title: 'تحديث معلومات الحساب',
      subtitle: 'إدارية',
      detail: 'تم تحديث رقم الهاتف والبريد الإلكتروني',
      date: DateTime.now().subtract(const Duration(days: 14)),
      type: LogEntryType.admin,
      isSuccess: true,
    ),
  ];

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
    _searchController.dispose();
    super.dispose();
  }

  List<LogEntry> get _filteredEntries {
    return _allEntries.where((entry) {
      final matchesCategory = _selectedCategory == LogCategory.all ||
          (_selectedCategory == LogCategory.transactions &&
              entry.type == LogEntryType.transaction) ||
          (_selectedCategory == LogCategory.passwordChanges &&
              entry.type == LogEntryType.passwordChange) ||
          (_selectedCategory == LogCategory.resets &&
              entry.type == LogEntryType.reset) ||
          (_selectedCategory == LogCategory.admin &&
              entry.type == LogEntryType.admin);

      final query = _searchQuery.toLowerCase();
      final matchesSearch = query.isEmpty ||
          entry.title.toLowerCase().contains(query) ||
          entry.subtitle.toLowerCase().contains(query) ||
          entry.detail.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get _thisMonthCount {
    final now = DateTime.now();
    return _allEntries
        .where((e) => e.date.month == now.month && e.date.year == now.year)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredEntries;

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
          'سجل الأنشطة',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const InvoiceShimmer()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  _buildSummaryCards(theme),
                  _buildSearchBar(theme),
                  _buildFilterTabs(theme),
                  Expanded(
                    child: filtered.isEmpty
                        ? _buildEmptyState(theme)
                        : _buildEntriesList(theme, filtered),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCards(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
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
            child: _SummaryItem(
              icon: Icons.receipt_long_rounded,
              label: 'إجمالي السجلات',
              value: _allEntries.length.toString(),
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: AppColors.kWhiteColor.withOpacity(0.3),
          ),
          Expanded(
            child: _SummaryItem(
              icon: Icons.calendar_month_rounded,
              label: 'هذا الشهر',
              value: _thisMonthCount.toString(),
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: AppColors.kWhiteColor.withOpacity(0.3),
          ),
          Expanded(
            child: _SummaryItem(
              icon: Icons.check_circle_rounded,
              label: 'ناجحة',
              value:
                  _allEntries.where((e) => e.isSuccess).length.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            fontFamily: 'Cairo-Bold',
            fontSize: 14,
            color: theme.colorScheme.onSurface,
          ),
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            hintText: 'البحث في السجل...',
            hintStyle: TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 14,
              color: AppColors.kGreyColor.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear_rounded,
                      color: AppColors.kGreyColor,
                      size: 20,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(ThemeData theme) {
    final categories = [
      (LogCategory.all, 'الكل'),
      (LogCategory.transactions, 'المالية'),
      (LogCategory.passwordChanges, 'كلمة المرور'),
      (LogCategory.resets, 'إعادة الضبط'),
      (LogCategory.admin, 'إدارية'),
    ];

    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (cat, label) = categories[i];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: AppText(
                label,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.kWhiteColor
                    : theme.colorScheme.onSurface,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 64,
            color: AppColors.kGreyColor.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          const AppText(
            'لا توجد أنشطة',
            fontSize: 16,
            color: AppColors.kGreyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList(ThemeData theme, List<LogEntry> entries) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 250 + (index * 80)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: _LogEntryCard(
            entry: entries[index],
            isExpanded: _expandedIds.contains(entries[index].id),
            theme: theme,
            onTap: () {
              setState(() {
                if (_expandedIds.contains(entries[index].id)) {
                  _expandedIds.remove(entries[index].id);
                } else {
                  _expandedIds.add(entries[index].id);
                }
              });
            },
          ),
        );
      },
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.kWhiteColor, size: 22),
        const SizedBox(height: 6),
        AppText(
          value,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.kWhiteColor,
        ),
        AppText(
          label,
          fontSize: 10,
          color: AppColors.kWhiteColor.withOpacity(0.85),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }
}

class _LogEntryCard extends StatelessWidget {
  final LogEntry entry;
  final bool isExpanded;
  final ThemeData theme;
  final VoidCallback onTap;

  const _LogEntryCard({
    required this.entry,
    required this.isExpanded,
    required this.theme,
    required this.onTap,
  });

  IconData get _icon {
    switch (entry.type) {
      case LogEntryType.transaction:
        return Icons.account_balance_wallet_rounded;
      case LogEntryType.passwordChange:
        return Icons.lock_rounded;
      case LogEntryType.reset:
        return Icons.restart_alt_rounded;
      case LogEntryType.admin:
        return Icons.admin_panel_settings_rounded;
    }
  }

  Color get _color {
    switch (entry.type) {
      case LogEntryType.transaction:
        return Colors.blue;
      case LogEntryType.passwordChange:
        return Colors.orange;
      case LogEntryType.reset:
        return Colors.purple;
      case LogEntryType.admin:
        return Colors.teal;
    }
  }

  String get _categoryLabel {
    switch (entry.type) {
      case LogEntryType.transaction:
        return 'مالية';
      case LogEntryType.passwordChange:
        return 'كلمة المرور';
      case LogEntryType.reset:
        return 'إعادة الضبط';
      case LogEntryType.admin:
        return 'إدارية';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = entry.isSuccess ? _color : AppColors.kRedColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded
              ? effectiveColor.withOpacity(0.3)
              : theme.colorScheme.outline.withOpacity(0.1),
          width: isExpanded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: effectiveColor.withOpacity(0.06),
          highlightColor: effectiveColor.withOpacity(0.03),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: effectiveColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_icon, color: effectiveColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AppText(
                                  entry.title,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              if (entry.amount != null)
                                AppText(
                                  entry.amount! > 0
                                      ? '+${entry.amount!.toStringAsFixed(0)} EGP'
                                      : '${entry.amount!.toStringAsFixed(0)} EGP',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: entry.amount! > 0
                                      ? Colors.green
                                      : AppColors.kRedColor,
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              AppText(
                                _formatDate(entry.date),
                                fontSize: 12,
                                color: AppColors.kGreyColor,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: effectiveColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: AppText(
                                  _categoryLabel,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: effectiveColor,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: entry.isSuccess
                                      ? Colors.green.withOpacity(0.1)
                                      : AppColors.kRedColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: AppText(
                                  entry.isSuccess ? 'ناجح' : 'فشل',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: entry.isSuccess
                                      ? Colors.green
                                      : AppColors.kRedColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.kGreyColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: effectiveColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: effectiveColor.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: effectiveColor.withOpacity(0.8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppText(
                            entry.detail,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            maxLines: 4,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
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
