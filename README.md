# RouteWise (`route_wise`)

Aplikasi mobile berbasis Flutter dan Dart untuk manajemen pengiriman barang terintegrasi ERP Odoo, dilengkapi Sistem Pendukung Keputusan (SPK) metode Simple Additive Weighting (SAW) dan rekomendasi rute pengiriman.

## Fitur Utama
1. **Welcome Screen, Login & Sign-Up** — Autentikasi pengguna berbasis peran (*Kepala Gudang*, *Driver*, *Admin SPK*).
2. **Dashboard Kepala Gudang** — Ringkasan aktivitas pengiriman, daftar permintaan, produk terlaris, dan agen utama.
3. **List Permintaan Pasar** — Pencarian, penyaringan status, serta persetujuan/penolakan permintaan pasar yang terhubung langsung ke jadwal pengiriman.
4. **Proses Pengiriman Barang** — Pemantauan dan pembaruan status pengiriman (*On Progress* / *Success*).
5. **Pengelolaan SPK (Metode SAW)** — Perhitungan bobot kriteria (jarak tempuh, jumlah barang, estimasi biaya, waktu tempuh) untuk menentukan prioritas pengiriman.
6. **Rekomendasi Pemilihan Rute** — Peta interaktif Google Maps dengan kalkulasi rute OSRM dan urutan prioritas SPK.
7. **Kelola Profil** — Pembaruan informasi akun pengguna.
8. **Konektor Odoo ERP** — Layanan sinkronisasi JSON-RPC untuk *Sales Order* (`sale.order`) dan *Delivery Order* (`stock.picking`).

## Konfigurasi Lingkungan
Tambahkan kunci Google Maps API pada berkas `android/local.properties` (berkas ini tidak di-commit ke Git):
```properties
MAPS_API_KEY=your_google_maps_api_key_here
```

Untuk menghubungkan aplikasi ke server Odoo ERP saat dijalankan:
```bash
flutter run --dart-define=ODOO_URL=http://localhost:8069 --dart-define=ODOO_DB=routewise_erp
```

## Anggota Kelompok
1. [David Timoteus Arya Bakti Pamungkas](https://github.com/DavidTimoteus)
2. [Ilham Maulana Ahmad](https://github.com/Maulanailham289)
3. [Moh Iqbal Fatoni](https://github.com/iqbalfatoni10)

## Pembagian Tugas
- Welcome Screen, Login, Sign Up & Dashboard Kepala Gudang (David)
- Kelola Profil & Sidebar Menu Profil (Ilham)
- Rekomendasi Rute, Pengelolaan SPK, List Permintaan & Proses Pengiriman (Iqbal & David)
