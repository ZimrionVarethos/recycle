import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class AppLogoBadge extends StatelessWidget {
  final double width;
  final double height;
  final double borderWidth;

  const AppLogoBadge({
    super.key,
    this.width = 62,
    this.height = 46,
    this.borderWidth = 3.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: AppColors.mintGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.blackInk, width: borderWidth),
        boxShadow: const [
          BoxShadow(
            color: AppColors.blackInk,
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/logo_bottles.webp',
        fit: BoxFit.contain,
      ),
    );
  }
}
