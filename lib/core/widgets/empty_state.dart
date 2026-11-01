import 'package:flutter/material.dart';

import '../theme/app_colors/app_colors.dart';

class EmptyState extends StatelessWidget {
  final String? message;
  const EmptyState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/loading/loading.png"),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!, style: TextStyle(color: AppColors.grey)),
          ],
        ],
      ),
    );
  }
}
