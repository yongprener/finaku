import 'package:flutter/material.dart';

import '../theme/finaku_theme.dart';

/// Jenis transaksi sesuai model data di docs/konsep.md.
enum TransactionKind { income, expense, transfer }

/// Layar catat transaksi.
///
/// Tahap kerangka: pilihan jenisnya sudah berfungsi, formulir lengkapnya
/// (nominal, dompet, kategori, tanggal) dibangun pada tahap data, dan
/// layar ini menyatakannya secara terbuka kepada pengguna.
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, required this.initialKind});

  final TransactionKind initialKind;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late TransactionKind _kind = widget.initialKind;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catat Transaksi'),
        backgroundColor: FinakuColors.paper,
        foregroundColor: FinakuColors.ink,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          SegmentedButton<TransactionKind>(
            segments: const [
              ButtonSegment(
                value: TransactionKind.income,
                label: Text('Pemasukan'),
              ),
              ButtonSegment(
                value: TransactionKind.expense,
                label: Text('Pengeluaran'),
              ),
              ButtonSegment(
                value: TransactionKind.transfer,
                label: Text('Pindah'),
              ),
            ],
            selected: {_kind},
            onSelectionChanged: (selection) {
              setState(() => _kind = selection.first);
            },
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FinakuColors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Ini kerangka aplikasi. Formulir pencatatan lengkap, dengan '
              'nominal, dompet, kategori, dan tanggal, dibangun pada tahap '
              'berikutnya bersama basis data lokalnya. Belum ada data yang '
              'tersimpan dari layar ini.',
              style: TextStyle(fontSize: 13, color: FinakuColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}
