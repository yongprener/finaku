import 'package:flutter/material.dart';

import '../domain/format.dart';
import '../domain/report.dart';
import '../store/finaku_store.dart';
import '../theme/finaku_theme.dart';
import 'export_screen.dart';
import 'restore_screen.dart';

const _monthShort = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// Laporan Finaku dari data asli pengguna.
///
/// Pola dari riset referensi: daftar adalah tulang punggungnya, batang
/// hanya membantu membandingkan, dan bila data belum ada grafik tidak
/// ditampilkan melainkan dijelaskan alasannya.
class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key, required this.store});

  final FinakuStore store;

  Future<void> _openCsv(BuildContext context) async {
    final csv = buildCsv(
      transactions: store.transactions,
      walletName: (id) => store.walletById(id)?.name ?? '',
      categoryName: (id) => store.categoryById(id)?.name ?? '',
    );
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExportScreen(
          title: 'Ekspor CSV',
          fileName: 'finaku-transaksi.csv',
          content: csv,
          mimeType: 'text/csv',
        ),
      ),
    );
  }

  Future<void> _openBackup(BuildContext context) async {
    final data = await store.snapshot();
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExportScreen(
          title: 'Cadangan JSON',
          fileName: 'finaku-cadangan.json',
          content: data.encode(),
          mimeType: 'application/json',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final now = DateTime.now();
        final byCategory = expenseByCategory(store.transactions, now);
        final months = monthlyTotals(store.transactions, now, 6);
        final maxExpense = months.fold(
          0,
          (m, e) => e.expense > m ? e.expense : m,
        );
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
          children: [
            Text('Laporan', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            const Text(
              'Pengeluaran per kategori dan per bulan.',
              style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
            ),
            const SizedBox(height: 20),
            Text(
              'Pengeluaran per kategori, bulan ini',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            if (store.transactions.isEmpty) ...[
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
                'Belum ada transaksi yang bisa diringkas. Setelah '
                'pencatatan berjalan, halaman ini menampilkan '
                'ringkasannya.',
                style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
              ),
            ] else if (byCategory.isEmpty)
              const Text(
                'Belum ada pengeluaran bulan ini.',
                style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
              )
            else
              for (final row in byCategory) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        store.categoryById(row.categoryId)?.name ?? '',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      '${formatRupiah(row.total)} · ${row.percent}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: row.percent / 100,
                    minHeight: 6,
                    backgroundColor: FinakuColors.surfaceMuted,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      FinakuColors.limeOnWhite,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            const SizedBox(height: 14),
            Text(
              'Enam bulan terakhir',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            if (store.transactions.isEmpty)
              const Text(
                'Belum ada data bulanan.',
                style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
              )
            else
              for (final m in months) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 74,
                      child: Text(
                        '${_monthShort[m.month.month - 1]} ${m.month.year}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: maxExpense == 0 ? 0 : m.expense / maxExpense,
                          minHeight: 6,
                          backgroundColor: FinakuColors.surfaceMuted,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            FinakuColors.expense,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      formatRupiah(m.expense),
                      style: const TextStyle(
                        fontSize: 11,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 74, top: 2, bottom: 8),
                  child: Text(
                    'Masuk ${formatRupiah(m.income)}, selisih '
                    '${formatRupiah(m.difference)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: FinakuColors.inkMuted,
                    ),
                  ),
                ),
              ],
            const SizedBox(height: 18),
            Text(
              'Ekspor dan cadangan',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            const Text(
              'CSV untuk dibuka di Excel. Cadangan JSON berisi seluruh '
              'data dan bisa dipulihkan kapan pun, termasuk di perangkat '
              'lain.',
              style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => _openCsv(context),
              icon: const Icon(Icons.table_chart_outlined, size: 18),
              label: const Text('Ekspor CSV'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _openBackup(context),
              icon: const Icon(Icons.backup_outlined, size: 18),
              label: const Text('Buat cadangan JSON'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => RestoreScreen(store: store),
                ),
              ),
              icon: const Icon(Icons.restore_outlined, size: 18),
              label: const Text('Pulihkan cadangan'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
            ),
          ],
        );
      },
    );
  }
}
