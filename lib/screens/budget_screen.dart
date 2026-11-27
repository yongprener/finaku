import 'package:flutter/material.dart';

import '../theme/finaku_theme.dart';

/// Anggaran bulanan per kategori. Keadaan kosong pada tahap kerangka.
class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      children: [
        Text('Anggaran', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        const Text(
          'Batas bulanan per kategori pengeluaran.',
          style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
        ),
        const SizedBox(height: 28),
        const Text(
          'Belum ada anggaran.',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: FinakuColors.ink,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Anggaran dibuat per kategori, misalnya Makanan atau '
          'Transportasi, dan kemajuannya tampil sebagai batang sederhana '
          'di sini dan di dasbor.',
          style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
        ),
      ],
    );
  }
}
