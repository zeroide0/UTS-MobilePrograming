import 'package:flutter_test/flutter_test.dart';
import 'package:terracast/models/gempa_model.dart';
import 'package:terracast/models/weather_model.dart';
import 'package:terracast/services/location_service.dart';

void main() {
  group('TerraCast Model & Service Tests', () {
    test('GempaModel parses BMKG JSON correctly', () {
      final json = {
        'Tanggal': '22 Okt 2026',
        'Jam': '17:57:49 WIB',
        'DateTime': '2026-10-22T10:57:49+00:00',
        'Coordinates': '-3.11,102.14',
        'Lintang': '3.11 LS',
        'Bujur': '102.14 BT',
        'Magnitude': '5.2',
        'Kedalaman': '120 km',
        'Wilayah': 'Pusat gempa berada di darat 6 km BaratLaut Lebong',
        'Potensi': 'Tidak berpotensi tsunami',
        'Dirasakan': 'III Kota Bengkulu',
        'Shakemap': '20261022175749.mmi.jpg'
      };

      final model = GempaModel.fromJson(json);

      expect(model.tanggal, '22 Okt 2026');
      expect(model.jam, '17:57:49 WIB');
      expect(model.magnitude, '5.2');
      expect(model.magnitudeValue, 5.2);
      expect(model.latitude, -3.11);
      expect(model.longitude, 102.14);
      expect(model.wilayah, contains('Lebong'));
      expect(model.potensi, 'Tidak berpotensi tsunami');
      expect(model.shakemapUrl, contains('20261022175749.mmi.jpg'));
    });

    test('WeatherModel parses wttr.in JSON fallback correctly', () {
      final json = {
        'nearest_area': [
          {
            'areaName': [{'value': 'Jakarta'}],
            'region': [{'value': 'Jakarta Raya'}],
            'country': [{'value': 'Indonesia'}],
            'latitude': '-6.215',
            'longitude': '106.845'
          }
        ],
        'current_condition': [
          {
            'temp_C': '31',
            'FeelsLikeC': '34',
            'humidity': '58',
            'weatherDesc': [{'value': 'Partly cloudy'}],
            'windspeedKmph': '11'
          }
        ]
      };

      final model = WeatherModel.fromWttrJson(json, isGps: false);

      expect(model.cityName, 'Jakarta');
      expect(model.regionName, 'Jakarta Raya');
      expect(model.tempC, '31');
      expect(model.humidity, '58');
      expect(model.weatherDesc, 'Partly cloudy');
      expect(model.isGpsSource, isFalse);
    });

    test('LocationService calculates distance correctly', () {
      // Jakarta (-6.2088, 106.8456) to Bandung (-6.9175, 107.6191) is approximately 115-150 km
      final distanceKm = LocationService.calculateDistanceKm(
        startLatitude: -6.2088,
        startLongitude: 106.8456,
        endLatitude: -6.9175,
        endLongitude: 107.6191,
      );

      expect(distanceKm, greaterThan(100.0));
      expect(distanceKm, lessThan(160.0));

      final formatted = LocationService.formatDistance(distanceKm);
      expect(formatted, contains('km'));
    });
  });
}
