import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finaku/main.dart';

void main() {
  testWidgets('Dasbor tampil dengan saldo nol dan navigasi utama', (
    tester,
  ) async {
    await tester.pumpWidget(FinakuApp.forTesting());
    await tester.pumpAndSettle();

    expect(find.text('Rp 0'), findsWidgets);
    expect(find.text('Dasbor'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Laporan'), findsOneWidget);
    expect(find.text('Tunai · Tunai'), findsOneWidget);
  });

  testWidgets('Mencatat pemasukan mengubah saldo dasbor', (tester) async {
    await tester.pumpWidget(FinakuApp.forTesting());
    await tester.pumpAndSettle();

    await tester.tap(find.text('+ Tambah uang'));
    await tester.pumpAndSettle();
    expect(find.text('Catat Transaksi'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '1500000');
    await tester.tap(find.text('Simpan transaksi'));
    await tester.pumpAndSettle();

    expect(find.text('Rp 1.500.000'), findsWidgets);
  });

  testWidgets('Riwayat menampilkan transaksi yang dicatat', (tester) async {
    await tester.pumpWidget(FinakuApp.forTesting());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Catat keluar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '50000');
    await tester.tap(find.text('Simpan transaksi'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Riwayat'));
    await tester.pumpAndSettle();
    expect(find.text('-Rp 50.000'), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);
  });

  budgetTests();
}

void budgetTests() {
  testWidgets('Membuat anggaran lalu mencatat pengeluaran menampilkannya', (
    tester,
  ) async {
    await tester.pumpWidget(FinakuApp.forTesting());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Anggaran'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada anggaran.'), findsOneWidget);

    await tester.tap(find.byTooltip('Tambah anggaran'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '1000000');
    await tester.tap(find.text('Simpan anggaran'));
    await tester.pumpAndSettle();
    expect(
      find.text('Terpakai Rp 0 dari Rp 1.000.000, sisa Rp 1.000.000'),
      findsOneWidget,
    );

    await tester.tap(find.text('Dasbor'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Catat keluar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '250000');
    await tester.tap(find.text('Simpan transaksi'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Anggaran'));
    await tester.pumpAndSettle();
    expect(
      find.text('Terpakai Rp 250.000 dari Rp 1.000.000, sisa Rp 750.000'),
      findsOneWidget,
    );
    expect(find.text('25%'), findsOneWidget);
  });
}
