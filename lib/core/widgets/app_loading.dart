import 'package:flutter/material.dart';

import '../theme/app_colors/app_colors.dart';

class AppLoading extends StatelessWidget {
  final double strokeWidth;
  const AppLoading({super.key, this.strokeWidth = 4});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.orange,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
