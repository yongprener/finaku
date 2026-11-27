import 'package:flutter/material.dart';

import '../data/models.dart';
import '../domain/format.dart';
import '../store/finaku_store.dart';
import '../theme/finaku_theme.dart';

/// Daftar dompet beserta saldo hasil hitungan, dan pintu tambah dompet.
class WalletsScreen extends StatelessWidget {
  const WalletsScreen({super.key, required this.store});

  final FinakuStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dompet Saya'),
        backgroundColor: FinakuColors.paper,
        foregroundColor: FinakuColors.ink,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tambah dompet',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AddWalletScreen(store: store),
              ),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          if (store.wallets.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Belum ada dompet. Tambah dompet pertama dengan tombol '
                '+ di kanan atas.',
                style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            children: [
              for (final w in store.wallets)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: FinakuColors.surfaceMuted),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              w.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              w.kind.label,
                              style: const TextStyle(
                                fontSize: 11,
                                color: FinakuColors.inkMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formatRupiah(store.balanceOf(w)),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                'Saldo awal tercatat ${formatRupiah(store.wallets.fold(0, (s, w) => s + w.openingBalance))}. '
                'Saldo berjalan selalu dihitung dari transaksi, tidak diketik bebas.',
                style: const TextStyle(
                  fontSize: 11,
                  color: FinakuColors.inkMuted,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Formulir tambah dompet: nama, jenis, saldo awal saat ini.
class AddWalletScreen extends StatefulWidget {
  const AddWalletScreen({super.key, required this.store});

  final FinakuStore store;

  @override
  State<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  WalletKind _kind = WalletKind.cash;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final balance = parseAmount(_balanceController.text) ?? 0;
    if (name.isEmpty) {
      setState(() => _error = 'Nama dompet harus diisi.');
      return;
    }
    await widget.store.addWallet(
      name: name,
      kind: _kind,
      openingBalance: balance,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Dompet'),
        backgroundColor: FinakuColors.paper,
        foregroundColor: FinakuColors.ink,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama dompet',
              hintText: 'Misalnya Tunai, BCA, GoPay',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<WalletKind>(
            initialValue: _kind,
            decoration: const InputDecoration(
              labelText: 'Jenis',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final k in WalletKind.values)
                DropdownMenuItem(value: k, child: Text(k.label)),
            ],
            onChanged: (v) => setState(() => _kind = v ?? WalletKind.cash),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _balanceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Saldo awal saat ini (Rp)',
              hintText: '0',
              border: OutlineInputBorder(),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(
              _error!,
              style: const TextStyle(
                color: FinakuColors.expense,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              backgroundColor: FinakuColors.darkGreen,
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Simpan dompet'),
          ),
        ],
      ),
    );
  }
}
