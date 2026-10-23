import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/glass_container.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          children: [
            // Title
            const Text(
              'Tentang Aplikasi',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Informasi Proyek Ujian Tengah Semester (UTS)',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),

            // App Identity Glass Card
            GlassContainer(
              borderRadius: 24,
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accentCyan, AppColors.accentIndigo],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentCyan.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.radar_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'TerraCast',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Nature & Seismic Monitoring System',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentIndigo.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.accentIndigo.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Text(
                      'UTS Pemrograman Mobile • Kelas C',
                      style: TextStyle(
                        color: AppColors.accentIndigo,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Fitur & Arsitektur
            GlassContainer(
              borderRadius: 22,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fitur & Karakteristik Utama',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureRow(
                    icon: Icons.api_rounded,
                    title: 'Integrasi BMKG Open Data',
                    desc: 'Realtime Auto Gempa M 5.0+, Riwayat 15 Gempa, & Gempa Dirasakan.',
                  ),
                  _buildFeatureRow(
                    icon: Icons.sync_rounded,
                    title: 'Asynchronous Programming',
                    desc: 'Implementasi FutureBuilder lengkap dengan state Loading, Success, dan Error.',
                  ),
                  _buildFeatureRow(
                    icon: Icons.my_location_rounded,
                    title: 'Geolokasi & Hitung Jarak Episentrum',
                    desc: 'Menghitung estimasi jarak posisi pengguna ke pusat gempa secara otomatis.',
                  ),
                  _buildFeatureRow(
                    icon: Icons.cloud_done_rounded,
                    title: 'Fallback Cerdas IP (wttr.in)',
                    desc: 'Jika GPS dimatikan, aplikasi mendeteksi kota & cuaca pengguna via IP tanpa crash.',
                  ),
                  _buildFeatureRow(
                    icon: Icons.blur_on_rounded,
                    title: 'Desain Clean Glassmorphism',
                    desc: 'Antarmuka frosted glass modern dengan BackdropFilter & palet warna harmonis.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Sumber Data & API
            GlassContainer(
              borderRadius: 22,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sumber Data (API Endpoints)',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildApiRow('BMKG TEWS Auto Gempa', 'https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json'),
                  _buildApiRow('BMKG Riwayat Gempa', 'https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json'),
                  _buildApiRow('BMKG Gempa Dirasakan', 'https://data.bmkg.go.id/DataMKG/TEWS/gempadirasakan.json'),
                  _buildApiRow('wttr.in Fallback Weather', 'https://wttr.in/?format=j1'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.accentCyan, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiRow(String title, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            url,
            style: const TextStyle(
              color: AppColors.accentCyan,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
