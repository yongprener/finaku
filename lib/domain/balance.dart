/// Hitungan saldo Finaku, ditulis sebagai fungsi murni supaya bisa
/// diuji tanpa basis data.
///
/// Aturan dari docs/konsep.md:
/// - Saldo dompet = saldo awal + pemasukan - pengeluaran
///   + pindah masuk - pindah keluar, dari seluruh transaksinya.
/// - Pindah dana tidak mengubah saldo total semua dompet.
/// - Saldo tidak pernah berasal dari angka yang diketik bebas.
library;

import '../data/models.dart';

int walletBalance(Wallet wallet, List<Transaction> transactions) {
  var balance = wallet.openingBalance;
  for (final t in transactions) {
    switch (t.kind) {
      case TransactionKind.income:
        if (t.walletId == wallet.id) balance += t.amount;
      case TransactionKind.expense:
        if (t.walletId == wallet.id) balance -= t.amount;
      case TransactionKind.transfer:
        if (t.walletId == wallet.id) balance -= t.amount;
        if (t.toWalletId == wallet.id) balance += t.amount;
    }
  }
  return balance;
}

/// Saldo total semua dompet yang tidak diarsipkan.
int totalBalance(List<Wallet> wallets, List<Transaction> transactions) {
  var total = 0;
  for (final w in wallets) {
    if (!w.archived) total += walletBalance(w, transactions);
  }
  return total;
}

/// Jumlah satu jenis transaksi pada bulan tertentu.
/// Pindah dana selalu menghasilkan 0 di sini, karena bukan
/// pemasukan dan bukan pengeluaran.
int monthlySum(
  List<Transaction> transactions,
  TransactionKind kind,
  DateTime month,
) {
  if (kind == TransactionKind.transfer) return 0;
  var sum = 0;
  for (final t in transactions) {
    if (t.kind == kind &&
        t.date.year == month.year &&
        t.date.month == month.month) {
      sum += t.amount;
    }
  }
  return sum;
}
