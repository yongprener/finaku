import 'package:flutter/material.dart';

import '../data/models.dart';
import '../domain/format.dart';
import '../store/finaku_store.dart';
import '../theme/finaku_theme.dart';
import '../widgets/transaction_row.dart';
import 'add_transaction_screen.dart';
import 'wallets_screen.dart';

/// Dasbor Finaku.
///
/// Komposisi sesuai DESIGN.md: zona atas hijau tua menampung sapaan dan
/// saldo, lembar isi putih menimpanya. Semua angka dihitung dari data
/// nyata lewat FinakuStore; belum ada data berarti keadaan kosong yang
/// jujur, bukan angka contoh.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.store});

  final FinakuStore store;

  void _openAdd(BuildContext context, TransactionKind kind) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddTransactionScreen(store: store, initialKind: kind),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        if (store.loading) {
          return const Center(
            child: CircularProgressIndicator(color: FinakuColors.darkGreen),
          );
        }
        if (store.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(store.errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: store.load,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          );
        }
        final textTheme = Theme.of(context).textTheme;
        final now = DateTime.now();
        final income = store.monthly(TransactionKind.income, now);
        final expense = store.monthly(TransactionKind.expense, now);
        final recent = store.transactions.take(5).toList();
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: FinakuColors.darkGreen,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 38),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat datang,',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: FinakuColors.onDarkMuted,
                                ),
                              ),
                              Text(
                                'Bang Iyan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.wallet_outlined,
                            color: Colors.white,
                          ),
                          tooltip: 'Dompet saya',
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => WalletsScreen(store: store),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'SALDO TOTAL',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 0.4,
                        color: FinakuColors.onDarkMuted,
                      ),
                    ),
                    Text(
                      formatRupiah(store.totalBalance),
                      style: textTheme.displaySmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Bulan ini masuk ${formatRupiah(income)}, '
                      'keluar ${formatRupiah(expense)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: FinakuColors.onDarkMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () =>
                                _openAdd(context, TransactionKind.income),
                            style: FilledButton.styleFrom(
                              backgroundColor: FinakuColors.lime,
                              foregroundColor: FinakuColors.darkGreen,
                              shape: const StadiumBorder(),
                              minimumSize: const Size.fromHeight(44),
                            ),
                            child: const Text(
                              '+ Tambah uang',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                _openAdd(context, TransactionKind.expense),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white54),
                              shape: const StadiumBorder(),
                              minimumSize: const Size.fromHeight(44),
                            ),
                            child: const Text('Catat keluar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  decoration: const BoxDecoration(
                    color: FinakuColors.paper,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dompet saya', style: textTheme.titleSmall),
                      const SizedBox(height: 6),
                      if (store.wallets.isEmpty)
                        const Text(
                          'Belum ada dompet.',
                          style: TextStyle(
                            fontSize: 12,
                            color: FinakuColors.inkMuted,
                          ),
                        )
                      else
                        for (final w in store.wallets)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${w.name} · ${w.kind.label}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Text(
                                  formatRupiah(store.balanceOf(w)),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    fontFeatures: [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      const SizedBox(height: 18),
                      Text('Transaksi terakhir', style: textTheme.titleSmall),
                      const SizedBox(height: 6),
                      if (recent.isEmpty)
                        const Text(
                          'Belum ada transaksi. Catat transaksi pertama '
                          'dengan tombol tambah di bawah.',
                          style: TextStyle(
                            fontSize: 12,
                            color: FinakuColors.inkMuted,
                          ),
                        )
                      else
                        for (final tx in recent)
                          TransactionRow(store: store, tx: tx),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
