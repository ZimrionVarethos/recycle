import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class BrutalCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool isDark;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double radius;

  const BrutalCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.isDark = false,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = isDark
        ? BoxDecoration(
            gradient: AppColors.darkCardGradient,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: borderColor ?? AppColors.whitePure,
              width: 2.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.blackInk,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          )
        : AppTheme.brutalCard(
            color: backgroundColor ?? AppColors.whitePure,
            borderColor: borderColor ?? AppColors.blackInk,
            radius: radius,
          );

    final content = Container(
      decoration: decoration,
      padding: padding,
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: content,
      ),
    );
  }
}
