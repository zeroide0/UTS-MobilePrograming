import 'package:flutter/material.dart';
import '../models/gempa_model.dart';
import '../services/bmkg_service.dart';
import '../services/location_service.dart';
import '../utils/app_colors.dart';
import '../widgets/error_view.dart';
import '../widgets/gempa_card.dart';
import '../widgets/loading_view.dart';
import 'detail_gempa_screen.dart';

class GempaListScreen extends StatefulWidget {
  final double? userLatitude;
  final double? userLongitude;

  const GempaListScreen({
    super.key,
    this.userLatitude,
    this.userLongitude,
  });

  @override
  State<GempaListScreen> createState() => _GempaListScreenState();
}

class _GempaListScreenState extends State<GempaListScreen>
    with SingleTickerProviderStateMixin {
  final BmkgApiService _apiService = BmkgApiService();
  late TabController _tabController;

  late Future<List<GempaModel>> _futureGempaTerkini;
  late Future<List<GempaModel>> _futureGempaDirasakan;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    setState(() {
      _futureGempaTerkini = _apiService.fetchGempaTerkini();
      _futureGempaDirasakan = _apiService.fetchGempaDirasakan();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aktivitas Seismik',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Data Realtime dari BMKG Indonesia',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _loadData,
                    icon: const Icon(Icons.refresh_rounded, color: AppColors.accentCyan),
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
                ],
              ),
            ),

            // Tab Bar Glass Style
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: AppColors.accentIndigo.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accentIndigo.withValues(alpha: 0.8),
                    width: 1,
                  ),
                ),
                labelColor: AppColors.textPrimary,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                tabs: const [
                  Tab(text: 'Gempa M 5.0+'),
                  Tab(text: 'Gempa Dirasakan'),
                ],
              ),
            ),

            // Tab Views with FutureBuilder
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGempaListTab(_futureGempaTerkini),
                  _buildGempaListTab(_futureGempaDirasakan),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGempaListTab(Future<List<GempaModel>> futureData) {
    return FutureBuilder<List<GempaModel>>(
      future: futureData,
      builder: (context, snapshot) {
        // 1. Kondisi Loading (Sesuai Ketentuan Tugas 1.2)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView(
            message: 'Memuat riwayat gempa BMKG...',
          );
        }

        // 2. Kondisi Error (Sesuai Ketentuan Tugas 1.2)
        if (snapshot.hasError) {
          return ErrorView(
            errorMessage: snapshot.error.toString(),
            onRetry: _loadData,
          );
        }

        // 3. Kondisi Success (Sesuai Ketentuan Tugas 1.2)
        if (snapshot.hasData) {
          final gempaList = snapshot.data!;
          if (gempaList.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada data gempa yang tersedia saat ini.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadData(),
            color: AppColors.accentCyan,
            backgroundColor: AppColors.bgDarkSecondary,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              itemCount: gempaList.length,
              itemBuilder: (context, index) {
                final gempa = gempaList[index];

                double? distanceKm;
                if (widget.userLatitude != null &&
                    widget.userLongitude != null &&
                    gempa.latitude != null &&
                    gempa.longitude != null) {
                  distanceKm = LocationService.calculateDistanceKm(
                    startLatitude: widget.userLatitude!,
                    startLongitude: widget.userLongitude!,
                    endLatitude: gempa.latitude!,
                    endLongitude: gempa.longitude!,
                  );
                }

                return GempaCard(
                  gempa: gempa,
                  userLatitude: widget.userLatitude,
                  userLongitude: widget.userLongitude,
                  distanceKm: distanceKm,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailGempaScreen(
                          gempa: gempa,
                          userLatitude: widget.userLatitude,
                          userLongitude: widget.userLongitude,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        }

        return const Center(
          child: Text(
            'Tidak ada data.',
            style: TextStyle(color: AppColors.textMuted),
          ),
        );
      },
    );
  }
}
