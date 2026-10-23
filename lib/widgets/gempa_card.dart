import 'package:flutter/material.dart';
import '../models/gempa_model.dart';
import '../utils/app_colors.dart';
import 'glass_container.dart';

class GempaCard extends StatelessWidget {
  final GempaModel gempa;
  final double? userLatitude;
  final double? userLongitude;
  final double? distanceKm;
  final VoidCallback onTap;

  const GempaCard({
    super.key,
    required this.gempa,
    this.userLatitude,
    this.userLongitude,
    this.distanceKm,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final magColor = AppColors.getMagnitudeColor(gempa.magnitudeValue);

    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 14),
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Magnitude Badge
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: magColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: magColor.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      gempa.magnitude,
                      style: TextStyle(
                        color: magColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'SR',
                      style: TextStyle(
                        color: magColor.withValues(alpha: 0.8),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Title / Wilayah & Waktu
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gempa.wilayah,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${gempa.tanggal} • ${gempa.jam}',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 10),

          // Bottom Info Row: Kedalaman, Koordinat, Jarak Pengguna
          Row(
            children: [
              _buildBadge(
                icon: Icons.compress_rounded,
                text: 'Kedalaman: ${gempa.kedalaman}',
              ),
              const SizedBox(width: 8),
              if (distanceKm != null)
                _buildBadge(
                  icon: Icons.near_me_rounded,
                  text: '${distanceKm!.toStringAsFixed(0)} km dari Anda',
                  accent: AppColors.accentCyan,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String text,
    Color? accent,
  }) {
    final color = accent ?? AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
