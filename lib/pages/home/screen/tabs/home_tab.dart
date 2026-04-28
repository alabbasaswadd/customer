import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mikrotic_customer/pages/home/cubit/home_cubit.dart';
import 'package:mikrotic_customer/pages/home/cubit/home_state.dart';
import 'package:mikrotic_customer/pages/home/model/user_model.dart';
import 'package:mikrotic_customer/pages/home/screen/widgets/balance_card.dart';
import 'package:mikrotic_customer/pages/home/screen/widgets/greeting_header.dart';
import 'package:mikrotic_customer/pages/home/screen/widgets/home_error_widget.dart';
import 'package:mikrotic_customer/pages/home/screen/widgets/home_loading_widget.dart';
import 'package:mikrotic_customer/pages/home/screen/widgets/subscription_card.dart';
import 'package:mikrotic_customer/pages/home/screen/widgets/quick_actions_widget.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _balanceAnimation;
  late Animation<double> _subscriptionAnimation;
  late Animation<double> _actionsAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    context.read<HomeCubit>().loadUserProfile();
  }

  void _setupAnimations() {
    _mainAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _balanceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _subscriptionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _actionsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState<UserModel>>(
      listener: (context, state) {
        state.maybeWhen(
          success: (_) {
            _mainAnimationController.forward();
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => const HomeLoadingWidget(),
          loading: () => const HomeLoadingWidget(),
          success: (user) => _buildContent(user),
          error: (message) => HomeErrorWidget(
            errorMessage: message,
            onRetry: () => context.read<HomeCubit>().loadUserProfile(),
          ),
        );
      },
    );
  }

  Widget _buildContent(UserModel user) {
    return RefreshIndicator(
      onRefresh: () async {
        _mainAnimationController.reset();
        await context.read<HomeCubit>().refreshData();
        _mainAnimationController.forward();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with greeting
            AnimatedBuilder(
              animation: _headerAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -30 * (1 - _headerAnimation.value)),
                  child: Opacity(opacity: _headerAnimation.value, child: child),
                );
              },
              child: GreetingHeader(
                userName: user.fullName,
                onNotificationTap: _onNotificationTap,
                notificationCount: 3,
              ),
            ),

            const SizedBox(height: 24),

            // Balance Card
            AnimatedBuilder(
              animation: _balanceAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * _balanceAnimation.value),
                  child: Opacity(
                    opacity: _balanceAnimation.value,
                    child: child,
                  ),
                );
              },
              child: BalanceCard(
                balance: user.balance,
                onRecharge: _onRecharge,
              ),
            ),

            const SizedBox(height: 24),

            // Subscription Card
            AnimatedBuilder(
              animation: _subscriptionAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(50 * (1 - _subscriptionAnimation.value), 0),
                  child: Opacity(
                    opacity: _subscriptionAnimation.value,
                    child: child,
                  ),
                );
              },
              child: SubscriptionCard(
                subscription: user.subscription,
                onRenew: _onRenew,
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            AnimatedBuilder(
              animation: _actionsAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - _actionsAnimation.value)),
                  child: Opacity(
                    opacity: _actionsAnimation.value,
                    child: child,
                  ),
                );
              },
              child: const QuickActionsWidget(),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _onNotificationTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('الإشعارات'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onRecharge() {
    context.push('/payment');
  }

  void _onRenew() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تجديد الاشتراك'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
