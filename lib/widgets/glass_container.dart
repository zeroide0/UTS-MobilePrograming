import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.blur = 12,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.glassBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppColors.glassBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            spreadRadius: -4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    Widget glass = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: content,
      ),
    );

    if (onTap != null) {
      return Container(
        margin: margin,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: glass,
          ),
        ),
      );
    }

    return Container(
      margin: margin,
      child: glass,
    );
  }
}
