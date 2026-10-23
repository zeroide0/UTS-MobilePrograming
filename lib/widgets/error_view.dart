import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'glass_container.dart';

class ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GlassContainer(
          borderRadius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.accentRose.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accentRose.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  color: AppColors.accentRose,
                  size: 30,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Terjadi Kesalahan',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18, color: Colors.white),
                label: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentCyan.withValues(alpha: 0.8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
