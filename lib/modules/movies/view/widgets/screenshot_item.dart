import 'package:flutter/material.dart';

import '../../../../core/widgets/app_image.dart';

class ScreenshotItem extends StatelessWidget {
  final String imageUrl;
  const ScreenshotItem({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 16 / 7,
        child: AppImage(url: imageUrl),
      ),
    );
  }
}
