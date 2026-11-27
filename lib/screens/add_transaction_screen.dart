import 'package:flutter/material.dart';

import '../data/models.dart';
import '../domain/format.dart';
import '../store/finaku_store.dart';
import '../theme/finaku_theme.dart';

/// Formulir catat transaksi: pemasukan, pengeluaran, atau pindah dana.
///
/// Semua pilihan berasal dari data nyata pengguna (dompet dan kategori
/// miliknya). Simpan hanya aktif maknanya setelah nominal, dompet, dan
/// kategori valid; kesalahan ditampilkan sebagai teks, bukan ditebak.
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({
    super.key,
    required this.store,
    required this.initialKind,
  });

  final FinakuStore store;
  final TransactionKind initialKind;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late TransactionKind _kind = widget.initialKind;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  int? _walletId;
  int? _toWalletId;
  int? _categoryId;
  DateTime _date = DateTime.now();
  String? _error;
  bool _saving = false;

  FinakuStore get store => widget.store;

  @override
  void initState() {
    super.initState();
    if (store.wallets.isNotEmpty) {
      _walletId = store.wallets.first.id;
      if (store.wallets.length > 1) _toWalletId = store.wallets[1].id;
    }
    _resetCategory();
  }

  void _resetCategory() {
    final cats = store.categories.where((c) => c.kind == _kind).toList();
    _categoryId = cats.isEmpty ? null : cats.first.id;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final amount = parseAmount(_amountController.text);
    String? error;
    if (amount == null || amount <= 0) {
      error = 'Nominal harus lebih dari 0.';
    } else if (_walletId == null) {
      error = 'Pilih dompet dulu.';
    } else if (_kind == TransactionKind.transfer) {
      if (_toWalletId == null) {
        error = 'Pilih dompet tujuan.';
      } else if (_toWalletId == _walletId) {
        error = 'Dompet tujuan harus berbeda dari dompet asal.';
      }
    } else if (_categoryId == null) {
      error = 'Pilih kategori dulu.';
    }
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    await store.addTransaction(
      kind: _kind,
      amount: amount!,
      walletId: _walletId!,
      toWalletId: _kind == TransactionKind.transfer ? _toWalletId : null,
      categoryId: _kind == TransactionKind.transfer ? null : _categoryId,
      note: _noteController.text.trim(),
      date: _date,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isTransfer = _kind == TransactionKind.transfer;
    final categories = store.categories.where((c) => c.kind == _kind).toList();
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
              setState(() {
                _kind = selection.first;
                _resetCategory();
              });
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
            decoration: const InputDecoration(
              labelText: 'Nominal (Rp)',
              hintText: '0',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _walletId,
            decoration: InputDecoration(
              labelText: isTransfer ? 'Dari dompet' : 'Dompet',
              border: const OutlineInputBorder(),
            ),
            items: [
              for (final w in store.wallets)
                DropdownMenuItem(value: w.id, child: Text(w.name)),
            ],
            onChanged: (v) => setState(() => _walletId = v),
          ),
          if (isTransfer) ...[
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _toWalletId,
              decoration: const InputDecoration(
                labelText: 'Ke dompet',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final w in store.wallets)
                  DropdownMenuItem(value: w.id, child: Text(w.name)),
              ],
              onChanged: (v) => setState(() => _toWalletId = v),
            ),
          ] else ...[
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _categoryId,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final c in categories)
                  DropdownMenuItem(value: c.id, child: Text(c.name)),
              ],
              onChanged: (v) => setState(() => _categoryId = v),
            ),
          ],
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            label: Text(dayLabel(_date, DateTime.now())),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              alignment: Alignment.centerLeft,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Catatan (boleh kosong)',
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
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              backgroundColor: FinakuColors.darkGreen,
              minimumSize: const Size.fromHeight(48),
            ),
            child: Text(_saving ? 'Menyimpan...' : 'Simpan transaksi'),
          ),
        ],
      ),
    );
  }
}
