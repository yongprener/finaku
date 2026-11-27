# Arah Desain Finaku: Hijau Tua dan Limau

Tema warna ini dikunci pada 27 November 2026 atas keputusan pemilik, mengikuti komposisi warna contoh desain 1 yang ia kirim dan sukai: hijau tua pekat di bagian atas, hijau limau terang sebagai aksen, dan isi berwarna putih bersih.

Dokumen ini menggantikan arah sebelumnya (Pinus dan Kertas) yang dikunci lebih dulu di hari yang sama. Penggantian ini keputusan pemilik setelah melihat contoh visual kedua arah dan contoh desain dari luar, bukan penyimpangan diam diam.

Bacaan desainnya: aplikasi keuangan pribadi harian untuk satu pengguna di ponsel Android. Bagian atas yang hijau tua menampung sapaan dan saldo, lembar isi putih menimpanya, dan aksen limau hanya muncul di tindakan utama.

Putaran desain (antislop, Bagian 3): ENERGY 2, RHYTHM 1, MOTION 1.

- ENERGY 2, alasannya: aksen limau memang mencolok dan memberi tenaga, tetapi ia dipakai hemat di satu dua tempat saja, bukan di mana mana
- RHYTHM 1, alasannya: keseragaman yang disengaja. Pengguna harus bisa menebak letak segala sesuatu di layar mana pun, karena kecepatannya datang dari kebiasaan
- MOTION 1, alasannya: gerakan hanya untuk fungsi, yaitu tanggapan sentuhan dan perpindahan layar. Tidak ada animasi hiasan

## Warna

| Peran | Warna | Nilai | Alasan satu baris |
| --- | --- | --- | --- |
| Zona atas | Hijau tua | #0A3D2C | Warna utama Finaku: pekat, serius, dan menjadi panggung bagi saldo |
| Aksen | Hijau limau | #B9E33C | Hanya untuk tombol aksi utama, item navigasi aktif, dan sorotan di atas hijau tua. Di atas putih ia tidak dipakai sebagai teks karena kontrasnya kurang |
| Aksen di atas putih | Hijau limau gelap | #5E8C0A | Turunan limau untuk batang kemajuan dan penanda aktif di area putih, supaya tetap terbaca |
| Latar isi | Putih | #FFFFFF | Lembar isi dan latar layar selain dasbor: bersih dan netral di bawah zona hijau |
| Permukaan sekunder | Abu kehijauan | #EEF0EA | Jalur batang kemajuan, chip, dan pemisah halus di area putih |
| Tinta | Hijau tinta | #14231C | Teks utama di area putih, selaras dengan hijau tua tanpa menjadi hitam murni |

Warna semantis, hanya dipakai sesuai artinya, tidak pernah sebagai hiasan:

| Arti | Warna | Nilai | Batasan |
| --- | --- | --- | --- |
| Pemasukan | Hijau tua | #0A3D2C | Nominal pemasukan memakai warna utama, tidak menambah warna baru |
| Pengeluaran | Merah bata | #B42318 | Hanya untuk nominal pengeluaran dan ikon kategorinya |
| Peringatan | Jingga tua | #9A3412 | Hanya untuk anggaran yang mencapai 80 persen dan teks sisa anggaran |

Kontras terukur (diperiksa dengan pemeriksa kontras antislop_human, syarat WCAG AA teks normal 4,5:1):

- Putih di atas hijau tua: 12,23:1, lolos
- Hijau tua di atas limau: 8,22:1, lolos
- Hijau tua di atas putih: 12,23:1, lolos
- Merah bata di atas putih: 6,57:1, lolos
- Hijau limau gelap di atas putih: 4,01:1, lolos untuk teks besar dan elemen grafis (syarat 3:1)

Tidak ada gradasi warna di mana pun. Contoh desain 1 memang memakai gradasi pada spanduknya, dan bagian itu tidak diambil. Alasannya: warna rata terlihat lebih tegas, lebih murah secara kinerja, dan tidak jatuh ke tampilan generik.

## Huruf

Plus Jakarta Sans untuk semua teks.

- Alasannya: huruf ini dirancang perancang Indonesia, bentuknya serius tanpa kaku, dan angka tabularnya membuat nominal sejajar rapi di daftar
- Nominal selalu memakai angka tabular (font feature tnum di Flutter)
- Skala: saldo 28, judul layar 20, judul bagian 13 tebal, isi 12 sampai 14, keterangan 11. Tidak ada ukuran lain tanpa alasan tertulis

## Tata letak

Komposisi dasbor mengikuti contoh desain 1:

- Zona atas hijau tua: sapaan, nama, label saldo, saldo besar berwarna putih, lalu dua tombol berbentuk kapsul. Tombol utama berlatar limau dengan teks hijau tua, tombol kedua berbingkai putih tembus pandang dengan teks putih
- Lembar isi putih dengan sudut atas membulat 22 menimpa zona hijau sejauh 20. Alasannya: pemisahan ringkasan dan isi terasa fisik, dan mata tahu persis di mana isi dimulai
- Di dalam lembar isi: anggaran lebih dulu, lalu transaksi dikelompokkan per tanggal dengan kepala kelompok, mengikuti pola layar aktivitas pada contoh desain kedua yang dikirim pemilik
- Satu titik fokus per layar: di dasbor titik fokusnya saldo total. Elemen lain wajib lebih kecil dan lebih diam
- Jarak memakai kelipatan 4: 4, 8, 12, 16, 24. Tepi layar 18
- Sudut membulat: 22 untuk lembar isi, 12 untuk kartu dan daftar berkelompok, kapsul penuh hanya untuk tombol aksi di zona atas dan bar navigasi
- Bar navigasi bawah berbentuk pil melayang berwarna hijau tua, terpisah dari tepi layar dengan jarak 14 di sisi dan 14 di bawah. Isinya: Dasbor, Riwayat, tombol tambah transaksi di tengah, Anggaran, Laporan. Item aktif berwarna limau. Tombol tambah adalah satu satunya elemen yang menonjol, alasannya: mencatat transaksi adalah tindakan utama aplikasi ini
- Lencana kategori memakai inisial dua huruf di kotak membulat dengan warna latar semantis pucat, bukan ikon gambar. Alasannya: inisial selalu relevan dengan kategorinya, sedangkan ikon bawaan pustaka mudah terasa generik
- Layar selain dasbor (Riwayat, Anggaran, Laporan, Pengaturan) memakai latar putih dengan kepala halaman sederhana: judul dan subjudul di kiri, satu aksi di kanan bila ada. Pengaturan tampil sebagai daftar berkelompok dengan garis pemisah

## Keadaan layar

Setiap layar yang menampilkan data wajib punya tiga keadaan, sesuai standar di dokumen konsep:

- Kosong: kalimat yang menjelaskan keadaan dan satu tindakan nyata untuk memulai, misalnya belum ada transaksi dan tombol catat transaksi pertama
- Memuat: penanda muat sederhana berwarna hijau tua, tanpa kerangka abu abu yang berpura pura menjadi isi
- Galat: pesan yang menyebut masalahnya dan tombol coba lagi yang berfungsi

## Yang dilarang di Finaku

- Gradasi, kaca buram, dan cahaya menyala, karena tidak punya fungsi dan membuat tampilan generik
- Mode gelap pada versi pertama, karena tema ini memang dirancang dengan zona hijau tua di atas putih. Menambah mode gelap berarti merancang ulang
- Warna limau sebagai teks di atas putih, karena kontrasnya tidak cukup
- Ikon hiasan yang tidak berhubungan dengan isinya
- Statistik, testimoni, atau klaim apa pun, karena aplikasi ini pribadi dan tidak menjual apa apa
- Lebih dari satu tombol aksi utama dalam satu layar

## Catatan gerbang

Sebelum antar muka diserahkan, gerbang pemeriksaan antislop dijalankan dan dilaporkan dengan bukti: kontras, keadaan layar, kontrol yang berfungsi, dan pemeriksaan klik satu per satu pada hasil pembangunan Flutter.

## Ikon aplikasi

Ikon resmi Finaku dikunci pada 27 November 2026 atas persetujuan pemilik: huruf F berbentuk pita berwarna hijau limau dengan daun kecil kuning hangat, di atas latar hijau tua penuh. Bentuk F berasal dari contoh yang dibuat pemilik, lalu warnanya disesuaikan ke tema ini (contoh awalnya biru dan kuning di atas hitam, ditolak karena tidak satu keluarga dengan isi aplikasi). Berkas induknya tersimpan di assets/icon/finaku-icon-1024.png dan sudah diturunkan ke semua ukuran ikon Android dan web di proyek.
