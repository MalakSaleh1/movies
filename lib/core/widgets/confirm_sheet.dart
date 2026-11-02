import 'package:flutter/material.dart';

import '../theme/app_colors/app_colors.dart';

class ConfirmSheet extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String message;
  final String confirmLabel;
  final Color? confirmColor;
  final Widget? extra;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmSheet({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    required this.onCancel,
    this.iconColor,
    this.confirmColor,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final accent = confirmColor ?? AppColors.red;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: iconColor ?? accent),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.white),
            ),
            if (extra != null) ...[
              const SizedBox(height: 16),
              extra!,
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: AppColors.white,
                    ),
                    onPressed: onConfirm,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(confirmLabel),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> showConfirmSheet(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String message,
  required String confirmLabel,
  Color? confirmColor,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => ConfirmSheet(
      icon: icon,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      confirmColor: confirmColor,
      onConfirm: () => Navigator.pop(sheetContext, true),
      onCancel: () => Navigator.pop(sheetContext, false),
    ),
  );
  return result == true;
}
