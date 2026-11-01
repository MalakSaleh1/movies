import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors/app_colors.dart';
import '../../../../core/widgets/user_avatar.dart';
import 'profile_stat.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String avatar;
  final int wishlistCount;
  final int historyCount;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.avatar,
    required this.wishlistCount,
    required this.historyCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              UserAvatar(path: avatar, size: 118),
              const SizedBox(height: 16),
              Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ProfileStat(count: wishlistCount, label: 'Wish List'),
                  ProfileStat(count: historyCount, label: 'History'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
