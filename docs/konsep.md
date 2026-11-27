# Konsep Finaku

Dokumen konsep awal aplikasi keuangan pribadi Finaku. Dokumen ini menjadi acuan sebelum pembangunan dimulai dan diperbarui setiap ada keputusan yang dikunci.

## 1. Tujuan

Membantu pengguna mengetahui ke mana uangnya pergi, mengendalikan pengeluaran per kategori, dan melihat posisi keuangan pribadinya tanpa spreadsheet dan tanpa aplikasi yang rumit.

Pengguna sasaran awal: pemilik aplikasi sendiri, untuk pemakaian harian. Kemungkinan dibuka untuk pengguna lain belum diputuskan.

## 2. Fitur versi pertama (MVP)

### Dasbor
- Saldo total dari semua dompet
- Total pemasukan dan pengeluaran bulan berjalan
- Selisih bulan berjalan
- Lima transaksi terakhir
- Anggaran kategori yang hampir habis atau sudah lewat

### Transaksi
- Tambah, ubah, dan hapus transaksi
- Jenis: pemasukan atau pengeluaran
- Bidang: nominal, kategori, dompet, tanggal, catatan (pilihan)
- Pencatatan cepat dari layar utama

### Dompet
- Jenis: tunai, rekening bank, dompet elektronik, lainnya
- Saldo awal dan saldo berjalan yang dihitung dari transaksi
- Arsipkan dompet yang tidak lagi dipakai

### Kategori
- Bawaan pengeluaran: Makanan, Transportasi, Belanja, Tagihan, Hiburan, Kesehatan, Pendidikan, Lainnya
- Bawaan pemasukan: Gaji, Usaha, Lainnya
- Pengguna dapat menambah kategori sendiri

### Anggaran
- Batas bulanan per kategori pengeluaran
- Kemajuan anggaran ditampilkan di dasbor dan halaman anggaran
- Penanda visual bila pemakaian melewati 80 persen dan 100 persen

### Laporan sederhana
- Grafik pengeluaran per kategori untuk bulan terpilih
- Grafik pemasukan dan pengeluaran per bulan
- Ekspor transaksi ke berkas CSV

## 3. Di luar versi pertama

- Sinkronisasi antarperangkat dan masuk dengan akun
- Impor mutasi bank atau dompet elektronik
- Transaksi berulang otomatis
- Pengingat tagihan
- Multi-mata uang
- Mode keluarga atau dompet bersama

Fitur di atas hanya dipertimbangkan setelah versi pertama dipakai secara nyata.

## 4. Model data awal

- Dompet: id, nama, jenis, saldo awal, diarsipkan
- Kategori: id, nama, jenis (pemasukan atau pengeluaran), ikon
- Transaksi: id, dompet, kategori, jenis, nominal, tanggal, catatan
- Anggaran: id, kategori, bulan, batas nominal

Nominal disimpan sebagai bilangan bulat rupiah untuk menghindari kesalahan pembulatan.

## 5. Layar awal

1. Dasbor
2. Riwayat transaksi
3. Tambah transaksi
4. Anggaran
5. Dompet dan kategori (pengaturan data)
6. Laporan

## 6. Prinsip data dan privasi

- Bawaan: semua data tersimpan lokal di perangkat (penyimpanan lokal peramban atau basis data lokal aplikasi).
- Tidak ada server dan tidak ada pengiriman data keuangan ke pihak ketiga pada versi pertama.
- Ekspor CSV adalah jalan pengguna memindahkan dan mencadangkan datanya sendiri.

## 7. Pilihan platform

Satu basis kode untuk web dan mobile adalah syarat. Dua calon:

| Calon | Kelebihan | Kekurangan |
| --- | --- | --- |
| Aplikasi web progresif (PWA), React dan TypeScript | Paling cepat jadi, jalan di peramban dan dapat dipasang di layar utama ponsel seperti aplikasi, tanpa toko aplikasi | Kemampuan perangkat terbatas dibanding aplikasi asli |
| Flutter | Satu kode untuk Android, iOS, dan web, tampilan terasa seperti aplikasi asli | Waktu pembangunan dan ukuran berkas lebih besar, versi web tidak seringan PWA |

Rekomendasi awal: PWA, karena tujuan versi pertama adalah alat yang cepat dipakai harian. Keputusan akhir belum dikunci.

## 8. Keputusan terbuka

1. Platform: PWA atau Flutter
2. Ruang lingkup: pakai pribadi atau produk untuk pengguna lain
3. Nama paket dan identitas aplikasi, setelah platform dipilih

## 9. Langkah berikutnya

1. Kunci keputusan platform
2. Kunci arah desain (identitas, warna, huruf) sebelum antar muka dibangun
3. Susun kerangka proyek sesuai platform terpilih di repo ini
4. Bangun MVP sesuai urutan: dompet dan kategori, transaksi, dasbor, anggaran, laporan dan ekspor

## 10. Saringan kualitas

Proyek ini memakai antislop dengan mode DURING, diputuskan pada 27 November 2026. Artinya aturan antislop diterapkan sambil jalan, sejak perencanaan, bukan diaudit di akhir.

Konsekuensi praktisnya:

- Setiap keputusan visual harus punya alasan tertulis satu baris (aturan R-31)
- Arah desain harus dikunci dulu sebelum antar muka dibangun (R-37). Tanpa arah, hasil hanya boleh disebut draf
- Tidak membuat logo, ikon aplikasi, atau aset visual lain tanpa persetujuan pemilik (R-23)
- Tidak ada angka, statistik, testimoni, atau klaim yang dibuat buat (R-17, R-18, R-36, R-38)
- Tidak ada tombol atau tautan yang tidak berfungsi (R-26), dan setiap tampilan data wajib punya keadaan kosong, memuat, dan galat (R-27)
- Teks yang ditulis proyek tidak memakai tanda pisah panjang dan tidak memakai kata pemasaran kosong (R-02, R-16)
- Sebelum diserahkan, pekerjaan antar muka harus lolos gerbang pemeriksaan antislop dan dilaporkan dengan bukti
