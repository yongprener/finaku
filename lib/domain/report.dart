/// Laporan dan ekspor Finaku: fungsi murni di atas daftar transaksi.
///
/// Grafik tidak dibuat di sini; modul ini hanya menghitung angka yang
/// kemudian digambar layar sebagai daftar dan batang sederhana, sesuai
/// pola riset referensi (daftar adalah tulang punggungnya).
library;

import '../data/models.dart';

/// Satu baris ringkasan pengeluaran per kategori.
class CategoryTotal {
  const CategoryTotal({
    required this.categoryId,
    required this.total,
    required this.percent,
  });

  final int categoryId;
  final int total;

  /// Persen dari total pengeluaran bulan itu, dibulatkan ke bawah.
  final int percent;
}

/// Pengeluaran per kategori pada satu bulan, terbesar dulu.
/// Kategori tanpa pengeluaran tidak disertakan.
List<CategoryTotal> expenseByCategory(
  List<Transaction> transactions,
  DateTime month,
) {
  final sums = <int, int>{};
  var totalAll = 0;
  for (final t in transactions) {
    if (t.kind == TransactionKind.expense &&
        t.categoryId != null &&
        t.date.year == month.year &&
        t.date.month == month.month) {
      sums[t.categoryId!] = (sums[t.categoryId!] ?? 0) + t.amount;
      totalAll += t.amount;
    }
  }
  final result = sums.entries
      .map(
        (e) => CategoryTotal(
          categoryId: e.key,
          total: e.value,
          percent: totalAll == 0 ? 0 : (e.value * 100) ~/ totalAll,
        ),
      )
      .toList();
  result.sort((a, b) => b.total.compareTo(a.total));
  return result;
}

/// Ringkasan satu bulan untuk laporan beberapa bulan.
class MonthTotal {
  const MonthTotal({
    required this.month,
    required this.income,
    required this.expense,
  });

  final DateTime month;
  final int income;
  final int expense;

  int get difference => income - expense;
}

/// Total masuk dan keluar untuk [count] bulan terakhir termasuk bulan
/// berjalan, urut dari yang paling lama ke yang terbaru.
List<MonthTotal> monthlyTotals(
  List<Transaction> transactions,
  DateTime now,
  int count,
) {
  final result = <MonthTotal>[];
  for (var i = count - 1; i >= 0; i--) {
    final month = DateTime(now.year, now.month - i);
    var income = 0;
    var expense = 0;
    for (final t in transactions) {
      if (t.date.year == month.year && t.date.month == month.month) {
        if (t.kind == TransactionKind.income) income += t.amount;
        if (t.kind == TransactionKind.expense) expense += t.amount;
      }
    }
    result.add(MonthTotal(month: month, income: income, expense: expense));
  }
  return result;
}

String _csvCell(String value) {
  if (value.contains(';') || value.contains('"') || value.contains('\n')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

String _dateText(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Membangun isi berkas CSV seluruh transaksi.
///
/// Pemisah titik koma supaya langsung rapi dibuka di Excel berbahasa
/// Indonesia. Urutan dari transaksi terlama ke terbaru.
String buildCsv({
  required List<Transaction> transactions,
  required String Function(int id) walletName,
  required String Function(int? id) categoryName,
}) {
  final sorted = List.of(transactions)
    ..sort((a, b) => a.date.compareTo(b.date));
  final lines = <String>[
    'tanggal;jenis;dompet;dompet_tujuan;kategori;catatan;nominal',
  ];
  for (final t in sorted) {
    final kind = switch (t.kind) {
      TransactionKind.income => 'pemasukan',
      TransactionKind.expense => 'pengeluaran',
      TransactionKind.transfer => 'pindah',
    };
    lines.add(
      [
        _dateText(t.date),
        kind,
        _csvCell(walletName(t.walletId)),
        _csvCell(t.toWalletId == null ? '' : walletName(t.toWalletId!)),
        _csvCell(categoryName(t.categoryId)),
        _csvCell(t.note),
        t.amount.toString(),
      ].join(';'),
    );
  }
  return lines.join('\n');
}
