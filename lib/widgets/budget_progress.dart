import 'package:flutter/material.dart';

import '../data/models.dart';
import '../domain/budget.dart';
import '../domain/format.dart';
import '../store/finaku_store.dart';
import '../theme/finaku_theme.dart';

/// Kartu kemajuan satu anggaran: nama kategori, persen, batang
/// kemajuan, dan teks terpakai serta sisa.
///
/// Warna batang mengikuti keadaan: hijau limau gelap saat aman,
/// jingga tua saat 80 persen, merah bata saat terlampaui. Di atas
/// 100 persen batang berhenti di penuh, persennya tetap jujur.
class BudgetProgress extends StatelessWidget {
  const BudgetProgress({
    super.key,
    required this.store,
    required this.budget,
    required this.month,
  });

  final FinakuStore store;
  final Budget budget;
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final category = store.categoryById(budget.categoryId);
    final spent = store.spentFor(budget.categoryId, month);
    final percent = budgetPercent(spent, budget.monthlyLimit);
    final status = budgetStatus(spent, budget.monthlyLimit);
    final remaining = budgetRemaining(spent, budget.monthlyLimit);
    final barColor = switch (status) {
      BudgetStatus.safe => FinakuColors.limeOnWhite,
      BudgetStatus.warning => FinakuColors.warning,
      BudgetStatus.over => FinakuColors.expense,
    };
    final fraction = (percent / 100).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                category?.name ?? 'Kategori',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '$percent%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: barColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 7,
            backgroundColor: FinakuColors.surfaceMuted,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          remaining >= 0
              ? 'Terpakai ${formatRupiah(spent)} dari '
                    '${formatRupiah(budget.monthlyLimit)}, '
                    'sisa ${formatRupiah(remaining)}'
              : 'Terpakai ${formatRupiah(spent)} dari '
                    '${formatRupiah(budget.monthlyLimit)}, '
                    'lebih ${formatRupiah(-remaining)}',
          style: const TextStyle(fontSize: 11, color: FinakuColors.inkMuted),
        ),
      ],
    );
  }
}
