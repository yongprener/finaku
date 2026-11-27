import 'models.dart';
import 'repository.dart';

/// Penerapan repositori di memori, untuk pengujian dan pratinjau.
/// Data hilang saat aplikasi ditutup; ini bukan penyimpanan utama.
class MemoryRepository implements FinakuRepository {
  final List<Wallet> _wallets = [];
  final List<Category> _categories = [];
  final List<Transaction> _transactions = [];
  int _nextId = 1;

  @override
  Future<void> seedIfEmpty() async {
    if (_wallets.isNotEmpty || _categories.isNotEmpty) return;
    for (final name in defaultIncomeCategories) {
      _categories.add(
        Category(id: _nextId++, name: name, kind: TransactionKind.income),
      );
    }
    for (final name in defaultExpenseCategories) {
      _categories.add(
        Category(id: _nextId++, name: name, kind: TransactionKind.expense),
      );
    }
    await addWallet(name: 'Tunai', kind: WalletKind.cash, openingBalance: 0);
  }

  @override
  Future<List<Wallet>> wallets({bool includeArchived = false}) async {
    return _wallets.where((w) => includeArchived || !w.archived).toList();
  }

  @override
  Future<List<Category>> categories() async => List.of(_categories);

  @override
  Future<List<Transaction>> transactions() async {
    final list = List.of(_transactions);
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<int> addWallet({
    required String name,
    required WalletKind kind,
    required int openingBalance,
  }) async {
    final id = _nextId++;
    _wallets.add(
      Wallet(
        id: id,
        name: name,
        kind: kind,
        openingBalance: openingBalance,
        archived: false,
      ),
    );
    return id;
  }

  @override
  Future<void> archiveWallet(int id) async {
    final i = _wallets.indexWhere((w) => w.id == id);
    if (i < 0) return;
    final w = _wallets[i];
    _wallets[i] = Wallet(
      id: w.id,
      name: w.name,
      kind: w.kind,
      openingBalance: w.openingBalance,
      archived: true,
    );
  }

  @override
  Future<int> addTransaction({
    required TransactionKind kind,
    required int amount,
    required int walletId,
    int? toWalletId,
    int? categoryId,
    required String note,
    required DateTime date,
  }) async {
    final id = _nextId++;
    _transactions.add(
      Transaction(
        id: id,
        kind: kind,
        amount: amount,
        walletId: walletId,
        toWalletId: toWalletId,
        categoryId: categoryId,
        note: note,
        date: date,
      ),
    );
    return id;
  }

  @override
  Future<void> deleteTransaction(int id) async {
    _transactions.removeWhere((t) => t.id == id);
  }
}
