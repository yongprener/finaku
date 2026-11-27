import 'package:flutter_test/flutter_test.dart';

import 'package:finaku/data/models.dart';
import 'package:finaku/domain/balance.dart';
import 'package:finaku/domain/format.dart';

Wallet wallet(int id, int opening) => Wallet(
  id: id,
  name: 'Dompet $id',
  kind: WalletKind.cash,
  openingBalance: opening,
  archived: false,
);

Transaction tx(
  int id,
  TransactionKind kind,
  int amount,
  int walletId, {
  int? toWalletId,
  DateTime? date,
}) => Transaction(
  id: id,
  kind: kind,
  amount: amount,
  walletId: walletId,
  toWalletId: toWalletId,
  categoryId: null,
  note: '',
  date: date ?? DateTime(2026, 11, 5),
);

void main() {
  group('walletBalance', () {
    test('saldo awal ditambah pemasukan dan dikurangi pengeluaran', () {
      final w = wallet(1, 100000);
      final result = walletBalance(w, [
        tx(1, TransactionKind.income, 50000, 1),
        tx(2, TransactionKind.expense, 30000, 1),
        tx(3, TransactionKind.expense, 999999, 2),
      ]);
      expect(result, 120000);
    });

    test('pindah dana mengurangi asal dan menambah tujuan', () {
      final a = wallet(1, 200000);
      final b = wallet(2, 0);
      final moves = [tx(1, TransactionKind.transfer, 75000, 1, toWalletId: 2)];
      expect(walletBalance(a, moves), 125000);
      expect(walletBalance(b, moves), 75000);
    });
  });

  group('totalBalance', () {
    test('pindah dana tidak mengubah saldo total', () {
      final wallets = [wallet(1, 200000), wallet(2, 50000)];
      final before = totalBalance(wallets, const []);
      final after = totalBalance(wallets, [
        tx(1, TransactionKind.transfer, 75000, 1, toWalletId: 2),
      ]);
      expect(before, 250000);
      expect(after, before);
    });

    test('dompet terarsip tidak ikut saldo total', () {
      const archived = Wallet(
        id: 3,
        name: 'Lama',
        kind: WalletKind.bank,
        openingBalance: 999000,
        archived: true,
      );
      expect(totalBalance([wallet(1, 1000), archived], const []), 1000);
    });
  });

  group('monthlySum', () {
    test('hanya bulan yang sama dan pindah dana tidak dihitung', () {
      final list = [
        tx(1, TransactionKind.income, 100000, 1, date: DateTime(2026, 11, 2)),
        tx(2, TransactionKind.income, 50000, 1, date: DateTime(2026, 10, 2)),
        tx(
          3,
          TransactionKind.transfer,
          70000,
          1,
          toWalletId: 2,
          date: DateTime(2026, 11, 3),
        ),
      ];
      expect(
        monthlySum(list, TransactionKind.income, DateTime(2026, 11)),
        100000,
      );
      expect(monthlySum(list, TransactionKind.transfer, DateTime(2026, 11)), 0);
    });
  });

  group('format dan parse', () {
    test('formatRupiah memakai pemisah ribuan titik', () {
      expect(formatRupiah(4250000), 'Rp 4.250.000');
      expect(formatRupiah(0), 'Rp 0');
      expect(formatRupiah(-50000), '-Rp 50.000');
    });

    test('parseAmount mengambil digit saja', () {
      expect(parseAmount('1.500.000'), 1500000);
      expect(parseAmount('1500000'), 1500000);
      expect(parseAmount(''), isNull);
      expect(parseAmount('abc'), isNull);
    });
  });
}
