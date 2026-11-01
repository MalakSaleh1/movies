import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors/app_colors.dart';

class ProfileActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onExit;

  const ProfileActionButtons({
    super.key,
    required this.onEdit,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.black,
                shape: shape,
              ),
              onPressed: onEdit,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.white,
                shape: shape,
              ),
              onPressed: onExit,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Exit',
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.logout, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
