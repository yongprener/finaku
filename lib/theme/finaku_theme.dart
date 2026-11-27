import 'package:flutter/material.dart';

/// Warna resmi Finaku, sesuai DESIGN.md (tema Hijau Tua dan Limau).
///
/// Setiap warna punya peran tertulis di DESIGN.md. Jangan menambah warna
/// baru di layar tanpa mengubah dokumen itu lebih dulu.
abstract final class FinakuColors {
  /// Zona atas dasbor dan bar navigasi pil.
  static const Color darkGreen = Color(0xFF0A3D2C);

  /// Aksen utama, hanya di atas hijau tua.
  static const Color lime = Color(0xFFB9E33C);

  /// Turunan limau untuk batang kemajuan dan penanda aktif di area putih.
  static const Color limeOnWhite = Color(0xFF5E8C0A);

  /// Latar isi dan latar layar selain dasbor.
  static const Color paper = Color(0xFFFFFFFF);

  /// Jalur batang kemajuan, chip, dan pemisah halus.
  static const Color surfaceMuted = Color(0xFFEEF0EA);

  /// Teks utama di area putih.
  static const Color ink = Color(0xFF14231C);

  /// Teks sekunder di area putih.
  static const Color inkMuted = Color(0xFF5C665F);

  /// Teks sekunder di atas hijau tua.
  static const Color onDarkMuted = Color(0xFF9DB8AB);

  /// Semantis: pengeluaran.
  static const Color expense = Color(0xFFB42318);

  /// Semantis: peringatan anggaran.
  static const Color warning = Color(0xFF9A3412);
}

/// Tema aplikasi. Huruf Plus Jakarta Sans dipakai bila tersedia di
/// perangkat; bila tidak, sistem memakai huruf bawaan sebagai cadangan.
ThemeData buildFinakuTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: FinakuColors.darkGreen,
    primary: FinakuColors.darkGreen,
    surface: FinakuColors.paper,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: FinakuColors.paper,
    fontFamily: 'Plus Jakarta Sans',
    fontFamilyFallback: const ['Roboto', 'sans-serif'],
    textTheme: const TextTheme(
      // Saldo, satu satunya titik fokus dasbor.
      displaySmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: FinakuColors.ink,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: FinakuColors.ink,
      ),
      bodyMedium: TextStyle(fontSize: 13, color: FinakuColors.ink),
      bodySmall: TextStyle(fontSize: 11, color: FinakuColors.inkMuted),
    ),
  );
}
