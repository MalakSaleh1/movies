import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double radius;
  final double fontSize;

  const AppButton({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onPressed,
    this.isLoading = false,
    this.height = 52,
    this.radius = 16,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          disabledBackgroundColor: color.withOpacity(.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
