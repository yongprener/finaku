import 'package:drift/drift.dart';

import 'backup.dart';
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

  @override
  Future<List<m.Budget>> budgets() async {
    final rows = await _db.select(_db.budgets).get();
    return rows
        .map(
          (r) => m.Budget(
            id: r.id,
            categoryId: r.categoryId,
            monthlyLimit: r.monthlyLimit,
          ),
        )
        .toList();
  }

  @override
  Future<void> setBudget({
    required int categoryId,
    required int monthlyLimit,
  }) async {
    final existing = await (_db.select(
      _db.budgets,
    )..where((t) => t.categoryId.equals(categoryId))).getSingleOrNull();
    if (existing != null) {
      await (_db.update(_db.budgets)..where((t) => t.id.equals(existing.id)))
          .write(BudgetsCompanion(monthlyLimit: Value(monthlyLimit)));
    } else {
      await _db
          .into(_db.budgets)
          .insert(
            BudgetsCompanion.insert(
              categoryId: categoryId,
              monthlyLimit: monthlyLimit,
            ),
          );
    }
  }

  @override
  Future<void> deleteBudget(int id) async {
    await (_db.delete(_db.budgets)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<BackupData> snapshot() async => BackupData(
    wallets: await wallets(includeArchived: true),
    categories: await categories(),
    budgets: await budgets(),
    transactions: await transactions(),
  );

  @override
  Future<void> restoreSnapshot(BackupData data) async {
    await _db.transaction(() async {
      await _db.delete(_db.transactions).go();
      await _db.delete(_db.budgets).go();
      await _db.delete(_db.categories).go();
      await _db.delete(_db.wallets).go();
      for (final w in data.wallets) {
        await _db
            .into(_db.wallets)
            .insert(
              WalletsCompanion.insert(
                id: Value(w.id),
                name: w.name,
                kind: w.kind.name,
                openingBalance: w.openingBalance,
                archived: Value(w.archived),
              ),
            );
      }
      for (final c in data.categories) {
        await _db
            .into(_db.categories)
            .insert(
              CategoriesCompanion.insert(
                id: Value(c.id),
                name: c.name,
                kind: c.kind.name,
              ),
            );
      }
      for (final b in data.budgets) {
        await _db
            .into(_db.budgets)
            .insert(
              BudgetsCompanion.insert(
                id: Value(b.id),
                categoryId: b.categoryId,
                monthlyLimit: b.monthlyLimit,
              ),
            );
      }
      for (final t in data.transactions) {
        await _db
            .into(_db.transactions)
            .insert(
              TransactionsCompanion.insert(
                id: Value(t.id),
                kind: t.kind.name,
                amount: t.amount,
                walletId: t.walletId,
                toWalletId: Value(t.toWalletId),
                categoryId: Value(t.categoryId),
                note: t.note,
                date: t.date,
              ),
            );
      }
    });
  }
}
