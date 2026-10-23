class AppConstants {
  static const String appName = 'TerraCast';
  static const String appTagline = 'BMKG Nature & Seismic Monitoring';

  // BMKG Endpoints
  static const String bmkgBaseUrl = 'https://data.bmkg.go.id/DataMKG/TEWS/';
  static const String bmkgAutoGempaUrl = '${bmkgBaseUrl}autogempa.json';
  static const String bmkgGempaTerkiniUrl = '${bmkgBaseUrl}gempaterkini.json';
  static const String bmkgGempaDirasakanUrl = '${bmkgBaseUrl}gempadirasakan.json';

  // Fallback Geolocation & Weather
  static const String wttrInJsonUrl = 'https://wttr.in/?format=j1';
}
