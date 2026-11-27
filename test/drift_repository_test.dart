import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finaku/data/database.dart';
import 'package:finaku/data/drift_repository.dart';
import 'package:finaku/data/models.dart';

void main() {
  test(
    'DriftRepository: isi awal, transaksi, dan anggaran tersimpan',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final repo = DriftRepository(db);

      await repo.seedIfEmpty();
      final wallets = await repo.wallets();
      final categories = await repo.categories();
      expect(wallets.single.name, 'Tunai');
      expect(categories.length, 11);

      final food = categories.firstWhere((c) => c.name == 'Makanan');
      await repo.addTransaction(
        kind: TransactionKind.expense,
        amount: 250000,
        walletId: wallets.single.id,
        categoryId: food.id,
        note: 'Belanja pasar',
        date: DateTime(2026, 11, 27),
      );
      final txs = await repo.transactions();
      expect(txs.single.amount, 250000);
      expect(txs.single.categoryId, food.id);

      await repo.setBudget(categoryId: food.id, monthlyLimit: 1000000);
      await repo.setBudget(categoryId: food.id, monthlyLimit: 1200000);
      final budgets = await repo.budgets();
      expect(budgets.single.monthlyLimit, 1200000);

      await db.close();
    },
  );
}
