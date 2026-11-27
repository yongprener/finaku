import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../data/backup.dart';
import '../store/finaku_store.dart';
import '../theme/finaku_theme.dart';

/// Layar pulihkan cadangan.
///
/// Pengguna memilih berkas JSON atau menempel isinya, melihat
/// ringkasannya, dan wajib menegaskan dulu karena pemulihan mengganti
/// seluruh data saat ini.
class RestoreScreen extends StatefulWidget {
  const RestoreScreen({super.key, required this.store});

  final FinakuStore store;

  @override
  State<RestoreScreen> createState() => _RestoreScreenState();
}

class _RestoreScreenState extends State<RestoreScreen> {
  final _controller = TextEditingController();
  BackupData? _parsed;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (files.isEmpty) return;
    try {
      _controller.text = await files.single.xFile.readAsString();
    } catch (_) {
      setState(() => _error = 'Berkas tidak bisa dibaca.');
      return;
    }
    _parse();
  }

  void _parse() {
    try {
      final data = BackupData.decode(_controller.text);
      setState(() {
        _parsed = data;
        _error = null;
      });
    } on FormatException catch (e) {
      setState(() {
        _parsed = null;
        _error = e.message;
      });
    }
  }

  Future<void> _restore() async {
    final data = _parsed!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ganti semua data?'),
        content: Text(
          'Pemulihan ini menghapus data Finaku saat ini dan '
          'menggantinya dengan isi cadangan: ${data.wallets.length} '
          'dompet, ${data.transactions.length} transaksi, '
          '${data.budgets.length} anggaran. Tindakan ini tidak bisa '
          'dibatalkan dari dalam aplikasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: FinakuColors.expense,
            ),
            child: const Text('Ya, pulihkan'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.store.restoreSnapshot(data);
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadangan berhasil dipulihkan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pulihkan Cadangan'),
        backgroundColor: FinakuColors.paper,
        foregroundColor: FinakuColors.ink,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          const Text(
            'Pilih berkas cadangan JSON Finaku, atau tempel isinya di '
            'kotak bawah. Data saat ini akan diganti seluruhnya setelah '
            'kamu menegaskan.',
            style: TextStyle(fontSize: 12, color: FinakuColors.inkMuted),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.folder_open_outlined, size: 18),
            label: const Text('Pilih berkas JSON'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _controller,
            maxLines: 8,
            style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
            decoration: const InputDecoration(
              labelText: 'Isi cadangan JSON',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) {
              if (_parsed != null) setState(() => _parsed = null);
            },
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _parse,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
            ),
            child: const Text('Periksa isi cadangan'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: const TextStyle(
                color: FinakuColors.expense,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          if (_parsed != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: FinakuColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Isi cadangan sah: ${_parsed!.wallets.length} dompet, '
                '${_parsed!.categories.length} kategori, '
                '${_parsed!.budgets.length} anggaran, '
                '${_parsed!.transactions.length} transaksi.',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: _restore,
              style: FilledButton.styleFrom(
                backgroundColor: FinakuColors.expense,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Pulihkan dan ganti semua data'),
            ),
          ],
        ],
      ),
    );
  }
}
