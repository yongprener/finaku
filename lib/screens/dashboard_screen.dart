import 'package:flutter/material.dart';

import '../theme/finaku_theme.dart';
import 'add_transaction_screen.dart';

/// Dasbor Finaku.
///
/// Komposisi sesuai DESIGN.md: zona atas hijau tua menampung sapaan dan
/// saldo, lembar isi putih menimpanya. Pada tahap kerangka belum ada data,
/// jadi saldo Rp 0 dan lembar isi menampilkan keadaan kosong yang jujur.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _openAdd(BuildContext context, TransactionKind kind) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddTransactionScreen(initialKind: kind),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                const Text(
                  'Selamat datang,',
                  style: TextStyle(fontSize: 12, color: FinakuColors.onDarkMuted),
                ),
                const Text(
                  'Bang Iyan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'SALDO TOTAL',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.4,
                    color: FinakuColors.onDarkMuted,
                  ),
                ),
                Text('Rp 0', style: textTheme.displaySmall),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Anggaran bulan ini', style: textTheme.titleSmall),
                  const SizedBox(height: 6),
                  const Text(
                    'Belum ada anggaran. Anggaran per kategori dibuat '
                    'setelah dompet dan kategori tersedia.',
                    style: TextStyle(
                      fontSize: 12,
                      color: FinakuColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Transaksi terakhir', style: textTheme.titleSmall),
                  const SizedBox(height: 6),
                  const Text(
                    'Belum ada transaksi. Catat transaksi pertama dengan '
                    'tombol tambah di bawah.',
                    style: TextStyle(
                      fontSize: 12,
                      color: FinakuColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
