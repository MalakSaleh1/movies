import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors/app_colors.dart';
import '../../../../core/widgets/app_image.dart';
import '../../data/models/cast_member.dart';

class CastCard extends StatelessWidget {
  final CastMember member;

  const CastCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 20, fontWeight: FontWeight.w400);
    final textStyle = style.copyWith(color: AppColors.white);

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: AppImage(url: member.image, width: 70, height: 70),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name : ${member.name}', style: textStyle),
                const SizedBox(height: 2),
                Text('Character : ${member.character}', style: textStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
