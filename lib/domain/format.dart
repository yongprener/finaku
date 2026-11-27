/// Pemformatan tampilan Finaku.
library;

import '../data/models.dart';

const _monthNames = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

/// Bilangan bulat rupiah menjadi teks, misalnya 4250000 menjadi
/// "Rp 4.250.000". Tanda negatif tampil di depan Rp.
String formatRupiah(int value) {
  final negative = value < 0;
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${negative ? '-' : ''}Rp $buffer';
}

/// Nominal dengan tanda arah transaksi: pemasukan +, pengeluaran -,
/// pindah tanpa tanda karena uangnya tetap milik pengguna.
String formatSignedAmount(int amount, TransactionKind kind) {
  return switch (kind) {
    TransactionKind.income => '+${formatRupiah(amount)}',
    TransactionKind.expense => '-${formatRupiah(amount)}',
    TransactionKind.transfer => formatRupiah(amount),
  };
}

/// Label kelompok tanggal untuk riwayat, misalnya
/// "Hari ini, 27 November 2026" atau "Kemarin, 26 November 2026".
String dayLabel(DateTime date, DateTime now) {
  final day = DateTime(date.year, date.month, date.day);
  final today = DateTime(now.year, now.month, now.day);
  final text = '${date.day} ${_monthNames[date.month - 1]} ${date.year}';
  final diff = today.difference(day).inDays;
  if (diff == 0) return 'Hari ini, $text';
  if (diff == 1) return 'Kemarin, $text';
  return text;
}

/// Mengurai teks nominal yang diketik pengguna. Hanya digit yang
/// diambil, jadi "1.500.000" dan "1500000" sama sama menjadi 1500000.
/// Mengembalikan null bila tidak ada digit sama sekali.
int? parseAmount(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return null;
  return int.tryParse(digits);
}
