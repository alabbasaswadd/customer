import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/components/shimmer_widgets.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';
import 'package:mikrotic_customer/pages/features/notifications/model/notification_model.dart';

enum _Filter { all, unread }

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  _Filter _filter = _Filter.all;
  late List<NotificationModel> _notifications;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _notifications = _buildMockNotifications();

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

  List<NotificationModel> _buildMockNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: '1',
        title: 'تجديد الاشتراك',
        body: 'تم تجديد اشتراكك بنجاح. الباقة: ألترا 100 ميجا',
        type: NotificationType.billing,
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      NotificationModel(
        id: '2',
        title: 'الاشتراك ينتهي قريباً',
        body: 'اشتراكك سينتهي خلال 3 أيام. قم بالتجديد لتجنب انقطاع الخدمة',
        type: NotificationType.alert,
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
      NotificationModel(
        id: '3',
        title: 'دفعة مستلمة',
        body: 'تم استلام دفعتك بمبلغ 25\$ بنجاح',
        type: NotificationType.billing,
        createdAt: now.subtract(const Duration(hours: 7)),
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        title: 'صيانة مجدولة',
        body: 'سيتم إجراء أعمال صيانة على الشبكة غداً من 2 إلى 4 صباحاً',
        type: NotificationType.system,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      NotificationModel(
        id: '5',
        title: 'فاتورة جديدة',
        body: 'فاتورتك لشهر مايو جاهزة. المبلغ المستحق: 25\$',
        type: NotificationType.billing,
        createdAt: now.subtract(const Duration(days: 1, hours: 6)),
        isRead: true,
      ),
      NotificationModel(
        id: '6',
        title: 'انقطاع مؤقت في الخدمة',
        body: 'تم رصد انقطاع مؤقت في منطقتك. نعمل على الإصلاح العاجل',
        type: NotificationType.alert,
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
      NotificationModel(
        id: '7',
        title: 'تحديث التطبيق',
        body: 'إصدار جديد من التطبيق متاح الآن مع تحسينات في الأداء',
        type: NotificationType.system,
        createdAt: now.subtract(const Duration(days: 3)),
        isRead: true,
      ),
      NotificationModel(
        id: '8',
        title: 'عرض حصري',
        body: 'احصل على شهر مجاني عند ترقية اشتراكك إلى الباقة البلاتينية',
        type: NotificationType.info,
        createdAt: now.subtract(const Duration(days: 4)),
        isRead: true,
      ),
    ];
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  List<NotificationModel> get _filtered {
    if (_filter == _Filter.unread) {
      return _notifications.where((n) => !n.isRead).toList();
    }
    return List.from(_notifications);
  }

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _markRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) _notifications[index].isRead = true;
    });
  }

  void _dismiss(String id) {
    setState(() => _notifications.removeWhere((n) => n.id == id));
  }

  Map<String, List<NotificationModel>> _groupByDate(
    List<NotificationModel> list,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final groups = <String, List<NotificationModel>>{};
    for (final n in list) {
      final d = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
      final key = d == today
          ? 'اليوم'
          : d == yesterday
              ? 'أمس'
              : 'سابقاً';
      groups.putIfAbsent(key, () => []).add(n);
    }
    return groups;
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  List<dynamic> _buildFlatList() {
    final filtered = _filtered;
    final groups = _groupByDate(filtered);
    const sectionOrder = ['اليوم', 'أمس', 'سابقاً'];
    final flat = <dynamic>[];
    for (final key in sectionOrder) {
      if (groups.containsKey(key)) {
        flat.add(key);
        flat.addAll(groups[key]!);
      }
    }
    return flat;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final flat = _buildFlatList();

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
          t.notifications,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
        centerTitle: true,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: AppText(
                'قراءة الكل',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const NotificationsShimmer()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    _buildSummaryCard(theme),
                    _buildFilterRow(theme),
                    Expanded(
                      child: flat.isEmpty
                          ? _buildEmptyState(theme)
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 8, 20, 24),
                              itemCount: flat.length,
                              itemBuilder: (context, index) {
                                final item = flat[index];
                                if (item is String) {
                                  return _buildSectionHeader(item, theme);
                                }
                                return _buildNotificationItem(
                                  item as NotificationModel,
                                  index,
                                  theme,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.kWhiteColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: AppColors.kWhiteColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  _unreadCount > 0
                      ? '$_unreadCount إشعار غير مقروء'
                      : 'لا توجد إشعارات جديدة',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kWhiteColor,
                ),
                const SizedBox(height: 3),
                AppText(
                  'إجمالي الإشعارات: ${_notifications.length}',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.kWhiteColor.withOpacity(0.8),
                ),
              ],
            ),
          ),
          if (_unreadCount > 0)
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.kRedColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: AppText(
                '$_unreadCount',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.kWhiteColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _FilterChip(
            label: 'الكل',
            isSelected: _filter == _Filter.all,
            theme: theme,
            onTap: () => setState(() => _filter = _Filter.all),
          ),
          const SizedBox(width: 12),
          _FilterChip(
            label: 'غير مقروء',
            count: _unreadCount,
            isSelected: _filter == _Filter.unread,
            theme: theme,
            onTap: () => setState(() => _filter = _Filter.unread),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: AppText(
        title,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.kGreyColor,
      ),
    );
  }

  Widget _buildNotificationItem(
    NotificationModel notification,
    int index,
    ThemeData theme,
  ) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(notification.id),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 250 + (index * 50).clamp(0, 400)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _NotificationCard(
        notification: notification,
        theme: theme,
        onTap: () => _markRead(notification.id),
        onDismiss: () => _dismiss(notification.id),
        formatTime: _formatTime,
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_rounded,
                size: 54,
                color: theme.colorScheme.primary.withOpacity(0.45),
              ),
            ),
            const SizedBox(height: 24),
            AppText(
              'لا توجد إشعارات',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            AppText(
              'ستظهر إشعاراتك هنا عند وصولها',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.kGreyColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _FilterChip extends StatelessWidget {
  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
    this.count,
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
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
              AppText(
                label,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.kWhiteColor
                    : theme.colorScheme.onSurface,
              ),
              if (count != null && count! > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.kWhiteColor.withOpacity(0.25)
                        : AppColors.kRedColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AppText(
                    '$count',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kWhiteColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final ThemeData theme;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  final String Function(DateTime) formatTime;

  const _NotificationCard({
    required this.notification,
    required this.theme,
    required this.onTap,
    required this.onDismiss,
    required this.formatTime,
  });

  Color get _typeColor {
    switch (notification.type) {
      case NotificationType.billing:
        return Colors.green;
      case NotificationType.alert:
        return Colors.orange;
      case NotificationType.system:
        return Colors.deepPurple;
      case NotificationType.info:
        return Colors.blue;
    }
  }

  IconData get _typeIcon {
    switch (notification.type) {
      case NotificationType.billing:
        return Icons.receipt_long_rounded;
      case NotificationType.alert:
        return Icons.warning_amber_rounded;
      case NotificationType.system:
        return Icons.settings_rounded;
      case NotificationType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete_rounded,
          color: AppColors.kWhiteColor,
          size: 24,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead
                ? theme.cardColor
                : theme.colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? theme.colorScheme.outline.withOpacity(0.1)
                  : theme.colorScheme.primary.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _typeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_typeIcon, color: _typeColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppText(
                            notification.title,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    AppText(
                      notification.body,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.kGreyColor,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: AppColors.kGreyColor.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        AppText(
                          formatTime(notification.createdAt),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.kGreyColor.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
