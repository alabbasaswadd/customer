import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mikrotic_customer/core/constants/images.dart';
import 'package:mikrotic_customer/pages/startup/cubit/startup_cubit.dart';
import 'package:mikrotic_customer/pages/startup/cubit/startup_state.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StartupCubit>().isLogin();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartupCubit, StartupState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (destination) {
            switch (destination as StartupDestination) {
              case StartupDestination.home:
                context.go('/home');
              case StartupDestination.signin:
                context.go('/signin');
              case StartupDestination.onboarding:
                context.go('/onboarding');
            }
          },
        );
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.klogo, width: 120, height: 120),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
