import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UserLocationResult {
  final double latitude;
  final double longitude;
  final String cityName;
  final String provinceName;
  final bool isGps;

  UserLocationResult({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.provinceName,
    required this.isGps,
  });
}

class LocationService {
  /// Attempts to get position from GPS with timeout.
  /// Returns null if GPS is disabled or permission denied.
  static Future<UserLocationResult?> getGpsLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 7),
        ),
      );

      String city = 'Lokasi GPS';
      String province = 'Indonesia';

      try {
        final geocoding = Geocoding();
        List<Placemark> placemarks = await geocoding
            .placemarkFromCoordinates(
              position.latitude,
              position.longitude,
            )
            .timeout(const Duration(seconds: 4));

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          city = place.subAdministrativeArea ?? place.locality ?? place.name ?? 'Lokasi Terdeteksi';
          province = place.administrativeArea ?? 'Indonesia';
        }
      } catch (e) {
        debugPrint('Geocoding error: $e');
      }

      return UserLocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: city,
        provinceName: province,
        isGps: true,
      );
    } catch (e) {
      debugPrint('Error getting GPS location: $e');
      return null;
    }
  }

  /// Calculates distance in kilometers between two geographic coordinates
  static double calculateDistanceKm({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    double distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    return distanceInMeters / 1000.0;
  }

  /// Helper to format distance nicely (e.g., "124 km" or "850 m")
  static String formatDistance(double km) {
    if (km < 1) {
      int meters = (km * 1000).round();
      return '$meters m';
    } else {
      return '${km.toStringAsFixed(1)} km';
    }
  }
}
