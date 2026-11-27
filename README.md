# Finaku

Aplikasi keuangan pribadi untuk mencatat pemasukan, pengeluaran, dan anggaran, serta melihat kondisi keuangan secara ringkas dan jelas.

Finaku dirancang untuk berjalan sebagai aplikasi web dan aplikasi mobile dari satu basis kode yang sama.

## Status

Tahap konsep awal. Dokumen konsep ada di `docs/konsep.md`. Pilihan platform dan tumpukan teknologi belum dikunci dan akan diputuskan sebelum pembangunan dimulai.

Ruang lingkup terkunci: aplikasi ini untuk pemakaian pribadi pemiliknya. Bukan produk publik, tidak ada akun dan tidak ada multi-pengguna. Standarnya tetap setara aplikasi produksi: data benar, bisa dipakai luring, ada cadangan dan pemulihan, dan tidak ada fitur setengah jadi. Rincian standar ini ada di bagian 11 dokumen konsep.

## Rencana fitur utama

- Dasbor: saldo total, pemasukan dan pengeluaran bulan berjalan
- Pencatatan transaksi: nominal, kategori, dompet, tanggal, dan catatan
- Dompet: tunai, rekening bank, dan dompet elektronik
- Kategori pemasukan dan pengeluaran
- Anggaran bulanan per kategori
- Grafik pengeluaran per kategori dan per bulan
- Pencarian dan penyaringan riwayat transaksi
- Ekspor data ke berkas CSV
- Penyimpanan lokal di perangkat sebagai bawaan, tanpa perlu server

## Prinsip

- Data keuangan adalah data pribadi. Bawaan aplikasi adalah penyimpanan lokal di perangkat pengguna.
- Pencatatan harus cepat: menambah satu transaksi cukup dalam beberapa ketukan.
- Tampilan ringkas dan serius, tanpa istilah yang membingungkan.

## Keputusan yang masih terbuka

1. Platform: aplikasi web progresif (PWA) atau Flutter
2. Nama paket dan identitas aplikasi, setelah platform dipilih

Sinkronisasi antarperangkat tidak masuk versi pertama. Pemindahan data antarperangkat dilakukan lewat ekspor dan impor cadangan.

Keputusan tersebut dicatat dan diperbarui di `docs/konsep.md`.
