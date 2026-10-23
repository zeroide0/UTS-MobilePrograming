import 'dart:ui';
import 'package:flutter/material.dart';
import 'screens/gempa_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/info_screen.dart';
import 'utils/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TerraCastApp());
}

class TerraCastApp extends StatelessWidget {
  const TerraCastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TerraCast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgDarkPrimary,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accentCyan,
          secondary: AppColors.accentIndigo,
          surface: AppColors.bgDarkSecondary,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigateTab: _onTabSelected),
      const GempaListScreen(),
      const InfoScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgDarkPrimary,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgDarkPrimary,
              AppColors.bgDarkSecondary,
              AppColors.bgDarkTertiary,
            ],
          ),
        ),
        child: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: _buildGlassBottomNav(),
    );
  }

  Widget _buildGlassBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.bgDarkSecondary.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.dashboard_rounded,
                  label: 'Beranda',
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.waves_rounded,
                  label: 'Seismik',
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.info_outline_rounded,
                  label: 'Tentang',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = _currentIndex == index;
    final Color activeColor = AppColors.accentCyan;
    final Color inactiveColor = AppColors.textMuted;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTabSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: activeColor.withValues(alpha: 0.3), width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: activeColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
