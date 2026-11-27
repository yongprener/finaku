import 'package:flutter/material.dart';

import '../data/models.dart';
import '../domain/format.dart';
import '../store/finaku_store.dart';
import '../theme/finaku_theme.dart';
import '../widgets/transaction_row.dart';

/// Riwayat transaksi: chip saringan di bawah judul, daftar
/// dikelompokkan per tanggal, dan ketuk baris untuk rincian + hapus.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.store});

  final FinakuStore store;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const _filters = ['Semua', 'Masuk', 'Keluar', 'Pindah'];
  static const _kinds = <TransactionKind?>[
    null,
    TransactionKind.income,
    TransactionKind.expense,
    TransactionKind.transfer,
  ];
  int _selected = 0;

  FinakuStore get store => widget.store;

  Future<void> _showDetail(Transaction tx) async {
    final category = store.categoryById(tx.categoryId);
    final wallet = store.walletById(tx.walletId);
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tx.note.isNotEmpty ? tx.note : (category?.name ?? 'Pindah dana'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text('Nominal: ${formatSignedAmount(tx.amount, tx.kind)}'),
            Text('Dompet: ${wallet?.name ?? ''}'),
            if (category != null) Text('Kategori: ${category.name}'),
            Text('Tanggal: ${dayLabel(tx.date, DateTime.now())}'),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.of(sheetContext).pop();
                await store.deleteTransaction(tx.id);
              },
              icon: const Icon(
                Icons.delete_outline,
                color: FinakuColors.expense,
              ),
              label: const Text(
                'Hapus transaksi',
                style: TextStyle(color: FinakuColors.expense),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final kind = _kinds[_selected];
        final filtered = store.transactions
            .where((t) => kind == null || t.kind == kind)
            .toList();
        final now = DateTime.now();
        final groups = <String, List<Transaction>>{};
        for (final t in filtered) {
          groups.putIfAbsent(dayLabel(t.date, now), () => []).add(t);
        }
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
            const SizedBox(height: 20),
            if (filtered.isEmpty) ...[
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
                'Transaksi yang kamu catat akan tampil di sini, '
                'terbaru di atas.',
                style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
              ),
            ] else
              for (final entry in groups.entries) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 2),
                  child: Text(
                    entry.key,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                for (final tx in entry.value)
                  InkWell(
                    onTap: () => _showDetail(tx),
                    child: TransactionRow(store: store, tx: tx),
                  ),
              ],
          ],
        );
      },
    );
  }
}
