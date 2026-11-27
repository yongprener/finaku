import 'package:drift/drift.dart';

import 'database.dart';
import 'models.dart' as m;
import 'repository.dart';

m.WalletKind _walletKind(String raw) => m.WalletKind.values.firstWhere(
  (k) => k.name == raw,
  orElse: () => m.WalletKind.other,
);

m.TransactionKind _txKind(String raw) => m.TransactionKind.values.firstWhere(
  (k) => k.name == raw,
  orElse: () => m.TransactionKind.expense,
);

/// Penerapan repositori Finaku di atas SQLite (Drift).
class DriftRepository implements FinakuRepository {
  DriftRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> seedIfEmpty() async {
    final existing = await _db.select(_db.categories).get();
    if (existing.isNotEmpty) return;
    await _db.transaction(() async {
      for (final name in defaultIncomeCategories) {
        await _db
            .into(_db.categories)
            .insert(
              CategoriesCompanion.insert(
                name: name,
                kind: m.TransactionKind.income.name,
              ),
            );
      }
      for (final name in defaultExpenseCategories) {
        await _db
            .into(_db.categories)
            .insert(
              CategoriesCompanion.insert(
                name: name,
                kind: m.TransactionKind.expense.name,
              ),
            );
      }
      final walletRows = await _db.select(_db.wallets).get();
      if (walletRows.isEmpty) {
        await _db
            .into(_db.wallets)
            .insert(
              WalletsCompanion.insert(
                name: 'Tunai',
                kind: m.WalletKind.cash.name,
                openingBalance: 0,
              ),
            );
      }
    });
  }

  @override
  Future<List<m.Wallet>> wallets({bool includeArchived = false}) async {
    final query = _db.select(_db.wallets);
    if (!includeArchived) {
      query.where((t) => t.archived.equals(false));
    }
    final rows = await query.get();
    return rows
        .map(
          (r) => m.Wallet(
            id: r.id,
            name: r.name,
            kind: _walletKind(r.kind),
            openingBalance: r.openingBalance,
            archived: r.archived,
          ),
        )
        .toList();
  }

  @override
  Future<List<m.Category>> categories() async {
    final rows = await _db.select(_db.categories).get();
    return rows
        .map((r) => m.Category(id: r.id, name: r.name, kind: _txKind(r.kind)))
        .toList();
  }

  @override
  Future<List<m.Transaction>> transactions() async {
    final query = _db.select(_db.transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    final rows = await query.get();
    return rows
        .map(
          (r) => m.Transaction(
            id: r.id,
            kind: _txKind(r.kind),
            amount: r.amount,
            walletId: r.walletId,
            toWalletId: r.toWalletId,
            categoryId: r.categoryId,
            note: r.note,
            date: r.date,
          ),
        )
        .toList();
  }

  @override
  Future<int> addWallet({
    required String name,
    required m.WalletKind kind,
    required int openingBalance,
  }) {
    return _db
        .into(_db.wallets)
        .insert(
          WalletsCompanion.insert(
            name: name,
            kind: kind.name,
            openingBalance: openingBalance,
          ),
        );
  }

  @override
  Future<void> archiveWallet(int id) async {
    await (_db.update(_db.wallets)..where((t) => t.id.equals(id))).write(
      const WalletsCompanion(archived: Value(true)),
    );
  }

  @override
  Future<int> addTransaction({
    required m.TransactionKind kind,
    required int amount,
    required int walletId,
    int? toWalletId,
    int? categoryId,
    required String note,
    required DateTime date,
  }) {
    return _db
        .into(_db.transactions)
        .insert(
          TransactionsCompanion.insert(
            kind: kind.name,
            amount: amount,
            walletId: walletId,
            toWalletId: Value(toWalletId),
            categoryId: Value(categoryId),
            note: note,
            date: date,
          ),
        );
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }
}
