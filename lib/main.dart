import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'theme/finaku_theme.dart';

/// Titik masuk Finaku.
///
/// Tahap saat ini adalah kerangka: tema resmi, navigasi utama, dan
/// keadaan kosong tiap layar. Lapisan data (basis data lokal SQLite)
/// dibangun pada tahap berikutnya sesuai docs/konsep.md.
void main() {
  runApp(const FinakuApp());
}

class FinakuApp extends StatelessWidget {
  const FinakuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finaku',
      debugShowCheckedModeBanner: false,
      theme: buildFinakuTheme(),
      home: const AppShell(),
    );
  }
}
