import 'package:flutter/material.dart';
import '../models/gempa_model.dart';
import '../services/location_service.dart';
import '../utils/app_colors.dart';
import '../widgets/glass_container.dart';

class DetailGempaScreen extends StatelessWidget {
  final GempaModel gempa;
  final double? userLatitude;
  final double? userLongitude;

  const DetailGempaScreen({
    super.key,
    required this.gempa,
    this.userLatitude,
    this.userLongitude,
  });

  @override
  Widget build(BuildContext context) {
    final magColor = AppColors.getMagnitudeColor(gempa.magnitudeValue);

    double? distanceKm;
    if (userLatitude != null &&
        userLongitude != null &&
        gempa.latitude != null &&
        gempa.longitude != null) {
      distanceKm = LocationService.calculateDistanceKm(
        startLatitude: userLatitude!,
        startLongitude: userLongitude!,
        endLatitude: gempa.latitude!,
        endLongitude: gempa.longitude!,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgDarkPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgDarkPrimary,
              AppColors.bgDarkSecondary,
              AppColors.bgDarkTertiary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Glass App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Detail Gempa Bumi',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Details
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    // Hero Card: Magnitude & Wilayah
                    GlassContainer(
                      borderRadius: 24,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: magColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: magColor.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Text(
                                  'Magnitudo ${gempa.magnitude} SR',
                                  style: TextStyle(
                                    color: magColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 13,
                                    color: AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    gempa.jam,
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            gempa.wilayah,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            gempa.tanggal,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          if (distanceKm != null) ...[
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentCyan.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.accentCyan.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.near_me_rounded,
                                    color: AppColors.accentCyan,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Jarak dari posisi Anda: ~${LocationService.formatDistance(distanceKm)}',
                                      style: const TextStyle(
                                        color: AppColors.accentCyan,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Grid parameter gempa
                    Row(
                      children: [
                        Expanded(
                          child: _buildParameterTile(
                            icon: Icons.compress_rounded,
                            label: 'Kedalaman',
                            value: gempa.kedalaman,
                            accent: AppColors.accentIndigo,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildParameterTile(
                            icon: Icons.explore_rounded,
                            label: 'Koordinat',
                            value: '${gempa.lintang}\n${gempa.bujur}',
                            accent: AppColors.accentCyan,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Potensi Tsunami Card
                    GlassContainer(
                      borderRadius: 20,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: gempa.potensi.toLowerCase().contains('tsunami') &&
                                    !gempa.potensi.toLowerCase().contains('tidak')
                                ? AppColors.accentRose
                                : AppColors.accentEmerald,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Status Potensi',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  gempa.potensi,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Wilayah Dirasakan (jika ada)
                    if (gempa.dirasakan != null && gempa.dirasakan!.trim().isNotEmpty) ...[
                      const SizedBox(height: 16),
                      GlassContainer(
                        borderRadius: 20,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.sensors_rounded,
                                  color: AppColors.accentAmber,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Skala Dirasakan (MMI)',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              gempa.dirasakan!,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Shakemap BMKG Image (jika tersedia)
                    if (gempa.shakemapUrl != null) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Peta Guncangan (BMKG Shakemap)',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.glassBorder,
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.network(
                            gempa.shakemapUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                height: 220,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: AppColors.accentCyan,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 120,
                                color: Colors.white.withValues(alpha: 0.05),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Peta shakemap tidak tersedia.',
                                  style: TextStyle(color: AppColors.textMuted),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Panduan Mitigasi
                    GlassContainer(
                      borderRadius: 20,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.health_and_safety_rounded,
                                color: AppColors.accentEmerald,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Pedoman Keselamatan BMKG',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildSafetyTip('1. Lindungi kepala dan berlindung di bawah meja yang kokoh.'),
                          _buildSafetyTip('2. Jauhi jendela kaca, cermin, dan benda gantung yang dapat jatuh.'),
                          _buildSafetyTip('3. Jika berada di luar ruangan, jauhi gedung, tiang listrik, dan tebing.'),
                          _buildSafetyTip('4. Pantau terus informasi resmi hanya dari BMKG.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParameterTile({
    required IconData icon,
    required String label,
    required String value,
    required Color accent,
  }) {
    return GlassContainer(
      borderRadius: 18,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        tip,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          height: 1.4,
        ),
      ),
    );
  }
}
