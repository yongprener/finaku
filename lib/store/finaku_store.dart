import 'package:flutter/foundation.dart' hide Category;

import '../data/models.dart';
import '../data/repository.dart';
import '../domain/balance.dart' as calc;

/// Keadaan aplikasi Finaku yang dibaca layar.
///
/// Menyimpan salinan data dari repositori dan memuat ulang setiap ada
/// perubahan. Saldo tidak disimpan di sini sebagai angka bebas: saldo
/// selalu dihitung dari dompet dan transaksi lewat fungsi di
/// domain/balance.dart.
class FinakuStore extends ChangeNotifier {
  FinakuStore(this._repo);

  final FinakuRepository _repo;

  List<Wallet> wallets = [];
  List<Category> categories = [];
  List<Transaction> transactions = [];
  bool loading = true;
  String? errorMessage;

  Future<void> load() async {
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _repo.seedIfEmpty();
      wallets = await _repo.wallets();
      categories = await _repo.categories();
      transactions = await _repo.transactions();
    } catch (e) {
      errorMessage = 'Data tidak bisa dimuat. $e';
    }
    loading = false;
    notifyListeners();
  }

  int balanceOf(Wallet wallet) => calc.walletBalance(wallet, transactions);

  int get totalBalance => calc.totalBalance(wallets, transactions);

  int monthly(TransactionKind kind, DateTime month) =>
      calc.monthlySum(transactions, kind, month);

  Wallet? walletById(int id) {
    for (final w in wallets) {
      if (w.id == id) return w;
    }
    return null;
  }

  Category? categoryById(int? id) {
    if (id == null) return null;
    for (final c in categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<void> addWallet({
    required String name,
    required WalletKind kind,
    required int openingBalance,
  }) async {
    await _repo.addWallet(
      name: name,
      kind: kind,
      openingBalance: openingBalance,
    );
    await load();
  }

  Future<void> addTransaction({
    required TransactionKind kind,
    required int amount,
    required int walletId,
    int? toWalletId,
    int? categoryId,
    required String note,
    required DateTime date,
  }) async {
    await _repo.addTransaction(
      kind: kind,
      amount: amount,
      walletId: walletId,
      toWalletId: toWalletId,
      categoryId: categoryId,
      note: note,
      date: date,
    );
    await load();
  }

  Future<void> deleteTransaction(int id) async {
    await _repo.deleteTransaction(id);
    await load();
  }
}
