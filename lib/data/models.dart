/// Model data Finaku, lepas dari kerangka penyimpanan.
///
/// Nominal selalu bilangan bulat rupiah, sesuai docs/konsep.md. Saldo
/// tidak pernah disimpan sebagai angka bebas: saldo selalu dihitung
/// dari saldo awal dompet ditambah seluruh transaksinya.
library;

/// Jenis transaksi. Pindah adalah perpindahan antar dompet milik
/// pengguna sendiri, bukan pemasukan dan bukan pengeluaran.
enum TransactionKind { income, expense, transfer }

/// Jenis dompet.
enum WalletKind { cash, bank, ewallet, other }

extension WalletKindLabel on WalletKind {
  String get label => switch (this) {
    WalletKind.cash => 'Tunai',
    WalletKind.bank => 'Bank',
    WalletKind.ewallet => 'E-Wallet',
    WalletKind.other => 'Lainnya',
  };
}

/// Dompet: satu tempat uang, misalnya Tunai, Bank, atau e-wallet.
class Wallet {
  const Wallet({
    required this.id,
    required this.name,
    required this.kind,
    required this.openingBalance,
    required this.archived,
  });

  final int id;
  final String name;
  final WalletKind kind;
  final int openingBalance;
  final bool archived;
}

/// Kategori transaksi. Jenisnya mengikuti jenis transaksi:
/// kategori pemasukan hanya untuk pemasukan, begitu juga pengeluaran.
class Category {
  const Category({required this.id, required this.name, required this.kind});

  final int id;
  final String name;

  /// Hanya income atau expense. Transfer tidak memakai kategori.
  final TransactionKind kind;

  /// Inisial dua huruf untuk lencana kategori, sesuai DESIGN.md.
  String get initials {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length >= 2) {
      return (words[0][0] + words[1][0]).toUpperCase();
    }
    return name
        .trim()
        .substring(0, name.trim().length >= 2 ? 2 : 1)
        .toUpperCase();
  }
}

/// Satu transaksi tercatat.
class Transaction {
  const Transaction({
    required this.id,
    required this.kind,
    required this.amount,
    required this.walletId,
    required this.toWalletId,
    required this.categoryId,
    required this.note,
    required this.date,
  });

  final int id;
  final TransactionKind kind;

  /// Nominal positif, bilangan bulat rupiah. Arah uang ditentukan jenis.
  final int amount;

  /// Dompet asal. Untuk pemasukan, ini dompet tujuannya.
  final int walletId;

  /// Dompet tujuan, hanya untuk jenis pindah.
  final int? toWalletId;

  /// Kategori, hanya untuk pemasukan dan pengeluaran.
  final int? categoryId;

  final String note;
  final DateTime date;
}
