/// Hitungan anggaran Finaku, fungsi murni yang bisa diuji.
///
/// Aturan dari docs/konsep.md: anggaran per kategori pengeluaran,
/// kemajuan bulan berjalan, penanda peringatan di 80 persen dan
/// terlampaui di 100 persen.
library;

import '../data/models.dart';

/// Total pengeluaran satu kategori pada bulan tertentu.
int spentInCategory(
  List<Transaction> transactions,
  int categoryId,
  DateTime month,
) {
  var sum = 0;
  for (final t in transactions) {
    if (t.kind == TransactionKind.expense &&
        t.categoryId == categoryId &&
        t.date.year == month.year &&
        t.date.month == month.month) {
      sum += t.amount;
    }
  }
  return sum;
}

/// Persen terpakai, dibulatkan ke bawah. Bisa melebihi 100.
int budgetPercent(int spent, int limit) {
  if (limit <= 0) return 0;
  return (spent * 100) ~/ limit;
}

/// Keadaan anggaran menurut persen terpakai.
enum BudgetStatus { safe, warning, over }

BudgetStatus budgetStatus(int spent, int limit) {
  final percent = budgetPercent(spent, limit);
  if (percent >= 100) return BudgetStatus.over;
  if (percent >= 80) return BudgetStatus.warning;
  return BudgetStatus.safe;
}

/// Sisa anggaran bulan ini. Negatif berarti terlampaui.
int budgetRemaining(int spent, int limit) => limit - spent;
