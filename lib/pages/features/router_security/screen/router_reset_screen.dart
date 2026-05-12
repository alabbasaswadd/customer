import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';

enum _ResetType { soft, factory }

enum _ResetState { idle, confirming, loading, success, failed }

class RouterResetScreen extends StatefulWidget {
  const RouterResetScreen({super.key});

  @override
  State<RouterResetScreen> createState() => _RouterResetScreenState();
}

class _RouterResetScreenState extends State<RouterResetScreen>
    with TickerProviderStateMixin {
  _ResetType? _selectedType;
  _ResetState _resetState = _ResetState.idle;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _loadingController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.easeOutCubic),
    );

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _loadingController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _confirmReset() {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('الرجاء اختيار نوع إعادة الضبط'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.kRedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    setState(() => _resetState = _ResetState.confirming);
    _showConfirmationDialog();
  }

  void _showConfirmationDialog() {
    final theme = Theme.of(context);
    final isFactory = _selectedType == _ResetType.factory;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.kRedColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.kRedColor,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              AppText(
                'تأكيد إعادة الضبط',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(height: 12),
              AppText(
                isFactory
                    ? 'سيتم حذف جميع الإعدادات المخصصة نهائياً. هل أنت متأكد؟'
                    : 'سيتم إعادة تشغيل الراوتر مؤقتاً. هل تريد المتابعة؟',
                fontSize: 14,
                color: AppColors.kGreyColor,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.visible,
              ),
              if (isFactory) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.kRedColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.kRedColor.withOpacity(0.2),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.kRedColor,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: AppText(
                          'لا يمكن التراجع عن هذا الإجراء',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kRedColor,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          setState(() => _resetState = _ResetState.idle);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outline.withOpacity(0.2),
                            ),
                          ),
                          child: AppText(
                            'إلغاء',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Material(
                      color: AppColors.kRedColor,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _executeReset();
                        },
                        borderRadius: BorderRadius.circular(12),
                        splashColor: Colors.white.withOpacity(0.2),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.kRedColor,
                                Color.lerp(
                                    AppColors.kRedColor, Colors.black, 0.1)!,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: const AppText(
                            'تأكيد',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kWhiteColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _executeReset() async {
    setState(() => _resetState = _ResetState.loading);
    _progressController.forward();

    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;
    setState(() => _resetState = _ResetState.success);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _resetState == _ResetState.loading ||
              _resetState == _ResetState.success ||
              _resetState == _ResetState.failed
          ? null
          : AppBar(
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
                'إعادة ضبط الراوتر',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              centerTitle: true,
            ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _buildBodyForState(theme),
      ),
    );
  }

  Widget _buildBodyForState(ThemeData theme) {
    switch (_resetState) {
      case _ResetState.loading:
        return _buildLoadingState(theme);
      case _ResetState.success:
        return _buildResultState(theme, success: true);
      case _ResetState.failed:
        return _buildResultState(theme, success: false);
      default:
        return _buildIdleState(theme);
    }
  }

  Widget _buildIdleState(ThemeData theme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWarningBanner(theme),
                const SizedBox(height: 24),
                AppText(
                  'اختر نوع إعادة الضبط',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(height: 16),
                _buildResetOption(
                  theme: theme,
                  type: _ResetType.soft,
                  icon: Icons.restart_alt_rounded,
                  title: 'إعادة التشغيل',
                  subtitle: 'Soft Reset',
                  description:
                      'إعادة تشغيل الراوتر مع الاحتفاظ بجميع الإعدادات المخصصة. الاتصال سينقطع لثوانٍ.',
                  color: Colors.blue,
                  isRisky: false,
                ),
                const SizedBox(height: 12),
                _buildResetOption(
                  theme: theme,
                  type: _ResetType.factory,
                  icon: Icons.settings_backup_restore_rounded,
                  title: 'إعادة الضبط الكامل',
                  subtitle: 'Factory Reset',
                  description:
                      'حذف جميع الإعدادات وإعادة الراوتر إلى حالته الافتراضية. لا يمكن التراجع عن هذه العملية.',
                  color: AppColors.kRedColor,
                  isRisky: true,
                ),
                const SizedBox(height: 32),
                _buildResetButton(theme),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWarningBanner(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade600, Colors.red.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.kRedColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.kWhiteColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.kWhiteColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'تحذير',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kWhiteColor,
                ),
                const SizedBox(height: 4),
                AppText(
                  'بعض خيارات إعادة الضبط لا يمكن التراجع عنها',
                  fontSize: 13,
                  color: AppColors.kWhiteColor.withOpacity(0.85),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetOption({
    required ThemeData theme,
    required _ResetType type,
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required bool isRisky,
  }) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : theme.colorScheme.outline.withOpacity(0.15),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.15)
                  : theme.shadowColor.withOpacity(0.05),
              blurRadius: isSelected ? 15 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppText(
                        title,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AppText(
                          subtitle,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  AppText(
                    description,
                    fontSize: 13,
                    color: AppColors.kGreyColor,
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                  ),
                  if (isRisky) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kRedColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.kRedColor.withOpacity(0.2),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 14,
                            color: AppColors.kRedColor,
                          ),
                          SizedBox(width: 6),
                          AppText(
                            'لا يمكن التراجع',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kRedColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : AppColors.kGreyColor.withOpacity(0.4),
                  width: 2,
                ),
                color: isSelected ? color : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.kWhiteColor,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton(ThemeData theme) {
    final isFactory = _selectedType == _ResetType.factory;
    final buttonColor =
        _selectedType == null ? AppColors.kGreyColor : AppColors.kRedColor;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: _confirmReset,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withOpacity(0.2),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  buttonColor,
                  Color.lerp(buttonColor, Colors.black, 0.1)!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isFactory
                      ? Icons.settings_backup_restore_rounded
                      : Icons.restart_alt_rounded,
                  color: AppColors.kWhiteColor,
                  size: 22,
                ),
                const SizedBox(width: 10),
                AppText(
                  isFactory ? 'إعادة الضبط الكامل' : 'إعادة التشغيل',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kWhiteColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _loadingController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _loadingController.value * 2 * 3.14159,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.15),
                        width: 6,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.router_rounded,
                          color: theme.colorScheme.primary,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            AppText(
              'جاري إعادة الضبط...',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 8),
            const AppText(
              'يرجى الانتظار، لا تغلق التطبيق',
              fontSize: 14,
              color: AppColors.kGreyColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, _) => Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _progressAnimation.value,
                      minHeight: 8,
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppText(
                    '${(_progressAnimation.value * 100).toInt()}%',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultState(ThemeData theme, {required bool success}) {
    final color = success ? Colors.green : AppColors.kRedColor;
    final icon = success ? Icons.check_rounded : Icons.close_rounded;
    final title = success ? 'تمت العملية بنجاح' : 'فشل إعادة الضبط';
    final subtitle = success
        ? (_selectedType == _ResetType.factory
            ? 'تمت إعادة ضبط الراوتر للإعدادات الافتراضية'
            : 'تمت إعادة تشغيل الراوتر بنجاح')
        : 'حدث خطأ أثناء إعادة الضبط، حاول مجدداً';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              builder: (context, value, child) =>
                  Transform.scale(scale: value, child: child),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.1),
                ),
                child: Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                    child: Icon(icon, color: AppColors.kWhiteColor, size: 36),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            AppText(
              title,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            AppText(
              subtitle,
              fontSize: 14,
              color: AppColors.kGreyColor,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const AppText(
                  'العودة',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kWhiteColor,
                ),
              ),
            ),
            if (!success) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _resetState = _ResetState.idle;
                      _progressController.reset();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  child: AppText(
                    'حاول مرة أخرى',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
