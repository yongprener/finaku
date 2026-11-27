import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finaku/data/backup.dart';
import 'package:finaku/data/models.dart';
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
  reportTests();
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

void reportTests() {
  testWidgets('Laporan menampilkan ringkasan dan ekspor CSV', (tester) async {
    await tester.pumpWidget(FinakuApp.forTesting());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Catat keluar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '250000');
    await tester.tap(find.text('Simpan transaksi'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Laporan'));
    await tester.pumpAndSettle();
    expect(find.text('Pengeluaran per kategori, bulan ini'), findsOneWidget);
    expect(find.text('Rp 250.000 · 100%'), findsOneWidget);
    expect(find.text('Enam bulan terakhir'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Ekspor CSV'), 200);
    await tester.tap(find.text('Ekspor CSV'));
    await tester.pumpAndSettle();
    expect(find.textContaining('tanggal;jenis;dompet'), findsOneWidget);
    expect(find.textContaining('pengeluaran'), findsWidgets);
  });

  testWidgets('Pulihkan cadangan lewat tempel JSON mengganti data', (
    tester,
  ) async {
    await tester.pumpWidget(FinakuApp.forTesting());
    await tester.pumpAndSettle();

    final backup = BackupData(
      wallets: const [
        Wallet(
          id: 1,
          name: 'Tunai',
          kind: WalletKind.cash,
          openingBalance: 500000,
          archived: false,
        ),
      ],
      categories: const [
        Category(id: 1, name: 'Gaji', kind: TransactionKind.income),
      ],
      budgets: const [],
      transactions: const [],
    );

    await tester.tap(find.text('Laporan'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Pulihkan cadangan'), 200);
    await tester.tap(find.text('Pulihkan cadangan'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, backup.encode());
    await tester.tap(find.text('Periksa isi cadangan'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Isi cadangan sah: 1 dompet'), findsOneWidget);

    await tester.tap(find.text('Pulihkan dan ganti semua data'));
    await tester.pumpAndSettle();
    expect(find.text('Ganti semua data?'), findsOneWidget);
    await tester.tap(find.text('Ya, pulihkan'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dasbor'));
    await tester.pumpAndSettle();
    expect(find.text('Rp 500.000'), findsWidgets);
  });
}
