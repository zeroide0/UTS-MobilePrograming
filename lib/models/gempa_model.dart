import '../utils/constants.dart';

class GempaModel {
  final String tanggal;
  final String jam;
  final String? dateTime;
  final String coordinates;
  final String lintang;
  final String bujur;
  final String magnitude;
  final String kedalaman;
  final String wilayah;
  final String potensi;
  final String? dirasakan;
  final String? shakemap;

  GempaModel({
    required this.tanggal,
    required this.jam,
    this.dateTime,
    required this.coordinates,
    required this.lintang,
    required this.bujur,
    required this.magnitude,
    required this.kedalaman,
    required this.wilayah,
    required this.potensi,
    this.dirasakan,
    this.shakemap,
  });

  factory GempaModel.fromJson(Map<String, dynamic> json) {
    return GempaModel(
      tanggal: json['Tanggal'] ?? '-',
      jam: json['Jam'] ?? '-',
      dateTime: json['DateTime'],
      coordinates: json['Coordinates'] ?? '0,0',
      lintang: json['Lintang'] ?? '-',
      bujur: json['Bujur'] ?? '-',
      magnitude: json['Magnitude']?.toString() ?? '0.0',
      kedalaman: json['Kedalaman'] ?? '-',
      wilayah: json['Wilayah'] ?? '-',
      potensi: json['Potensi'] ?? 'Tidak ada data potensi',
      dirasakan: json['Dirasakan'],
      shakemap: json['Shakemap'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Tanggal': tanggal,
      'Jam': jam,
      'DateTime': dateTime,
      'Coordinates': coordinates,
      'Lintang': lintang,
      'Bujur': bujur,
      'Magnitude': magnitude,
      'Kedalaman': kedalaman,
      'Wilayah': wilayah,
      'Potensi': potensi,
      'Dirasakan': dirasakan,
      'Shakemap': shakemap,
    };
  }

  double get magnitudeValue {
    return double.tryParse(magnitude) ?? 0.0;
  }

  double? get latitude {
    final parts = coordinates.split(',');
    if (parts.isNotEmpty) {
      return double.tryParse(parts[0].trim());
    }
    return null;
  }

  double? get longitude {
    final parts = coordinates.split(',');
    if (parts.length > 1) {
      return double.tryParse(parts[1].trim());
    }
    return null;
  }

  String? get shakemapUrl {
    if (shakemap != null && shakemap!.trim().isNotEmpty) {
      return '${AppConstants.bmkgBaseUrl}$shakemap';
    }
    return null;
  }
}
