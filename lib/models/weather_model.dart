class WeatherModel {
  final String cityName;
  final String regionName;
  final String country;
  final double latitude;
  final double longitude;
  final String tempC;
  final String feelsLikeC;
  final String humidity;
  final String weatherDesc;
  final String windSpeedKm;
  final bool isGpsSource;

  WeatherModel({
    required this.cityName,
    required this.regionName,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.tempC,
    required this.feelsLikeC,
    required this.humidity,
    required this.weatherDesc,
    required this.windSpeedKm,
    this.isGpsSource = false,
  });

  factory WeatherModel.fromWttrJson(Map<String, dynamic> json, {bool isGps = false}) {
    String city = 'Indonesia';
    String region = 'Indonesia';
    String country = 'Indonesia';
    double lat = -6.2088;
    double lon = 106.8456;

    final nearest = json['nearest_area'] as List?;
    if (nearest != null && nearest.isNotEmpty) {
      final area = nearest[0] as Map<String, dynamic>;
      final areaNames = area['areaName'] as List?;
      if (areaNames != null && areaNames.isNotEmpty) {
        city = areaNames[0]['value'] ?? city;
      }
      final regions = area['region'] as List?;
      if (regions != null && regions.isNotEmpty) {
        region = regions[0]['value'] ?? region;
      }
      final countries = area['country'] as List?;
      if (countries != null && countries.isNotEmpty) {
        country = countries[0]['value'] ?? country;
      }
      lat = double.tryParse(area['latitude']?.toString() ?? '') ?? lat;
      lon = double.tryParse(area['longitude']?.toString() ?? '') ?? lon;
    }

    String temp = '30';
    String feelsLike = '32';
    String hum = '65';
    String desc = 'Cerah Berawan';
    String wind = '10';

    final conditions = json['current_condition'] as List?;
    if (conditions != null && conditions.isNotEmpty) {
      final cond = conditions[0] as Map<String, dynamic>;
      temp = cond['temp_C']?.toString() ?? temp;
      feelsLike = cond['FeelsLikeC']?.toString() ?? feelsLike;
      hum = cond['humidity']?.toString() ?? hum;
      wind = cond['windspeedKmph']?.toString() ?? wind;

      final descs = cond['weatherDesc'] as List?;
      if (descs != null && descs.isNotEmpty) {
        desc = descs[0]['value'] ?? desc;
      }
    }

    return WeatherModel(
      cityName: city,
      regionName: region,
      country: country,
      latitude: lat,
      longitude: lon,
      tempC: temp,
      feelsLikeC: feelsLike,
      humidity: hum,
      weatherDesc: desc,
      windSpeedKm: wind,
      isGpsSource: isGps,
    );
  }

  WeatherModel copyWith({
    String? cityName,
    String? regionName,
    String? country,
    double? latitude,
    double? longitude,
    String? tempC,
    String? feelsLikeC,
    String? humidity,
    String? weatherDesc,
    String? windSpeedKm,
    bool? isGpsSource,
  }) {
    return WeatherModel(
      cityName: cityName ?? this.cityName,
      regionName: regionName ?? this.regionName,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      tempC: tempC ?? this.tempC,
      feelsLikeC: feelsLikeC ?? this.feelsLikeC,
      humidity: humidity ?? this.humidity,
      weatherDesc: weatherDesc ?? this.weatherDesc,
      windSpeedKm: windSpeedKm ?? this.windSpeedKm,
      isGpsSource: isGpsSource ?? this.isGpsSource,
    );
  }
}
