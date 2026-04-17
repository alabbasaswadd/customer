import 'package:go_router/go_router.dart';
import 'package:mikrotic_customer/pages/auth/signin/screen/signin_screen.dart';
import 'package:mikrotic_customer/pages/speed_test/screen/speed_test_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SpeedTestScreen()),
    // GoRoute(
    //   path: '/signin',
    //   builder: (context, state) => const SigninScreen(),
    // ),
    GoRoute(
      path: '/speed-test',
      builder: (context, state) => const SpeedTestScreen(),
    ),
  ],
);
