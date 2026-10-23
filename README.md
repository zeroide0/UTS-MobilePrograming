# TerraCast 🌍⚡
> **Nature & Seismic Monitoring System**  
> Proyek Ujian Tengah Semester (UTS) — Matakuliah Pemrograman Mobile (Kelas C)

---

## 📌 Deskripsi Singkat Aplikasi
**TerraCast** adalah aplikasi mobile berbasis Flutter dan Dart yang dirancang untuk memantau aktivitas seismik (gempa bumi) dan kondisi cuaca di Indonesia secara *real-time*. 

Aplikasi ini mengonsumsi data terbuka (*Open Data*) resmi dari **Badan Meteorologi, Klimatologi, dan Geofisika (BMKG)** serta mengintegrasikan sistem **Geolokasi Cerdas**. Dengan fitur geolokasi, aplikasi dapat menampilkan perkiraan jarak antara lokasi pengguna saat ini dengan episentrum (pusat) gempa bumi, serta cuaca lokal pengguna. Jika pengguna menonaktifkan GPS perangkat, aplikasi secara otomatis melakukan *fallback* menggunakan geolokasi berbasis IP network melalui layanan **wttr.in** sehingga tidak pernah mengalami crash atau kegagalan pemuatan data.

Antarmuka dirancang dengan gaya **Clean Glassmorphism** modern menggunakan efek *frosted glass* (`BackdropFilter`) dan palet warna kontras yang estetik.

---

## 🌟 Fitur Utama
1. **Realtime Gempa Terkini (Auto Gempa M 5.0+)**:
   - Menampilkan data gempa bumi terbaru secara langsung dari BMKG TEWS.
   - Dilengkapi badge tingkat magnitudo dengan indikator warna (*Safe, Warning, Danger*).
   - Menampilkan peta guncangan resmi (*BMKG Shakemap*).
   - Deteksi potensi bahaya tsunami dan wilayah yang terdampak.
2. **Kalkulasi Jarak Episentrum Otomatis**:
   - Menghitung jarak presisi (km) antara koordinat pengguna saat ini dengan pusat gempa.
3. **Prakiraan Cuaca Lokal & Dual-Mode Geolocation**:
   - **Mode GPS**: Membaca GPS perangkat via package `geolocator` dan menerjemahkan kota/kabupaten via `geocoding`.
   - **Mode Fallback IP (wttr.in)**: Jika GPS mati/ditolak, cuaca dan koordinat terdeteksi otomatis via IP tanpa izin tambahan.
4. **Riwayat Gempa Lengkap (Tab Seismik)**:
   - Tab 1: Daftar 15 gempa bumi berkekuatan M 5.0+.
   - Tab 2: Daftar 15 gempa bumi yang dirasakan oleh masyarakat (skala MMI).
5. **Penanganan Asynchronous Programming (3 Kondisi)**:
   - **Loading State**: Tampilan animasi pemuatan data yang elegan (*Glass Loader*).
   - **Success State**: Penyajian data interaktif dengan list view dan gesture navigasi.
   - **Error State**: Tampilan kegagalan jaringan ramah pengguna dengan tombol *Coba Lagi* (*Retry*).
6. **Halaman Detail Interaktif**:
   - Memuat informasi mendalam, visualisasi shakemap beresolusi tinggi, parameter kedalaman, koordinat lintang/bujur, dan panduan mitigasi keselamatan gempa bumi.

---

## 🛠️ Teknologi dan Package yang Digunakan

| Komponen / Package | Versi | Fungsi / Alasan Penggunaan |
| :--- | :--- | :--- |
| **Flutter SDK** | `^3.47.3` | Framework utama pengembangan antarmuka mobile multiplatform |
| **Dart SDK** | `^3.13.3` | Bahasa pemrograman aplikasi |
| **`http`** | `^1.6.0` | Melakukan permintaan HTTP GET ke REST API BMKG dan wttr.in |
| **`geolocator`** | `^14.1.2` | Mengambil koordinat GPS pengguna dan menghitung jarak ke titik gempa |
| **`geocoding`** | `^5.0.0` | Melakukan *reverse geocoding* koordinat GPS menjadi nama kota/wilayah |
| **`intl`** | `^0.20.3` | Format tanggal, waktu, dan penomoran |
| **`cupertino_icons`** | `^1.0.8` | Ikon pelengkap sistem iOS dan Android |

---

## 📂 Struktur Proyek
```text
terracast/
├── android/
│   └── app/src/main/AndroidManifest.xml   # Izin INTERNET & ACCESS_FINE_LOCATION
├── lib/
│   ├── models/
│   │   ├── gempa_model.dart               # Model Dart & parser JSON Gempa BMKG
│   │   └── weather_model.dart             # Model Dart Cuaca & Geolokasi
│   ├── services/
│   │   ├── bmkg_service.dart              # Service HTTP API BMKG & wttr.in
│   │   └── location_service.dart          # Logika GPS, Geocoding, & Kalkulator Jarak
│   ├── utils/
│   │   ├── app_colors.dart                # Palet warna Clean Glassmorphism
│   │   └── constants.dart                 # URL endpoint BMKG & konfigurasi app
│   ├── widgets/
│   │   ├── error_view.dart                # Widget penanganan state Error
│   │   ├── gempa_card.dart                # Kartu riwayat gempa interaktif
│   │   ├── glass_container.dart           # Komponen Frosted Glass Reusable
│   │   ├── loading_view.dart              # Widget penanganan state Loading
│   │   └── weather_card.dart              # Kartu cuaca lokal glassmorphism
│   ├── screens/
│   │   ├── detail_gempa_screen.dart       # Detail lengkap gempa & Shakemap
│   │   ├── gempa_list_screen.dart         # Layar riwayat M 5.0+ & gempa dirasakan
│   │   ├── home_screen.dart               # Dashboard utama cuaca & auto gempa
│   │   └── info_screen.dart               # Informasi proyek UTS & identitas
│   └── main.dart                          # Entry point aplikasi & Glass Bottom Nav
├── test/
│   └── widget_test.dart                   # Unit test parser JSON & service jarak
├── pubspec.yaml                           # Konfigurasi dependensi proyek
└── README.md                              # Dokumentasi resmi proyek
```

---

## 🚀 Langkah Menjalankan Aplikasi

### 1. Prasyarat Sistem
- Telah menginstal [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.13 ke atas).
- Telah menginstal Android Studio atau VS Code dengan ekstensi Flutter & Dart.
- Koneksi internet aktif untuk mengambil data langsung dari API BMKG.

### 2. Kloning Repositori
```bash
git clone https://github.com/<username-anda>/terracast.git
cd terracast
```

### 3. Pasang Dependensi
Jalankan perintah berikut di root folder proyek:
```bash
flutter pub get
```

### 4. Menjalankan Pengujian Otomatis (*Unit Test*)
Untuk memverifikasi parser model dan kalkulasi logika:
```bash
flutter test
```

### 5. Menjalankan Aplikasi
Pilih emulator Android, perangkat fisik, atau browser Chrome:
```bash
# Menjalankan di perangkat/emulator default
flutter run

# Atau menjalankan di browser Chrome (Web preview)
flutter run -d chrome
```

---

## 📡 Sumber Data & Endpoint API
1. **Gempa Bumi Terkini Realtime**:  
   `https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json`
2. **Daftar 15 Gempa Bumi M 5.0+**:  
   `https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json`
3. **Daftar 15 Gempa Bumi Dirasakan**:  
   `https://data.bmkg.go.id/DataMKG/TEWS/gempadirasakan.json`
4. **Peta Shakemap BMKG**:  
   `https://data.bmkg.go.id/DataMKG/TEWS/{shakemap_filename}`
5. **Fallback IP Geolocation & Weather**:  
   `https://wttr.in/?format=j1`

---
*Dikembangkan untuk memenuhi Ujian Tengah Semester (UTS) Matakuliah Pemrograman Mobile.*
