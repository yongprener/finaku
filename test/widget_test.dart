import 'package:flutter_test/flutter_test.dart';

import 'package:finaku/main.dart';

void main() {
  testWidgets('Dasbor tampil dengan saldo dan navigasi utama', (tester) async {
    await tester.pumpWidget(const FinakuApp());

    expect(find.text('Rp 0'), findsOneWidget);
    expect(find.text('Dasbor'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Anggaran'), findsWidgets);
    expect(find.text('Laporan'), findsOneWidget);
    expect(find.text('Belum ada transaksi. Catat transaksi pertama dengan '
        'tombol tambah di bawah.'), findsOneWidget);
  });

  testWidgets('Ketuk Riwayat membuka layar riwayat kosong', (tester) async {
    await tester.pumpWidget(const FinakuApp());

    await tester.tap(find.text('Riwayat'));
    await tester.pumpAndSettle();

    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Pindah'), findsOneWidget);
    expect(find.text('Belum ada transaksi.'), findsOneWidget);
  });

  testWidgets('Tombol tambah membuka layar catat transaksi', (tester) async {
    await tester.pumpWidget(const FinakuApp());

    await tester.tap(find.text('+ Tambah uang'));
    await tester.pumpAndSettle();

    expect(find.text('Catat Transaksi'), findsOneWidget);
    expect(find.text('Pemasukan'), findsOneWidget);
    expect(find.text('Pengeluaran'), findsOneWidget);
  });
}
