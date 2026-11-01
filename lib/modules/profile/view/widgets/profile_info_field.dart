import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors/app_colors.dart';

class ProfileInfoField extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const ProfileInfoField({
    super.key,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 16, color: AppColors.white),
      cursorColor: AppColors.orange,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 24, color: AppColors.white),
        filled: true,
        fillColor: AppColors.darkGrey,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
