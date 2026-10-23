import 'package:flutter/material.dart';
import '../models/gempa_model.dart';
import '../models/weather_model.dart';
import '../services/bmkg_service.dart';
import '../services/location_service.dart';
import '../utils/app_colors.dart';
import '../widgets/error_view.dart';
import '../widgets/glass_container.dart';
import '../widgets/loading_view.dart';
import '../widgets/weather_card.dart';
import 'detail_gempa_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int tabIndex)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BmkgApiService _apiService = BmkgApiService();

  late Future<GempaModel> _futureAutoGempa;
  late Future<WeatherModel> _futureWeather;

  double? _userLatitude;
  double? _userLongitude;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  void _loadAllData() {
    setState(() {
      _futureAutoGempa = _apiService.fetchAutoGempa();
      _futureWeather = _fetchLocationAndWeather();
    });
  }

  /// Handles GPS location detection with automatic fallback to wttr.in IP geolocation
  Future<WeatherModel> _fetchLocationAndWeather() async {
    final gpsResult = await LocationService.getGpsLocation();

    if (gpsResult != null) {
      _userLatitude = gpsResult.latitude;
      _userLongitude = gpsResult.longitude;

      try {
        final weather = await _apiService.fetchWeatherData(
          latitude: gpsResult.latitude,
          longitude: gpsResult.longitude,
          isGps: true,
        );

        return weather.copyWith(
          cityName: gpsResult.cityName,
          regionName: gpsResult.provinceName,
          isGpsSource: true,
        );
      } catch (e) {
        debugPrint('Fallback to IP weather after GPS error: $e');
      }
    }

    // Fallback: Query wttr.in directly via IP network
    final ipWeather = await _apiService.fetchWeatherData(isGps: false);
    _userLatitude = ipWeather.latitude;
    _userLongitude = ipWeather.longitude;
    return ipWeather;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _loadAllData(),
          color: AppColors.accentCyan,
          backgroundColor: AppColors.bgDarkSecondary,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            children: [
              // Header: App Logo & Tag
              _buildHeader(),
              const SizedBox(height: 20),

              // Weather & Location Section (with FutureBuilder)
              _buildWeatherSection(),
              const SizedBox(height: 24),

              // Hero: Gempa Terkini Realtime (with FutureBuilder)
              _buildHeroGempaSection(),
              const SizedBox(height: 24),

              // Quick Access Grid
              _buildQuickShortcuts(),
              const SizedBox(height: 24),

              // Emergency Information Card
              _buildEmergencyCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accentCyan, AppColors.accentIndigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.radar_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TerraCast',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Monitoring Alam & BMKG',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentRose.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accentRose.withValues(alpha: 0.3),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.fiber_manual_record, color: AppColors.accentRose, size: 10),
              SizedBox(width: 6),
              Text(
                'LIVE FEED',
                style: TextStyle(
                  color: AppColors.accentRose,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherSection() {
    return FutureBuilder<WeatherModel>(
      future: _futureWeather,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView(
            message: 'Mendeteksi lokasi & data cuaca...',
          );
        }

        if (snapshot.hasError) {
          return ErrorView(
            errorMessage: 'Gagal mengambil data cuaca: ${snapshot.error}',
            onRetry: _loadAllData,
          );
        }

        if (snapshot.hasData) {
          return WeatherCard(
            weather: snapshot.data!,
            onRefresh: _loadAllData,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeroGempaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gempa Bumi Terkini (Realtime)',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'BMKG TEWS',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FutureBuilder<GempaModel>(
          future: _futureAutoGempa,
          builder: (context, snapshot) {
            // 1. Loading State
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingView(
                message: 'Menghubungkan ke sensor seismik BMKG...',
              );
            }

            // 2. Error State
            if (snapshot.hasError) {
              return ErrorView(
                errorMessage: 'Gagal memuat gempa terkini: ${snapshot.error}',
                onRetry: _loadAllData,
              );
            }

            // 3. Success State
            if (snapshot.hasData) {
              final gempa = snapshot.data!;
              final magColor = AppColors.getMagnitudeColor(gempa.magnitudeValue);

              double? distanceKm;
              if (_userLatitude != null &&
                  _userLongitude != null &&
                  gempa.latitude != null &&
                  gempa.longitude != null) {
                distanceKm = LocationService.calculateDistanceKm(
                  startLatitude: _userLatitude!,
                  startLongitude: _userLongitude!,
                  endLatitude: gempa.latitude!,
                  endLongitude: gempa.longitude!,
                );
              }

              return GlassContainer(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailGempaScreen(
                        gempa: gempa,
                        userLatitude: _userLatitude,
                        userLongitude: _userLongitude,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Badge Magnitudo & Jam
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: magColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: magColor.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${gempa.magnitude} SR',
                                style: TextStyle(
                                  color: magColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${gempa.tanggal} • ${gempa.jam}',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Wilayah Text
                    Text(
                      gempa.wilayah,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Potensi Gempa
                    Text(
                      gempa.potensi,
                      style: TextStyle(
                        color: gempa.potensi.toLowerCase().contains('tidak')
                            ? AppColors.accentEmerald
                            : AppColors.accentRose,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
                          color: AppColors.accentCyan.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.accentCyan.withValues(alpha: 0.25),
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
                                'Jarak ke pusat gempa: ~${LocationService.formatDistance(distanceKm)}',
                                style: const TextStyle(
                                  color: AppColors.accentCyan,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),
                    const Divider(color: Colors.white10, height: 1),
                    const SizedBox(height: 12),

                    // View Detail Link
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Buka detail & shakemap lengkap',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.accentCyan,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildQuickShortcuts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Akses Cepat Data',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GlassContainer(
                borderRadius: 20,
                padding: const EdgeInsets.all(16),
                onTap: () {
                  if (widget.onNavigateTab != null) {
                    widget.onNavigateTab!(1);
                  }
                },
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.waves_rounded,
                      color: AppColors.accentRose,
                      size: 26,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Gempa M 5.0+',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '15 gempa terbaru',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlassContainer(
                borderRadius: 20,
                padding: const EdgeInsets.all(16),
                onTap: () {
                  if (widget.onNavigateTab != null) {
                    widget.onNavigateTab!(1);
                  }
                },
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.sensors_rounded,
                      color: AppColors.accentAmber,
                      size: 26,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Gempa Dirasakan',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Skala intensitas MMI',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmergencyCard() {
    return GlassContainer(
      borderRadius: 22,
      padding: const EdgeInsets.all(18),
      backgroundColor: Colors.white.withValues(alpha: 0.04),
      borderColor: Colors.white.withValues(alpha: 0.1),
      child: const Row(
        children: [
          Icon(
            Icons.support_agent_rounded,
            color: AppColors.accentCyan,
            size: 30,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pusat Tanggap Darurat Bencana',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'BNPB: 117 | BMKG: 196 | SAR: 115',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
