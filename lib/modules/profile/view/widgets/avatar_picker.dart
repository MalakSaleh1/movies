import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors/app_colors.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../data/app_avatars.dart';

class AvatarPickerSheet extends StatelessWidget {
  final String selected;
  const AvatarPickerSheet({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          borderRadius: BorderRadius.circular(24),
        ),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: AppAvatars.all.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.03,
          ),
          itemBuilder: (_, i) {
            final avatar = AppAvatars.all[i];
            final isSelected = avatar == selected;

            return GestureDetector(
              onTap: () => Navigator.pop(context, avatar),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.orange.withOpacity(.6)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.orange),
                ),
                child: FittedBox(
                  child: UserAvatar(path: avatar, size: 80),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
