import 'package:flutter/material.dart';

import '../theme/app_colors/app_colors.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      cursorColor: AppColors.orange,
      textInputAction: TextInputAction.search,
      style: TextStyle(fontSize: 14, color: AppColors.white),
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: TextStyle(color: AppColors.white, fontSize: 16),
        prefixIcon: Icon(Icons.search, size: 24, color: AppColors.white),
        filled: true,
        fillColor: AppColors.darkGrey,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
