import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'data/database.dart';
import 'data/drift_repository.dart';
import 'data/memory_repository.dart';
import 'store/finaku_store.dart';
import 'theme/finaku_theme.dart';

/// Titik masuk Finaku.
///
/// Aplikasi memakai basis data lokal SQLite lewat Drift. Store dibuat
/// sekali di sini dan dibagikan ke semua layar.
void main() {
  // BANGUN UJI SEMENTARA: basis data SQLite dimatikan untuk mengisolasi
  // penyebab aplikasi tertutup seketika di Samsung A04s. Data memakai
  // repositori memori dan TIDAK tersimpan antar sesi. Kembalikan ke
  // DriftRepository(AppDatabase()) setelah penyebabnya ketemu.
  final store = FinakuStore(MemoryRepository());
  store.load();
  runApp(FinakuApp(store: store));
}

class FinakuApp extends StatelessWidget {
  const FinakuApp({super.key, required this.store});

  final FinakuStore store;

  /// Untuk pengujian: store di memori dengan data awal bawaan.
  factory FinakuApp.forTesting() {
    final store = FinakuStore(MemoryRepository());
    store.load();
    return FinakuApp(store: store);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finaku',
      debugShowCheckedModeBanner: false,
      theme: buildFinakuTheme(),
      home: AppShell(store: store),
    );
  }
}
