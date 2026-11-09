# RouteWise (`route_wise`)
> **Industrial Dispatch, Fleet Telematics & Decision Support System (SPK SAW)**  
> Terintegrasi dengan **Odoo ERP** melalui protokol JSON-RPC untuk rantai pasok dan distribusi barang terpadu.

---

## 📑 Daftar Isi
1. [Ringkasan Eksekutif & Filosofi Desain](#-ringkasan-eksekutif--filosofi-desain)
2. [Kredensial Autentikasi Operasional (Siap Pakai)](#-kredensial-autentikasi-operasional-siap-pakai)
3. [Arsitektur Responsif Dual-Mode](#-arsitektur-responsif-dual-mode)
4. [Fitur-Fitur Utama Sistem](#-fitur-fitur-utama-sistem)
5. [Metodologi SPK (Simple Additive Weighting - SAW)](#-metodologi-spk-simple-additive-weighting---saw)
6. [Integrasi Odoo ERP (JSON-RPC)](#-integrasi-odoo-erp-json-rpc)
7. [Peta Interaktif & Telematika GPS Armada](#-peta-interaktif--telematika-gps-armada)
8. [Struktur Direktori Proyek](#-struktur-direktori-proyek)
9. [Panduan Instalasi & Menjalankan Aplikasi](#-panduan-instalasi--menjalankan-aplikasi)
10. [Pengujian Otomatis (Quality Assurance)](#-pengujian-otomatis-quality-assurance)
11. [Tim Pengembang & Pembagian Tugas](#-tim-pengembang--pembagian-tugas)

---

## 🏭 Ringkasan Eksekutif & Filosofi Desain

**RouteWise** adalah platform manajemen logistik dan ekspedisi pergudangan modern yang dirancang khusus untuk operasional distribusi barang antar-agen. Sistem ini memadukan:
- **ERP Odoo Integration** untuk sinkronisasi pesanan penjualan (*Sales Order*) dan status transfer gudang (*Delivery Order/Picking*).
- **Sistem Pendukung Keputusan (SPK)** berbasis metode **Simple Additive Weighting (SAW)** guna menentukan urutan prioritas toko/agen tujuan pengiriman.
- **Peta Interaktif & Telematika Armada** dengan kalkulasi rute OSRM (*Open Source Routing Machine*), simulasi pergerakan armada secara *real-time*, dan navigasi *turn-by-turn*.

### 🎨 Filosofi Desain: Anti-AI-Slop *Industrial Dispatch & Manifest Ledger*
Antarmuka RouteWise menolak estetika generik AI (*gradient ungu mengambang, rounded corners berlebihan, drop shadow buram, dan ilustrasi kosong tanpa konteks*). Desain dibangun berlandaskan prinsip dokumen manifes logistik riil:
* **Tipografi Terstruktur**: Kombinasi `Roboto Mono` untuk data metrik, koordinat GPS, NIP, nilai numerik tabular, serta `Montserrat` tebal untuk tajuk dokumen operasional.
* **Palet Warna Nyata**: Kanvas perkamen hangat (`#F4F1EA`), permukaan putih tulang (`#FFFFFF`), teks arang pekat (`#1A1715`), dan aksen bata industri (`#9E3A1A`).
* **Micro-detail Taktil**: Border tegas 1px, cap status fisik (*Approved / Pending / Standby*), garis putus-putus tanda sobekan karcis manifes (*dashed rules*), dan tabel densitas tinggi.

---

## 🔐 Kredensial Autentikasi Operasional (Siap Pakai)

Sistem telah dilengkapi dengan profil personel pra-konfigurasi untuk masing-masing wewenang operasional:

| Peran Operasional | Email / NIP | Kata Sandi | Nama Personel | Wewenang & Hak Akses |
| :--- | :--- | :--- | :--- | :--- |
| **Kepala Gudang** | `david@routewise.id` | `password123` | David Timoteus | Ringkasan stok gudang, verifikasi & persetujuan permintaan pasar, sinkronisasi Odoo ERP. |
| **Driver Ekspedisi** | `Maulana@gmail.com` | `password123` | Ilham Maulana Ahmad | Manajemen manifest muatan, update status pengiriman (*Success/On Progress*), telematika GPS & navigasi rute. |
| **Admin SPK** | `iqbal@routewise.id` | `password123` | Moh Iqbal Fatoni | Konfigurasi bobot kriteria SAW, analisis matriks normalisasi, audit skor preferensi alternatif toko. |

> **Catatan Keamanan**: Kolom input email dan sandi tidak pernah diisi otomatis (*zero hardcoded auto-fill*) demi menjaga integritas data autentikasi. Pengguna juga dapat mendaftar akun mandiri melalui menu **"Daftar Akun Baru"**.

---

## 🖥️ Arsitektur Responsif Dual-Mode

RouteWise memiliki mesin adaptif yang mendeteksi resolusi layar secara dinamis:

1. **Mode Desktop Dispatch Console (Widescreen > 900px)**:
   - Sidebar navigasi tetap di sisi kiri dengan info personel aktif dan status koneksi ERP.
   - Layout multi-kolom berdampingan: Peta Radar GPS di sisi kiri (58%) dan Manifes Rekomendasi Rute di sisi kanan (42%).
2. **Mode Smartphone Viewport Simulator**:
   - Tersedia tombol **"LIHAT TAMPILAN HP"** di sidebar desktop untuk menguji langsung tata letak perangkat seluler 380px tanpa perlu mengubah ukuran jendela peramban (*browser*).
   - Dilengkapi *notch*, *speaker bar*, dan **Bottom Navigation Bar** khas aplikasi mobile asli.

---

## ⚙️ Fitur-Fitur Utama Sistem

```
                 ┌─────────────────────────────────────────┐
                 │          RouteWise Portal Hub           │
                 └────────────────────┬────────────────────┘
                                      │
         ┌────────────────────────────┼────────────────────────────┐
         │                            │                            │
         ▼                            ▼                            ▼
┌──────────────────┐        ┌──────────────────┐        ┌──────────────────┐
│  Kepala Gudang   │        │ Driver Ekspedisi │        │    Admin SPK     │
├──────────────────┤        ├──────────────────┤        ├──────────────────┤
│• Stok Gudang     │        │• Manifest Kirim  │        │• Matriks SAW     │
│• Validasi Order  │        │• Radar GPS OSRM  │        │• Bobot Kriteria  │
│• Sinkron Odoo    │        │• Simulasi Armada │        │• Urutan Prioritas│
└──────────────────┘        └──────────────────┘        └──────────────────┘
```

1. **Portal Autentikasi**: Login multi-peran dengan segmen tombol chip peran terintegrasi.
2. **Dashboard Kepala Gudang**:
   - Kartu metrik: Total Permintaan, Pengiriman Aktif, Selesai, dan Sinkronisasi ERP.
   - Grafik batang visualisasi produk terlaris (*Djava Mild, Djava Ocha, Djava Traditional*).
   - Ledger ringkas pengiriman hari ini dengan tombol persetujuan cepat.
3. **List Permintaan Pasar**:
   - Pencarian instan dan filter tab status (*Semua, Menunggu, Disetujui, Ditolak*).
   - Dialog penolakan dengan catatan alasan resmi.
   - Setiap permintaan yang disetujui otomatis masuk ke jadwal muatan pengiriman.
4. **Proses Pengiriman Barang**:
   - Monitoring manifest pengiriman dengan *live status toggle* (*On Progress* $\leftrightarrow$ *Success*).
   - Informasi koordinat drop-off, agen penerima, dan kuantitas pack rokok.
5. **Pengelolaan SPK (Metode SAW)**:
   - Panel konfigurasi bobot dinamis untuk 4 kriteria utama.
   - Visualisasi matriks ternormalisasi dan skor akhir preferensi ($V_i$).
6. **Rekomendasi Pemilihan Rute**:
   - Peta interaktif berbasis koordinat nyata Hub Kebonsari Malang.
   - Perhitungan jarak otomatis (Haversine & OSRM Routing).
7. **Kelola Profil Personel**:
   - Pembaruan nama, nomor kontak, email, dan kata sandi akun aktif.

---

## 📐 Metodologi SPK (Simple Additive Weighting - SAW)

Sistem Pendukung Keputusan (SPK) di RouteWise menggunakan algoritma **Simple Additive Weighting (SAW)** untuk mencari penjumlahan terbobot dari rating kinerja setiap alternatif toko pada seluruh kriteria.

### 1. Kriteria Penilaian

| Kode | Nama Kriteria | Kategori | Bobot ($W_j$) | Keterangan |
| :---: | :--- | :---: | :---: | :--- |
| **$C_1$** | Jarak Tempuh Gudang | **Cost** (Biaya) | $0.25$ | Semakin dekat jarak, semakin tinggi prioritas. |
| **$C_2$** | Jumlah Muatan Barang | **Benefit** (Keuntungan) | $0.30$ | Semakin banyak muatan pesanan, semakin diprioritaskan. |
| **$C_3$** | Estimasi Biaya Operasional | **Cost** (Biaya) | $0.25$ | Semakin hemat biaya solar/operasional, semakin disukai. |
| **$C_4$** | Estimasi Waktu Tempuh | **Cost** (Biaya) | $0.20$ | Semakin singkat durasi perjalanan, semakin efisien. |

$$\sum_{j=1}^{4} W_j = 0.25 + 0.30 + 0.25 + 0.20 = 1.00$$

### 2. Rumus Normalisasi Matriks ($R_{ij}$)

Untuk kriteria bertipe **Benefit**:
$$R_{ij} = \frac{x_{ij}}{\max_i(x_{ij})}$$

Untuk kriteria bertipe **Cost**:
$$R_{ij} = \frac{\min_i(x_{ij})}{x_{ij}}$$

### 3. Rumus Nilai Preferensi Alternatif ($V_i$)

$$V_i = \sum_{j=1}^{n} W_j \cdot R_{ij}$$

Alternatif dengan nilai $V_i$ terbesar menjadi **Rekomendasi Stop Prioritas #1** dalam manifes pengiriman armada.

---

## 🔗 Integrasi Odoo ERP (JSON-RPC)

RouteWise dilengkapi dengan layanan `OdooService` yang berkomunikasi langsung dengan Odoo ERP melalui endpoint JSON-RPC:

- **Autentikasi**: Endpoint `/jsonrpc` memanggil `common.authenticate` dengan parameter database, username, dan API key/password.
- **Pengambilan Sales Order**: Membaca model `sale.order` dan `sale.order.line` untuk mengonversi pesanan agen menjadi daftar permintaan pasar (`MarketRequest`).
- **Pengambilan Delivery Orders**: Membaca model `stock.picking` dan `stock.move` untuk melacak nomor resi surat jalan ekspedisi (`DeliveryOrder`).
- **Resilient Fallback**: Jika server Odoo offline atau belum terhubung, aplikasi beralih secara mulus ke memori lokal tanpa memblokir antarmuka pengguna.

---

## 🗺️ Peta Interaktif & Telematika GPS Armada

Layar **Rekomendasi Rute** menyediakan konsol telematika armada tingkat lanjut:

1. **Interactive Vector Canvas**:
   - Mendukung **Pan & Drag bebas** dengan klik/seret kursor mouse atau sentuhan jari.
   - Kontrol zoom bertingkat (`+`, `-`, dan `⊙ Recenter`).
2. **3 Preset Tema Visual Peta**:
   - 📜 **Kertas Gudang (Ledger)**: Desain perkamen industri hangat dengan kontur arang pekat.
   - 🌙 **Radar Night Ops**: Mode gelap taktikal dengan jalur neon emerald (`#10B981`).
   - 📐 **Blueprint CAD**: Latar biru arsitektural dengan garis koordinat cyan terang.
3. **Simulasi Armada Bergerak (Fleet Telematics HUD)**:
   - Tombol `▶ JALANKAN SIMULASI` menganimasikan truk ekspedisi melintasi kurva Bezier dari Hub Malang ke toko tujuan.
   - Truk otomatis memutar orientasi bodi (*heading rotation*) sesuai sudut belokan rute.
   - Dilengkapi *speedometer* dinamis (38–48 Km/jam), kalkulator sisa ETA, dan progress bar tempuh (0%–100%).
4. **Quick-Stop Carousel**:
   - Strip tombol horizontal di atas peta untuk berpindah antar-toko tujuan secara instan.
5. **Inspeksi Waypoint & Panduan Langkah**:
   - Klik pin toko mana saja untuk membuka kartu manifes detail dan estimasi biaya bahan bakar.
   - Tombol `📋 PANDUAN LANGKAH` menyajikan instruksi rute per segmen jalan.

---

## 📂 Struktur Direktori Proyek

```
route_wise/
├── lib/
│   ├── Components/
│   │   ├── bottom_nav_bar.dart      # Navigasi responsif (Desktop & Mobile Frame)
│   │   └── text_field.dart          # Komponen input teks standar
│   ├── models/
│   │   └── route_models.dart        # Model data (User, Request, Delivery, SPK)
│   ├── pages/
│   │   ├── DashboardKepalaGudang.dart # Dasbor ringkasan KPI gudang
│   │   ├── KelolaProfil.dart        # Form pembaruan profil pengguna
│   │   ├── ListPermintaan.dart      # Verifikasi & approval permintaan pasar
│   │   ├── Login.dart               # Halaman login bebas hardcoded value
│   │   ├── PengelolaanSPK.dart      # Konfigurasi bobot & kalkulasi SAW
│   │   ├── PengirimanBarang.dart    # Manifes pelacakan status pengiriman
│   │   ├── Profil.dart              # Tampilan ringkasan profil personel
│   │   ├── RekomendasiRute.dart     # Peta interaktif OSRM & telematika GPS
│   │   ├── SignUp.dart              # Pendaftaran akun personel baru
│   │   └── WelcomeScreen.dart       # Landing page awal sistem
│   ├── services/
│   │   ├── app_state.dart           # State management terpusat (ChangeNotifier)
│   │   ├── odoo_service.dart        # Klien JSON-RPC Odoo ERP
│   │   └── spk_calculator.dart      # Mesin kalkulator algoritma SAW & Haversine
│   ├── theme/
│   │   └── app_theme.dart           # Sistem token desain Industrial Ledger
│   └── main.dart                    # Entry point aplikasi
├── test/
│   └── widget_test.dart             # Unit test & Widget test otomatis
├── web/                             # Aset & konfigurasi web runner
├── android/                         # Konfigurasi native platform Android
├── pubspec.yaml                     # Manifest paket dependensi Flutter
└── README.md                        # Dokumentasi komprehensif sistem
```

---

## 🚀 Panduan Instalasi & Menjalankan Aplikasi

### 1. Prasyarat Sistem
- **Flutter SDK**: Versi `3.10.0` atau yang lebih baru.
- **Dart SDK**: Versi `^3.1.0`.
- **Web Browser**: Google Chrome / Microsoft Edge / Mozilla Firefox.

### 2. Kloning Repository
```bash
git clone https://github.com/DavidTimoteus/route_wise.git
cd route_wise
```

### 3. Unduh Dependensi
```bash
flutter pub get
```

### 4. Menjalankan di Browser Web
Untuk menjalankan mode pengembangan dengan *Hot Reload*:
```bash
flutter run -d chrome
```

Atau kompilasi bundel produksi web:
```bash
flutter build web
```
Hasil kompilasi akan berada di folder `build/web/` dan dapat disajikan menggunakan web server lokal (misalnya Python):
```bash
python -m http.server 8088 --directory build/web
```
Akses melalui peramban di: **`http://localhost:8088`**.

### 5. Menghubungkan ke Server Odoo ERP (Opsional)
Jalankan aplikasi dengan menyertakan argumen `--dart-define`:
```bash
flutter run -d chrome --dart-define=ODOO_URL=http://localhost:8069 --dart-define=ODOO_DB=routewise_erp
```

---

## 🧪 Pengujian Otomatis (Quality Assurance)

RouteWise dilengkapi rangkaian uji otomatis (*Unit Test & Widget Test*) untuk menjamin keandalan alur bisnis dan matematika SPK:

```bash
flutter test
```

Cakupan pengujian mencakup:
1. `WelcomeScreen renders login and signup actions` — Memverifikasi ketersediaan tombol navigasi utama.
2. `Tapping MASUK KE SISTEM navigates to Login screen` — Memverifikasi perpindahan rute dan form autentikasi.
3. `SpkCalculator ranks alternatives accurately using SAW method` — Memverifikasi keakuratan normalisasi kriteria Cost/Benefit dan perangkingan toko.

---

## 👥 Tim Pengembang & Pembagian Tugas

Proyek ini dikembangkan oleh tim mahasiswa sebagai tugas implementasi sistem informasi logistik terpadu:

| No. | Nama Pengembang | Profil GitHub | Fokus Pembagian Tugas |
| :---: | :--- | :--- | :--- |
| **1** | **David Timoteus Arya Bakti Pamungkas** | [@DavidTimoteus](https://github.com/DavidTimoteus) | *System Architecture*, Welcome Screen, Login & Sign-Up, Dashboard Kepala Gudang, Desain Responsif Desktop/Mobile, dan Integrasi Odoo ERP. |
| **2** | **Ilham Maulana Ahmad** | [@Maulanailham289](https://github.com/Maulanailham289) | Kelola Profil Personel, Sidebar Menu Profil, Navigasi Bottom Nav, dan Dokumentasi Sistem. |
| **3** | **Moh Iqbal Fatoni** | [@iqbalfatoni10](https://github.com/iqbalfatoni10) | Modul Rekomendasi Rute, Algoritma SPK SAW, List Permintaan Pasar, dan Monitoring Pengiriman Barang. |

---

## 📄 Lisensi
Proyek ini didistribusikan di bawah lisensi terbuka untuk keperluan akademik dan pengembangan sistem distribusi logistik. Hak cipta © 2026 Tim Pengembang RouteWise.
