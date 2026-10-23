import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/app_colors.dart';
import 'glass_container.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final VoidCallback onRefresh;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.onRefresh,
  });

  IconData _getWeatherIcon(String desc) {
    final lower = desc.toLowerCase();
    if (lower.contains('rain') || lower.contains('hujan')) {
      return Icons.grain_rounded;
    } else if (lower.contains('cloud') || lower.contains('berawan') || lower.contains('overcast')) {
      return Icons.cloud_rounded;
    } else if (lower.contains('thunder') || lower.contains('petir')) {
      return Icons.thunderstorm_rounded;
    } else if (lower.contains('sun') || lower.contains('cerah') || lower.contains('clear')) {
      return Icons.wb_sunny_rounded;
    } else {
      return Icons.cloud_queue_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Location & Source Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      weather.isGpsSource ? Icons.gps_fixed_rounded : Icons.public_rounded,
                      color: weather.isGpsSource ? AppColors.accentEmerald : AppColors.accentCyan,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            weather.cityName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            weather.regionName,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (weather.isGpsSource ? AppColors.accentEmerald : AppColors.accentCyan)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (weather.isGpsSource ? AppColors.accentEmerald : AppColors.accentCyan)
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      weather.isGpsSource ? 'GPS Aktif' : 'IP Network (wttr.in)',
                      style: TextStyle(
                        color: weather.isGpsSource ? AppColors.accentEmerald : AppColors.accentCyan,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Main Weather Info: Temperature & Condition
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.tempC,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                    ),
                  ),
                  const Text(
                    '°C',
                    style: TextStyle(
                      color: AppColors.accentCyan,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    _getWeatherIcon(weather.weatherDesc),
                    color: AppColors.accentCyan,
                    size: 38,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weather.weatherDesc,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 14),

          // Extra details: Humidity, Wind, Feels Like
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem(
                icon: Icons.thermostat_rounded,
                label: 'Terasa',
                value: '${weather.feelsLikeC}°C',
              ),
              _buildDetailItem(
                icon: Icons.water_drop_rounded,
                label: 'Kelembapan',
                value: '${weather.humidity}%',
              ),
              _buildDetailItem(
                icon: Icons.air_rounded,
                label: 'Kecepatan Angin',
                value: '${weather.windSpeedKm} km/j',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 18),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
