import 'package:flutter/material.dart';

import '../theme/finaku_theme.dart';

/// Laporan sederhana.
///
/// Mengikuti pola dari riset referensi (Mindful Money): bila data belum
/// cukup, grafik tidak ditampilkan dan alasannya dijelaskan, bukan
/// menampilkan grafik kosong yang membingungkan.
class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      children: [
        Text('Laporan', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        const Text(
          'Pengeluaran per kategori dan per bulan.',
          style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
        ),
        const SizedBox(height: 28),
        const Text(
          'Laporan belum bisa dibuat.',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: FinakuColors.ink,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Belum ada transaksi yang bisa diringkas. Setelah pencatatan '
          'berjalan, halaman ini menampilkan ringkasannya dan tombol '
          'ekspor CSV.',
          style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
        ),
      ],
    );
  }
}
