import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors/app_colors.dart';
import '../../../../core/widgets/app_image.dart';

class MovieHeader extends StatelessWidget {
  final String imageUrl;
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;

  const MovieHeader({
    super.key,
    required this.imageUrl,
    required this.isBookmarked,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 430,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppImage(url: imageUrl),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppColors.black],
                stops: const [0.5, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 30,
                      color: AppColors.white,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      size: 30,
                      color: isBookmarked ? AppColors.orange : AppColors.white,
                    ),
                    onPressed: onBookmarkTap,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.orange, width: 4),
                color: Colors.black45,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: AppColors.orange,
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
