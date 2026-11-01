import 'package:flutter/material.dart';

import '../theme/app_colors/app_colors.dart';
import 'app_image.dart';

/// صورة المستخدم: asset محلي أو رابط (زي صورة جوجل).
class UserAvatar extends StatelessWidget {
  final String path;
  final double size;

  const UserAvatar({super.key, required this.path, required this.size});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      color: AppColors.darkGrey,
      child: Icon(Icons.person, color: AppColors.grey, size: size * .6),
    );

    return ClipOval(
      child: path.startsWith('http')
          ? AppImage(url: path, width: size, height: size)
          : Image.asset(
              path,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => fallback,
            ),
    );
  }
}
