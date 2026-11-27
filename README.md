# Finaku

Aplikasi keuangan pribadi untuk mencatat pemasukan, pengeluaran, dan anggaran, serta melihat kondisi keuangan secara ringkas dan jelas.

Finaku dirancang untuk berjalan sebagai aplikasi web dan aplikasi mobile dari satu basis kode yang sama.

## Status

Tahap konsep awal. Dokumen konsep ada di `docs/konsep.md`. Pilihan platform dan tumpukan teknologi belum dikunci dan akan diputuskan sebelum pembangunan dimulai.

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
2. Ruang lingkup: alat pakai pribadi atau produk untuk pengguna lain
3. Sinkronisasi antarperangkat: perlu atau cukup lokal

Keputusan tersebut dicatat dan diperbarui di `docs/konsep.md`.
