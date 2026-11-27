import 'package:flutter/material.dart';

import '../theme/finaku_theme.dart';

/// Riwayat transaksi.
///
/// Pola dari riset referensi: chip saringan di bawah judul dan daftar
/// dikelompokkan per tanggal. Chip-nya berfungsi sebagai pemilih keadaan;
/// pada tahap kerangka datanya memang masih kosong untuk semua saringan.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const _filters = ['Semua', 'Masuk', 'Keluar', 'Pindah'];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      children: [
        Text('Riwayat', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        const Text(
          'Semua transaksi, dikelompokkan per tanggal.',
          style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          children: [
            for (var i = 0; i < _filters.length; i++)
              ChoiceChip(
                label: Text(_filters[i]),
                selected: _selected == i,
                onSelected: (_) => setState(() => _selected = i),
                selectedColor: FinakuColors.darkGreen,
                labelStyle: TextStyle(
                  color: _selected == i
                      ? FinakuColors.lime
                      : FinakuColors.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                backgroundColor: FinakuColors.surfaceMuted,
                side: BorderSide.none,
              ),
          ],
        ),
        const SizedBox(height: 28),
        const Text(
          'Belum ada transaksi.',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: FinakuColors.ink,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Transaksi yang kamu catat akan tampil di sini, terbaru di atas.',
          style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
        ),
      ],
    );
  }
}
