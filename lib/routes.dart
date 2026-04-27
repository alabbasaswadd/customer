import 'package:go_router/go_router.dart';
import 'package:mikrotic_customer/core/di/dependency_injection.dart';
import 'package:mikrotic_customer/pages/auth/signin/cubit/signin_cubit.dart';
import 'package:mikrotic_customer/pages/auth/signin/screen/signin_screen.dart';
import 'package:mikrotic_customer/pages/home/screen/home_navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeNavigation()),
    GoRoute(
      path: '/signin',
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<SigninCubit>(),
        child: const SigninScreen(),
      ),
    ),
    // GoRoute(
    //   path: '/speed-test',
    //   builder: (context, state) => const SpeedTestScreen(),
    // ),
  ],
);
