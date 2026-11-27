# Konsep Finaku

Dokumen konsep awal aplikasi keuangan pribadi Finaku. Dokumen ini menjadi acuan sebelum pembangunan dimulai dan diperbarui setiap ada keputusan yang dikunci.

## 1. Tujuan

Membantu pengguna mengetahui ke mana uangnya pergi, mengendalikan pengeluaran per kategori, dan melihat posisi keuangan pribadinya tanpa spreadsheet dan tanpa aplikasi yang rumit.

Ruang lingkup terkunci pada 27 November 2026: aplikasi ini untuk pemakaian pribadi pemiliknya sendiri, bukan produk untuk pengguna lain. Tidak ada akun, tidak ada multi-pengguna, dan tidak ada layanan berbayar.

Pribadi bukan berarti mainan. Standar pembangunannya setara aplikasi produksi yang dipakai orang setiap hari: data harus benar, aplikasi harus tetap bisa dipakai dalam keadaan nyata, dan tidak ada fitur setengah jadi. Rinciannya ada di bagian 11.

## 2. Fitur versi pertama (MVP)

### Dasbor
- Saldo total dari semua dompet
- Total pemasukan dan pengeluaran bulan berjalan
- Selisih bulan berjalan
- Lima transaksi terakhir
- Anggaran kategori yang hampir habis atau sudah lewat

### Transaksi
- Tambah, ubah, dan hapus transaksi
- Jenis: pemasukan, pengeluaran, atau pindah dana antar dompet
- Pindah dana tercatat sebagai perpindahan, bukan pemasukan atau pengeluaran, sehingga total saldo tidak berubah dan laporan tidak terdistorsi
- Bidang: nominal, kategori, dompet, dompet tujuan (khusus pindah dana), tanggal, catatan (pilihan)
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
2. Nama paket dan identitas aplikasi, setelah platform dipilih

Ruang lingkup sudah terkunci: pemakaian pribadi, lihat bagian 1.

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

## 11. Standar aplikasi nyata

Karena aplikasi ini akan dipakai harian untuk uang sungguhan, hal berikut bukan tambahan, melainkan syarat sejak versi pertama:

- Integritas data: saldo dompet selalu dihitung dari transaksi, tidak pernah diisi bebas. Nominal wajib lebih dari nol. Penghapusan transaksi dan dompet meminta konfirmasi. Koreksi saldo dilakukan lewat transaksi penyesuaian yang tercatat, bukan mengubah angka secara diam diam
- Cadangan dan pemulihan: selain ekspor CSV untuk laporan, ada ekspor dan impor cadangan penuh dalam format JSON, supaya data bisa dipulihkan atau dipindah perangkat tanpa mengetik ulang
- Keadaan nyata: setiap layar punya keadaan kosong (belum ada data), memuat, dan galat. Aplikasi tetap jalan sepenuhnya tanpa jaringan
- Format yang benar: nominal ditampilkan sebagai rupiah dengan pemisah ribuan, tanggal mengikuti kalender setempat, dan perhitungan memakai bilangan bulat rupiah
- Pengujian: perhitungan saldo, pindah dana, dan kemajuan anggaran diuji dengan uji unit. Alur utama (tambah transaksi, lihat dasbor, ekspor) diperiksa manual sebelum setiap penyerahan, dan hasilnya dilaporkan
- Responsif dan akses: tata letak sempurna di ponsel, target sentuh minimal 44 piksel, kontras memenuhi WCAG AA, dan semua fungsi bisa dijangkau dengan papan ketik di web
- Tidak ada jalan buntu: tidak ada tombol mati, tidak ada menu ke halaman yang belum ada, dan tidak ada pesan galat tanpa jalan keluar
