import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'glass_container.dart';

class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({
    super.key,
    this.message = 'Mengambil data dari server BMKG...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GlassContainer(
          borderRadius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 46,
                height: 46,
                child: CircularProgressIndicator(
                  strokeWidth: 3.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentCyan),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Harap tunggu sejenak',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
