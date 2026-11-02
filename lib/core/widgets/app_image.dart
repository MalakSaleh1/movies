import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors/app_colors.dart';

class AppImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  Widget _fallback() => Container(
        width: width,
        height: height,
        color: AppColors.darkGrey,
        child: Icon(Icons.broken_image, color: AppColors.grey),
      );

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _fallback();

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (_, __) => Container(
        width: width,
        height: height,
        color: AppColors.darkGrey,
      ),
      errorWidget: (_, __, ___) => _fallback(),
    );
  }
}
