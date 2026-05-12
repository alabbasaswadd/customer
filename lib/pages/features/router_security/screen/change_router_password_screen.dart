import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/components/app_button.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/components/app_text_form_field.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';

enum _PasswordStrength { none, weak, fair, strong, veryStrong }

class ChangeRouterPasswordScreen extends StatefulWidget {
  const ChangeRouterPasswordScreen({super.key});

  @override
  State<ChangeRouterPasswordScreen> createState() =>
      _ChangeRouterPasswordScreenState();
}

class _ChangeRouterPasswordScreenState
    extends State<ChangeRouterPasswordScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _isLoading = false;
  _PasswordStrength _strength = _PasswordStrength.none;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _evaluateStrength(String password) {
    if (password.isEmpty) {
      setState(() => _strength = _PasswordStrength.none);
      return;
    }
    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*]').hasMatch(password)) score++;

    setState(() {
      if (score <= 1) {
        _strength = _PasswordStrength.weak;
      } else if (score == 2) {
        _strength = _PasswordStrength.fair;
      } else if (score == 3) {
        _strength = _PasswordStrength.strong;
      } else {
        _strength = _PasswordStrength.veryStrong;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);
    _showResultDialog(success: true);
  }

  void _showResultDialog({required bool success}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ResultDialog(
        success: success,
        onAction: () {
          Navigator.pop(context);
          if (success) Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          'تغيير كلمة مرور الراوتر',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(theme),
                    const SizedBox(height: 24),
                    _buildCurrentPasswordField(theme),
                    const SizedBox(height: 8),
                    _buildNewPasswordField(theme),
                    _buildStrengthIndicator(theme),
                    const SizedBox(height: 8),
                    _buildConfirmPasswordField(theme),
                    const SizedBox(height: 8),
                    _buildPasswordRules(theme),
                    const SizedBox(height: 32),
                    AppButton(
                      text: 'حفظ كلمة المرور',
                      onPressed: _submit,
                      isLoading: _isLoading,
                      icon: Icons.lock_reset_rounded,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange,
            Colors.orange.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
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
              Icons.router_rounded,
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
                  'تأمين الراوتر',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kWhiteColor,
                ),
                const SizedBox(height: 4),
                AppText(
                  'استخدم كلمة مرور قوية لحماية شبكتك',
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

  Widget _buildCurrentPasswordField(ThemeData theme) {
    return AppTextFormField(
      label: 'كلمة المرور الحالية',
      controller: _currentPasswordController,
      obscureText: !_showCurrent,
      icon: Icons.lock_outline_rounded,
      suffixIcon: IconButton(
        icon: Icon(
          _showCurrent ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          color: AppColors.kGreyColor,
          size: 20,
        ),
        onPressed: () => setState(() => _showCurrent = !_showCurrent),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return 'الرجاء إدخال كلمة المرور الحالية';
        return null;
      },
    );
  }

  Widget _buildNewPasswordField(ThemeData theme) {
    return AppTextFormField(
      label: 'كلمة المرور الجديدة',
      controller: _newPasswordController,
      obscureText: !_showNew,
      icon: Icons.lock_rounded,
      onChanged: _evaluateStrength,
      suffixIcon: IconButton(
        icon: Icon(
          _showNew ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          color: AppColors.kGreyColor,
          size: 20,
        ),
        onPressed: () => setState(() => _showNew = !_showNew),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return 'الرجاء إدخال كلمة المرور الجديدة';
        if (val.length < 8) return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
        return null;
      },
    );
  }

  Widget _buildStrengthIndicator(ThemeData theme) {
    if (_strength == _PasswordStrength.none) return const SizedBox.shrink();

    final strengthData = _getStrengthData();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AppText(
                  'قوة كلمة المرور: ',
                  fontSize: 12,
                  color: AppColors.kGreyColor,
                ),
                AppText(
                  strengthData.$1,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: strengthData.$2,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: List.generate(4, (i) {
                final active = i < strengthData.$3;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                    height: 4,
                    decoration: BoxDecoration(
                      color: active
                          ? strengthData.$2
                          : AppColors.kGreyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  (String, Color, int) _getStrengthData() {
    switch (_strength) {
      case _PasswordStrength.weak:
        return ('ضعيفة', AppColors.kRedColor, 1);
      case _PasswordStrength.fair:
        return ('متوسطة', Colors.orange, 2);
      case _PasswordStrength.strong:
        return ('قوية', Colors.blue, 3);
      case _PasswordStrength.veryStrong:
        return ('قوية جداً', Colors.green, 4);
      case _PasswordStrength.none:
        return ('', Colors.transparent, 0);
    }
  }

  Widget _buildConfirmPasswordField(ThemeData theme) {
    return AppTextFormField(
      label: 'تأكيد كلمة المرور الجديدة',
      controller: _confirmPasswordController,
      obscureText: !_showConfirm,
      icon: Icons.lock_clock_rounded,
      suffixIcon: IconButton(
        icon: Icon(
          _showConfirm ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          color: AppColors.kGreyColor,
          size: 20,
        ),
        onPressed: () => setState(() => _showConfirm = !_showConfirm),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return 'الرجاء تأكيد كلمة المرور';
        if (val != _newPasswordController.text) return 'كلمتا المرور غير متطابقتين';
        return null;
      },
    );
  }

  Widget _buildPasswordRules(ThemeData theme) {
    final rules = [
      '8 أحرف على الأقل',
      'حرف كبير واحد على الأقل',
      'رقم واحد على الأقل',
      'رمز خاص مستحسن (!@#\$%^&*)',
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              AppText(
                'متطلبات كلمة المرور',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...rules.map(
            (rule) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 6,
                    color: AppColors.kGreyColor.withOpacity(0.6),
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    rule,
                    fontSize: 12,
                    color: AppColors.kGreyColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultDialog extends StatefulWidget {
  final bool success;
  final VoidCallback onAction;

  const _ResultDialog({required this.success, required this.onAction});

  @override
  State<_ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<_ResultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.success ? Colors.green : AppColors.kRedColor;
    final icon = widget.success ? Icons.check_rounded : Icons.close_rounded;
    final title = widget.success
        ? 'تم تغيير كلمة المرور بنجاح'
        : 'فشل تغيير كلمة المرور';
    final subtitle = widget.success
        ? 'كلمة مرور الراوتر الجديدة فعّالة الآن'
        : 'تحقق من كلمة المرور الحالية وحاول مجدداً';

    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _iconAnimation,
                builder: (context, _) => Transform.scale(
                  scale: _iconAnimation.value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                        child: Icon(icon, color: AppColors.kWhiteColor, size: 32),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppText(
                title,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 8),
              AppText(
                subtitle,
                fontSize: 13,
                color: AppColors.kGreyColor,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: AppText(
                    widget.success ? 'تم' : 'حاول مرة أخرى',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kWhiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
