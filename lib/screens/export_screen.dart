import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../theme/finaku_theme.dart';

/// Layar hasil ekspor: isi berkas ditampilkan apa adanya supaya
/// pengguna bisa memeriksa sebelum menyimpan, menyalin, atau
/// membagikannya. Tidak ada isi yang disembunyikan.
class ExportScreen extends StatelessWidget {
  const ExportScreen({
    super.key,
    required this.title,
    required this.fileName,
    required this.content,
    required this.mimeType,
  });

  final String title;
  final String fileName;
  final String content;
  final String mimeType;

  Future<void> _share() async {
    final bytes = Uint8List.fromList(utf8.encode(content));
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(bytes, name: fileName, mimeType: mimeType)],
        fileNameOverrides: [fileName],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: FinakuColors.paper,
        foregroundColor: FinakuColors.ink,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
            child: Text(
              'Nama berkas: $fileName. Ini isi lengkapnya, periksa '
              'dulu sebelum disimpan atau dibagikan.',
              style: const TextStyle(
                fontSize: 12,
                color: FinakuColors.inkMuted,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: FinakuColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  content,
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: content));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Isi berkas disalin.')),
                        );
                      }
                    },
                    icon: const Icon(Icons.copy_outlined, size: 18),
                    label: const Text('Salin isi'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _share,
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: const Text('Simpan berkas'),
                    style: FilledButton.styleFrom(
                      backgroundColor: FinakuColors.darkGreen,
                      minimumSize: const Size.fromHeight(44),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
