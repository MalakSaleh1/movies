import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors/app_colors.dart';
import '../../data/models/movie.dart';
import 'stat_chip.dart';

class MovieStatsRow extends StatelessWidget {
  final Movie movie;
  const MovieStatsRow({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatChip(
            icon: Icons.favorite,
            iconColor: AppColors.orange,
            value: '${movie.likeCount}',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatChip(
            icon: Icons.access_time_filled,
            iconColor: AppColors.orange,
            value: '${movie.runtime}',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatChip(
            icon: Icons.star,
            iconColor: AppColors.orange,
            value: '${movie.rating}',
          ),
        ),
      ],
    );
  }
}
