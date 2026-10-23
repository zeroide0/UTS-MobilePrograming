import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gempa_model.dart';
import '../models/weather_model.dart';
import '../utils/constants.dart';

class BmkgApiService {
  final http.Client client;

  BmkgApiService({http.Client? client}) : client = client ?? http.Client();

  /// Mengambil data gempa bumi terbaru (M 5.0+) secara real-time
  Future<GempaModel> fetchAutoGempa() async {
    final response = await client.get(
      Uri.parse(AppConstants.bmkgAutoGempaUrl),
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('Infogempa') && data['Infogempa']['gempa'] != null) {
        return GempaModel.fromJson(data['Infogempa']['gempa']);
      } else {
        throw Exception('Format data gempa BMKG tidak sesuai.');
      }
    } else {
      throw Exception(
        'Gagal memuat gempa terbaru (Status Code: ${response.statusCode})',
      );
    }
  }

  /// Mengambil daftar 15 gempa bumi berkekuatan M 5.0+
  Future<List<GempaModel>> fetchGempaTerkini() async {
    final response = await client.get(
      Uri.parse(AppConstants.bmkgGempaTerkiniUrl),
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('Infogempa') && data['Infogempa']['gempa'] != null) {
        final List<dynamic> list = data['Infogempa']['gempa'];
        return list.map((item) => GempaModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception(
        'Gagal memuat riwayat gempa terkini (Status Code: ${response.statusCode})',
      );
    }
  }

  /// Mengambil daftar 15 gempa bumi yang dirasakan
  Future<List<GempaModel>> fetchGempaDirasakan() async {
    final response = await client.get(
      Uri.parse(AppConstants.bmkgGempaDirasakanUrl),
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('Infogempa') && data['Infogempa']['gempa'] != null) {
        final List<dynamic> list = data['Infogempa']['gempa'];
        return list.map((item) => GempaModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception(
        'Gagal memuat daftar gempa dirasakan (Status Code: ${response.statusCode})',
      );
    }
  }

  /// Mengambil data cuaca & geolokasi IP otomatis atau dengan koordinat
  Future<WeatherModel> fetchWeatherData({
    double? latitude,
    double? longitude,
    bool isGps = false,
  }) async {
    String url = AppConstants.wttrInJsonUrl;
    if (latitude != null && longitude != null) {
      url = 'https://wttr.in/$latitude,$longitude?format=j1';
    }

    final response = await client.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return WeatherModel.fromWttrJson(data, isGps: isGps);
    } else {
      throw Exception(
        'Gagal memuat data cuaca (Status Code: ${response.statusCode})',
      );
    }
  }
}
