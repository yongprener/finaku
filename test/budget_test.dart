import 'package:flutter_test/flutter_test.dart';

import 'package:finaku/data/models.dart';
import 'package:finaku/domain/budget.dart';

Transaction expense(int id, int categoryId, int amount, DateTime date) =>
    Transaction(
      id: id,
      kind: TransactionKind.expense,
      amount: amount,
      walletId: 1,
      toWalletId: null,
      categoryId: categoryId,
      note: '',
      date: date,
    );

void main() {
  group('spentInCategory', () {
    test('hanya kategori dan bulan yang sama yang dihitung', () {
      final list = [
        expense(1, 5, 100000, DateTime(2026, 11, 3)),
        expense(2, 5, 50000, DateTime(2026, 11, 20)),
        expense(3, 5, 999000, DateTime(2026, 10, 20)),
        expense(4, 6, 777000, DateTime(2026, 11, 5)),
      ];
      expect(spentInCategory(list, 5, DateTime(2026, 11)), 150000);
    });
  });

  group('budgetPercent dan budgetStatus', () {
    test('persen dibulatkan ke bawah', () {
      expect(budgetPercent(620000, 1000000), 62);
      expect(budgetPercent(1, 3), 33);
      expect(budgetPercent(0, 1000000), 0);
    });

    test('ambang 80 persen waspada dan 100 persen terlampaui', () {
      expect(budgetStatus(799999, 1000000), BudgetStatus.safe);
      expect(budgetStatus(800000, 1000000), BudgetStatus.warning);
      expect(budgetStatus(999999, 1000000), BudgetStatus.warning);
      expect(budgetStatus(1000000, 1000000), BudgetStatus.over);
      expect(budgetStatus(1200000, 1000000), BudgetStatus.over);
    });

    test('sisa bisa negatif bila terlampaui', () {
      expect(budgetRemaining(1200000, 1000000), -200000);
      expect(budgetRemaining(400000, 1000000), 600000);
    });
  });
}
