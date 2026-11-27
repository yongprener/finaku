# Referensi UI dan UX untuk Finaku

Hasil riset 27 November 2026 dari Dribbble dan Behance. Semua contoh ditemukan lewat pencarian dan halamannya dibuka. Referensi ini bahan inspirasi pola, bukan untuk ditiru persis, dan tidak mengubah arah desain yang sudah terkunci di `DESIGN.md` (Hijau Tua dan Limau, menggantikan Pinus dan Kertas).

## Contoh yang dinilai paling cocok

### 1. Mindful Money, Budget and Expense Tracker untuk Android (Behance)
- Tautan: https://www.behance.net/gallery/97038335/Mindful-Money
- Yang dipelajari: berangkat dari metode kakeibo dan buku jurnal. Layar utamanya buku besar yang bisa dicari dan disaring, navigasi bawah dipilih agar fitur tidak tersembunyi, dan grafik tidak ditampilkan bila data belum cukup, diganti pemberitahuan alasannya. Ada entri berulang dan penggandaan anggaran bulanan
- Kecocokan: sangat cocok. Bukti bahwa pola buku besar, navigasi bawah yang jujur, dan keadaan kosong yang dijelaskan memang bekerja untuk aplikasi anggaran Android

### 2. Finance app mobile concept, oleh Layo (Dribbble)
- Tautan: https://dribbble.com/shots/27205868-Finance-app-mobile-concept
- Yang dipelajari: layar disusun di sekitar tiga momen saja, yaitu saldo saat ini, rincian pengeluaran, dan aktivitas terakhir, dengan angka besar untuk informasi utama. Warna dipakai secara fungsional untuk membedakan keadaan, bukan hiasan. Navigasi dipadatkan menjadi Home, Statistics, Savings, Profile
- Kecocokan: sangat cocok. Warna fungsional dan struktur tiga momen sejalan dengan kaidah warna semantis dan satu titik fokus per layar di Finaku

### 3. Task and Spend, To-Do and Expense Tracker UI/UX Case Study, oleh Basheer Ahmad Mukhlis (Behance)
- Tautan: https://www.behance.net/gallery/257324361/Task-Spend-To-Do-Expense-Tracker-UIUX-Case-Study
- Yang dipelajari: titik sakit berupa layar kosong yang tidak jelas diidentifikasi sebagai masalah nyata yang harus dirancang jawabannya, dan sistem warna dirumuskan sebagai fondasi tenang dengan sinyal yang jelas
- Kecocokan: cocok. Perhatian eksplisitnya pada keadaan kosong dan fondasi tenang sejalan dengan kewajiban keadaan kosong, memuat, dan galat di Finaku

## Contoh lain yang berguna sebagian

### 4. Maven, Finance Tracker Mobile App Design, oleh Orbix Studio (Dribbble)
- Tautan: https://dribbble.com/shots/27530874-Maven-Finance-Tracker-Mobile-App-Design
- Yang dipelajari: hierarki visual yang menegaskan satu hal terpenting lebih dulu, dan navigasi minimal untuk pemakaian harian
- Kecocokan: sebagian. Prinsip hierarkinya sejalan, tetapi bahasa visualnya kaca lembut dan gradasi, yang dilarang di Finaku

### 5. Finance Management Dashboard UI, oleh Pixelwibes (Dribbble)
- Tautan: https://dribbble.com/shots/26914938-Finance-Management-Dashboard-UI
- Yang dipelajari: indikator kemajuan anggaran dan daftar transaksi terakhir dengan penanda status yang jelas, plus ringkasan saldo dan arus bulanan sekali pandang
- Kecocokan: sebagian. Pola indikatornya berguna, tetapi wujud dasbor web berkartu banyak terlalu ramai untuk dasbor ponsel Finaku

### 6. Douugh Mobile App, oleh Neopix (Dribbble)
- Tautan: https://dribbble.com/shots/3131240-Douugh-Mobile-App
- Yang dipelajari: linimasa sebagai alur utama pemasukan dan pengeluaran, dan perpindahan antar komponen akun dengan geser
- Kecocokan: sebagian. Linimasanya sejalan dengan motif buku kas, tetapi navigasi geser tersembunyi bertabrakan dengan prinsip Finaku bahwa letak segala sesuatu harus tertebak

### 7. SPENDLY, Finance Simplified (Behance)
- Tautan: https://www.behance.net/gallery/258478479/SPENDLY-Finance-Simplified-UIUX-Case-Study
- Yang dipelajari: penggabungan anggaran, pelacakan pengeluaran, tujuan menabung, dan tagihan dalam satu alur sederhana
- Kecocokan: cocok pada tataran cakupan fitur. Bahasa visualnya generik, hanya polanya yang diambil

### 8. BudgetEase App, Expense Tracker (Behance)
- Tautan: https://www.behance.net/gallery/240820197/BudgetEase-App-Expense-Tracker-%28Finance-App%29
- Yang dipelajari: tujuan eksplisit mengurangi kecemasan finansial dengan mengubah data rumit menjadi wawasan yang jelas
- Kecocokan: cocok pada tataran nada, sejalan dengan ENERGY 1. Rincian layarnya tipis, nilai utamanya pada penalaran produk

### 9. FinTrack, Finance and Expense Tracker App UI/UX Case Study (Behance)
- Tautan: https://www.behance.net/gallery/240909359/Finance-Expense-Tracker-App-UIUX-Case-Study
- Yang dipelajari: penyederhanaan tiga pekerjaan harian, yaitu mencatat pengeluaran, memantau aktivitas mingguan, dan mengelola transaksi
- Kecocokan: cocok pada tataran ritme. Pembagian harian dan mingguan berguna untuk halaman Laporan Finaku

## Tiga pola terbaik untuk Finaku

1. Saldo besar sebagai satu satunya tokoh utama, lalu rincian kategori dengan warna yang hanya dipakai sesuai arti (dari Layo). Memperkuat keputusan terkunci: saldo tidak dimasukkan ke kartu, merah bata hanya untuk pengeluaran, jingga tua hanya untuk peringatan anggaran
2. Daftar buku besar sebagai tulang punggung layar, lengkap dengan cari dan saring, dan grafik yang disembunyikan dengan penjelasan bila data belum cukup (dari Mindful Money). Jembatan paling langsung antara motif garis buku kas dan kewajiban keadaan kosong yang jujur
3. Indikator kemajuan anggaran dan status transaksi yang terbaca sekilas (dari Pixelwibes dan Spendly). Batang kemajuan sederhana sejalan dengan MOTION 1 dan RHYTHM 1

## Dua pola populer yang dihindari

1. Kaca buram dan gradasi lembut sebagai bahasa utama (Maven dan banyak dasbor fintech). Dilarang eksplisit di DESIGN.md, dan merupakan jalan pintas paling umum menuju tampilan generik
2. Mode gelap ramai dengan grafik donat banyak warna, kartu investasi, dan fitur kartu virtual (tren pelacak mode gelap dan Pixelwibes). Finaku versi pertama dirancang terang di atas kertas, cakupannya hanya pencatatan pribadi, dan energinya bertabrakan dengan putaran tenang yang sudah dikunci
