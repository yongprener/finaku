# Arah Desain Finaku: Pinus dan Kertas

Dikunci pada 27 November 2026 atas pilihan pemilik, dari dua contoh visual yang dibandingkan dengan isi yang sama. Dokumen ini adalah arah desain resmi Finaku. Antar muka yang menyimpang dari dokumen ini harus mengubah dokumennya dulu, bukan menyimpang diam diam.

Bacaan desainnya: aplikasi keuangan pribadi harian untuk satu pengguna di ponsel Android, dengan bahasa visual buku kas modern yang tenang dan bisa dipercaya.

Putaran desain (antislop, Bagian 3): ENERGY 1, RHYTHM 1, MOTION 1.

- ENERGY 1, alasannya: aplikasi uang yang dibuka setiap hari harus menyapa dengan tenang, bukan berteriak. Satu titik fokus per layar sudah cukup
- RHYTHM 1, alasannya: keseragaman yang disengaja. Pengguna harus bisa menebak letak segala sesuatu di layar mana pun, karena kecepatannya datang dari kebiasaan
- MOTION 1, alasannya: gerakan hanya untuk fungsi, yaitu tanggapan sentuhan dan perpindahan layar. Tidak ada animasi hiasan

## Warna

Palet inti dibatasi tiga warna, di luar netral dan warna semantis.

| Peran | Warna | Nilai | Alasan satu baris |
| --- | --- | --- | --- |
| Latar | Kertas hangat | #F7F5EF | Memberi rasa buku kas kertas, membedakan Finaku dari aplikasi keuangan serba putih dan biru |
| Tinta | Hijau tinta pekat | #1C2420 | Teks utama yang tegas di atas kertas, lebih hidup daripada hitam murni |
| Utama | Hijau pinus | #175C3A | Warna aksi dan pemasukan: tenang, berhubungan dengan uang, dan bukan biru bank yang generik |
| Permukaan | Putih | #FFFFFF | Kartu dan lembar di atas kertas, hanya untuk mengelompokkan isi |
| Garis | Garis buku kas | #E6DFCA | Pemisah baris seperti garis pada buku tulis kas |

Warna semantis, hanya dipakai sesuai artinya, tidak pernah sebagai hiasan:

| Arti | Warna | Nilai | Batasan |
| --- | --- | --- | --- |
| Pengeluaran | Merah bata | #B42318 | Hanya untuk nominal pengeluaran dan ikon kategorinya |
| Peringatan | Jingga tua | #9A3412 | Hanya untuk anggaran yang mencapai 80 persen dan teks sisa anggaran |

Kontras terukur (diperiksa dengan pemeriksa kontras antislop_human, syarat WCAG AA teks normal 4,5:1):

- Putih di atas pinus: 7,99:1, lolos
- Tinta di atas kertas: 14,56:1, lolos
- Pinus di atas kertas: 7,33:1, lolos
- Merah bata di atas kertas: 6,03:1, lolos
- Jingga tua di atas kertas: 6,70:1, lolos

Tidak ada gradasi warna di mana pun. Alasannya: buku kas tidak bergradasi, dan gradasi adalah jalan pintas paling umum menuju tampilan generik.

## Huruf

Plus Jakarta Sans untuk semua teks.

- Alasannya: huruf ini dirancang perancang Indonesia, bentuknya serius tanpa kaku, dan angka tabularnya membuat nominal sejajar rapi di daftar
- Nominal selalu memakai angka tabular (font feature tnum di Flutter)
- Skala: saldo 28 sampai 30, judul layar 20, judul bagian 13 tebal, isi 12 sampai 14, keterangan 11. Tidak ada ukuran lain tanpa alasan tertulis
- Label kecil berhuruf besar hanya untuk label kolom dan label dompet, dengan jarak huruf secukupnya. Bukan untuk judul

## Tata letak dan motif

Motif identitasnya adalah garis buku kas: garis tipis #E6DFCA memisahkan baris transaksi, dan satu garis pinus pendek (lebar 44, tebal 2) di bawah saldo total sebagai tanda tangan Finaku.

- Saldo total tidak dimasukkan ke dalam kartu. Alasannya: saldo adalah tokoh utama layar, ia berdiri langsung di atas kertas, digarisbawahi pinus. Kartu hanya untuk pengelompokan sekunder seperti dompet
- Satu titik fokus per layar: di dasbor titik fokusnya saldo total. Elemen lain wajib lebih kecil dan lebih diam
- Jarak memakai kelipatan 4: 4, 8, 12, 16, 24. Tepi layar 18
- Sudut membulat: 10 untuk kartu dan tombol, 8 untuk lencana kategori, lingkaran penuh hanya untuk tombol tambah transaksi. Alasannya: membulat seperlunya terasa modern tanpa menjadi serba kapsul
- Bar navigasi bawah: Dasbor, Riwayat, tombol tambah transaksi melayang di tengah, Anggaran, Laporan. Tombol tambah adalah satu satunya elemen melayang, alasannya: mencatat transaksi adalah tindakan utama aplikasi ini dan harus terjangkau jempol dari layar mana pun
- Lencana kategori memakai inisial dua huruf di kotak membulat dengan warna latar semantis pucat, bukan ikon gambar. Alasannya: inisial selalu relevan dengan kategorinya, sedangkan ikon bawaan pustaka mudah terasa generik

## Keadaan layar

Setiap layar yang menampilkan data wajib punya tiga keadaan, sesuai standar di dokumen konsep:

- Kosong: kalimat yang menjelaskan keadaan dan satu tindakan nyata untuk memulai, misalnya belum ada transaksi dan tombol catat transaksi pertama
- Memuat: penanda muat sederhana berwarna pinus, tanpa kerangka abu abu yang berpura pura menjadi isi
- Galat: pesan yang menyebut masalahnya dan tombol coba lagi yang berfungsi

## Yang dilarang di Finaku

- Gradasi, kaca buram, dan cahaya menyala, karena tidak punya fungsi di buku kas
- Mode gelap pada versi pertama, karena palet kertas ini memang dirancang terang. Menambah mode gelap berarti merancang ulang, bukan membalik warna
- Ikon hiasan yang tidak berhubungan dengan isinya
- Statistik, testimoni, atau klaim apa pun, karena aplikasi ini pribadi dan tidak menjual apa apa
- Lebih dari satu tombol aksi utama dalam satu layar

## Catatan gerbang

Sebelum antar muka diserahkan, gerbang pemeriksaan antislop dijalankan dan dilaporkan dengan bukti: kontras, keadaan layar, kontrol yang berfungsi, dan pemeriksaan klik satu per satu pada hasil pembangunan Flutter.
