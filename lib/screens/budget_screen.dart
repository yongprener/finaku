import 'package:flutter/material.dart';

import '../data/models.dart';
import '../domain/format.dart';
import '../store/finaku_store.dart';
import '../theme/finaku_theme.dart';
import '../widgets/budget_progress.dart';

/// Anggaran bulanan per kategori pengeluaran.
///
/// Ketuk tombol tambah untuk membuat anggaran, ketuk satu anggaran
/// untuk mengubah batasnya atau menghapusnya.
class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key, required this.store});

  final FinakuStore store;

  void _openForm(BuildContext context, {Budget? existing}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BudgetFormScreen(store: store, existing: existing),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final month = DateTime.now();
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anggaran',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Batas bulanan per kategori pengeluaran.',
                        style: TextStyle(
                          fontSize: 12,
                          color: FinakuColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Tambah anggaran',
                  onPressed: () => _openForm(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (store.budgets.isEmpty) ...[
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
                'Buat anggaran pertama dengan tombol + di kanan atas, '
                'misalnya Makanan Rp 1.000.000 per bulan. Kemajuannya '
                'akan tampil di sini dan di dasbor.',
                style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
              ),
            ] else
              for (final b in store.budgets) ...[
                InkWell(
                  onTap: () => _openForm(context, existing: b),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: BudgetProgress(
                      store: store,
                      budget: b,
                      month: month,
                    ),
                  ),
                ),
                const Divider(color: FinakuColors.surfaceMuted, height: 8),
              ],
          ],
        );
      },
    );
  }
}

/// Formulir anggaran: pilih kategori pengeluaran dan batas bulanannya.
/// Dipakai untuk membuat baru dan mengubah yang sudah ada.
class BudgetFormScreen extends StatefulWidget {
  const BudgetFormScreen({super.key, required this.store, this.existing});

  final FinakuStore store;
  final Budget? existing;

  @override
  State<BudgetFormScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends State<BudgetFormScreen> {
  final _amountController = TextEditingController();
  int? _categoryId;
  String? _error;

  @override
  void initState() {
    super.initState();
    final expenseCats = widget.store.categories
        .where((c) => c.kind == TransactionKind.expense)
        .toList();
    _categoryId =
        widget.existing?.categoryId ??
        (expenseCats.isEmpty ? null : expenseCats.first.id);
    if (widget.existing != null) {
      _amountController.text = widget.existing!.monthlyLimit.toString();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final limit = parseAmount(_amountController.text);
    if (_categoryId == null) {
      setState(() => _error = 'Pilih kategori dulu.');
      return;
    }
    if (limit == null || limit <= 0) {
      setState(() => _error = 'Batas anggaran harus lebih dari 0.');
      return;
    }
    await widget.store.setBudget(categoryId: _categoryId!, monthlyLimit: limit);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    await widget.store.deleteBudget(widget.existing!.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final expenseCats = widget.store.categories
        .where((c) => c.kind == TransactionKind.expense)
        .toList();
    final editing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Ubah Anggaran' : 'Tambah Anggaran'),
        backgroundColor: FinakuColors.paper,
        foregroundColor: FinakuColors.ink,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          DropdownButtonFormField<int>(
            initialValue: _categoryId,
            decoration: const InputDecoration(
              labelText: 'Kategori pengeluaran',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final c in expenseCats)
                DropdownMenuItem(value: c.id, child: Text(c.name)),
            ],
            onChanged: editing ? null : (v) => setState(() => _categoryId = v),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Batas per bulan (Rp)',
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
            child: const Text('Simpan anggaran'),
          ),
          if (editing) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _delete,
              icon: const Icon(
                Icons.delete_outline,
                color: FinakuColors.expense,
              ),
              label: const Text(
                'Hapus anggaran',
                style: TextStyle(color: FinakuColors.expense),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
