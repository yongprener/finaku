import 'dart:convert';

import 'models.dart';

/// Potret seluruh data Finaku untuk cadangan JSON.
///
/// Format versi 1: dompet, kategori, anggaran, dan transaksi, lengkap
/// dengan id aslinya, supaya pemulihan mengembalikan data persis sama.
/// Berkas ini milik pengguna dan hanya dibuat saat ia mengekspor.
class BackupData {
  const BackupData({
    required this.wallets,
    required this.categories,
    required this.budgets,
    required this.transactions,
  });

  final List<Wallet> wallets;
  final List<Category> categories;
  final List<Budget> budgets;
  final List<Transaction> transactions;

  Map<String, dynamic> toJson() => {
    'app': 'finaku',
    'version': 1,
    'wallets': [
      for (final w in wallets)
        {
          'id': w.id,
          'name': w.name,
          'kind': w.kind.name,
          'openingBalance': w.openingBalance,
          'archived': w.archived,
        },
    ],
    'categories': [
      for (final c in categories)
        {'id': c.id, 'name': c.name, 'kind': c.kind.name},
    ],
    'budgets': [
      for (final b in budgets)
        {
          'id': b.id,
          'categoryId': b.categoryId,
          'monthlyLimit': b.monthlyLimit,
        },
    ],
    'transactions': [
      for (final t in transactions)
        {
          'id': t.id,
          'kind': t.kind.name,
          'amount': t.amount,
          'walletId': t.walletId,
          'toWalletId': t.toWalletId,
          'categoryId': t.categoryId,
          'note': t.note,
          'date': t.date.toIso8601String(),
        },
    ],
  };

  String encode() => const JsonEncoder.withIndent('  ').convert(toJson());

  /// Mengurai teks cadangan. Melempar FormatException dengan pesan
  /// yang bisa ditampilkan ke pengguna bila isinya tidak sah.
  factory BackupData.decode(String text) {
    final dynamic root;
    try {
      root = jsonDecode(text);
    } on FormatException {
      throw const FormatException('Isi berkas bukan JSON yang sah.');
    }
    if (root is! Map<String, dynamic> || root['app'] != 'finaku') {
      throw const FormatException('Berkas ini bukan cadangan Finaku.');
    }
    if (root['version'] != 1) {
      throw const FormatException(
        'Versi cadangan tidak dikenal versi aplikasi ini.',
      );
    }
    WalletKind walletKind(String raw) => WalletKind.values.firstWhere(
      (k) => k.name == raw,
      orElse: () => WalletKind.other,
    );
    TransactionKind txKind(String raw) => TransactionKind.values.firstWhere(
      (k) => k.name == raw,
      orElse: () => TransactionKind.expense,
    );
    try {
      return BackupData(
        wallets: [
          for (final w in root['wallets'] as List)
            Wallet(
              id: w['id'] as int,
              name: w['name'] as String,
              kind: walletKind(w['kind'] as String),
              openingBalance: w['openingBalance'] as int,
              archived: w['archived'] as bool,
            ),
        ],
        categories: [
          for (final c in root['categories'] as List)
            Category(
              id: c['id'] as int,
              name: c['name'] as String,
              kind: txKind(c['kind'] as String),
            ),
        ],
        budgets: [
          for (final b in root['budgets'] as List)
            Budget(
              id: b['id'] as int,
              categoryId: b['categoryId'] as int,
              monthlyLimit: b['monthlyLimit'] as int,
            ),
        ],
        transactions: [
          for (final t in root['transactions'] as List)
            Transaction(
              id: t['id'] as int,
              kind: txKind(t['kind'] as String),
              amount: t['amount'] as int,
              walletId: t['walletId'] as int,
              toWalletId: t['toWalletId'] as int?,
              categoryId: t['categoryId'] as int?,
              note: t['note'] as String,
              date: DateTime.parse(t['date'] as String),
            ),
        ],
      );
    } catch (_) {
      throw const FormatException('Isi cadangan tidak lengkap atau rusak.');
    }
  }
}
