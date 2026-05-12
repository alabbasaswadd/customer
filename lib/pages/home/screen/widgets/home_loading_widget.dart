import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';

class HomeLoadingWidget extends StatelessWidget {
  const HomeLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitFadingCircle(
            color: theme.colorScheme.primary,
            size: 50,
          ),
          const SizedBox(height: 20),
          const Text(
            'جاري التحميل...',
            style: TextStyle(
              color: AppColors.kGreyColor,
              fontSize: 14,
              fontFamily: 'Cairo-Bold',
            ),
          ),
        ],
      ),
    );
  }
}
