import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

enum BrutalButtonVariant { mint, white, dark }

class BrutalButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final BrutalButtonVariant variant;
  final bool fullWidth;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  const BrutalButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.variant = BrutalButtonVariant.mint,
    this.fullWidth = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.fontSize = 14,
  });

  @override
  State<BrutalButton> createState() => _BrutalButtonState();
}

class _BrutalButtonState extends State<BrutalButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    final Color fgColor;
    final BoxDecoration decoration;

    switch (widget.variant) {
      case BrutalButtonVariant.mint:
        fgColor = AppColors.blackInk;
        decoration = BoxDecoration(
          gradient: AppColors.mintGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.blackInk, width: 2.5),
          boxShadow: _pressed || disabled
              ? null
              : const [
                  BoxShadow(
                    color: AppColors.blackInk,
                    offset: Offset(2.5, 2.5),
                    blurRadius: 0,
                  ),
                ],
        );
        break;
      case BrutalButtonVariant.white:
        fgColor = AppColors.blackInk;
        decoration = BoxDecoration(
          color: AppColors.whitePure,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.blackInk, width: 2.5),
          boxShadow: _pressed || disabled
              ? null
              : const [
                  BoxShadow(
                    color: AppColors.blackInk,
                    offset: Offset(2.5, 2.5),
                    blurRadius: 0,
                  ),
                ],
        );
        break;
      case BrutalButtonVariant.dark:
        fgColor = AppColors.whitePure;
        decoration = BoxDecoration(
          gradient: AppColors.darkCardGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.blackInk, width: 2.5),
          boxShadow: _pressed || disabled
              ? null
              : const [
                  BoxShadow(
                    color: AppColors.blackInk,
                    offset: Offset(2.5, 2.5),
                    blurRadius: 0,
                  ),
                ],
        );
        break;
    }

    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
      onTapCancel: disabled ? null : () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 120),
        opacity: disabled ? 0.55 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: widget.fullWidth ? double.infinity : null,
          transform: _pressed
              ? Matrix4.translationValues(1.5, 1.5, 0)
              : Matrix4.identity(),
          padding: widget.padding,
          decoration: decoration,
          child: Row(
            mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: widget.fontSize + 4, color: fgColor),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.ubuntu(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.w700,
                    color: fgColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
