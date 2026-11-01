import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors/app_colors.dart';

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: AppColors.orange,
      labelColor: AppColors.white,
      unselectedLabelColor: AppColors.white,
      labelStyle: const TextStyle(fontSize: 13),
      tabs: [
        Tab(
          icon: Icon(Icons.list_rounded, color: AppColors.orange),
          text: 'Watch List',
        ),
        Tab(
          icon: Icon(Icons.folder_rounded, color: AppColors.orange),
          text: 'History',
        ),
      ],
    );
  }
}
