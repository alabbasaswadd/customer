import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikrotic_customer/core/di/dependency_injection.dart';
import 'package:mikrotic_customer/l10n/app_localizations.dart';
import 'package:mikrotic_customer/pages/home/cubit/home_cubit.dart';
import 'package:mikrotic_customer/pages/home/cubit/maintenance_cubit.dart';
import 'package:mikrotic_customer/pages/home/cubit/subscriptions_cubit.dart';
import 'package:mikrotic_customer/pages/home/cubit/support_cubit.dart';
import 'package:mikrotic_customer/pages/home/screen/tabs/home_tab.dart';
import 'package:mikrotic_customer/pages/home/screen/tabs/maintenance_tab.dart';
import 'package:mikrotic_customer/pages/home/screen/tabs/settings_tab.dart';
import 'package:mikrotic_customer/pages/home/screen/tabs/subscriptions_tab.dart';
import 'package:mikrotic_customer/pages/home/screen/tabs/support_tab.dart';
import 'package:mikrotic_customer/pages/home/screen/widgets/modern_bottom_nav.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeOut),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<HomeCubit>()),
        BlocProvider(create: (context) => getIt<SubscriptionsCubit>()),
        BlocProvider(create: (context) => getIt<SupportCubit>()),
        BlocProvider(create: (context) => getIt<MaintenanceCubit>()),
      ],
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) => setState(() => _currentIndex = index),
          children: const [
            HomeTab(),
            SubscriptionsTab(),
            MaintenanceTab(),
            SupportTab(),
            SettingsTab(),
          ],
        ),
        bottomNavigationBar: ModernBottomNav(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: [
            ModernNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: t.home,
            ),
            ModernNavItem(
              icon: Icons.card_membership_outlined,
              activeIcon: Icons.card_membership_rounded,
              label: t.subscriptions,
            ),
            ModernNavItem(
              icon: Icons.build_outlined,
              activeIcon: Icons.build_rounded,
              label: 'الصيانة',
            ),
            ModernNavItem(
              icon: Icons.support_agent_outlined,
              activeIcon: Icons.support_agent_rounded,
              label: t.support,
            ),
            ModernNavItem(
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings_rounded,
              label: t.settings,
            ),
          ],
        ),
      ),
    );
  }
}
