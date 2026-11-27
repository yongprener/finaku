import 'package:flutter_test/flutter_test.dart';

import 'package:finaku/data/backup.dart';
import 'package:finaku/data/models.dart';
import 'package:finaku/domain/report.dart';

Transaction tx(
  int id,
  TransactionKind kind,
  int amount, {
  int? categoryId,
  int walletId = 1,
  int? toWalletId,
  String note = '',
  required DateTime date,
}) => Transaction(
  id: id,
  kind: kind,
  amount: amount,
  walletId: walletId,
  toWalletId: toWalletId,
  categoryId: categoryId,
  note: note,
  date: date,
);

void main() {
  group('expenseByCategory', () {
    test('mengurutkan terbesar dulu dan menghitung persen', () {
      final list = [
        tx(
          1,
          TransactionKind.expense,
          300000,
          categoryId: 5,
          date: DateTime(2026, 11, 2),
        ),
        tx(
          2,
          TransactionKind.expense,
          100000,
          categoryId: 6,
          date: DateTime(2026, 11, 3),
        ),
        tx(
          3,
          TransactionKind.expense,
          999000,
          categoryId: 5,
          date: DateTime(2026, 10, 3),
        ),
        tx(
          4,
          TransactionKind.income,
          5000000,
          categoryId: 1,
          date: DateTime(2026, 11, 1),
        ),
      ];
      final result = expenseByCategory(list, DateTime(2026, 11));
      expect(result.length, 2);
      expect(result.first.categoryId, 5);
      expect(result.first.total, 300000);
      expect(result.first.percent, 75);
      expect(result.last.percent, 25);
    });
  });

  group('monthlyTotals', () {
    test('enam bulan termasuk bulan berjalan, pindah tidak dihitung', () {
      final list = [
        tx(1, TransactionKind.income, 5000000, date: DateTime(2026, 11, 1)),
        tx(2, TransactionKind.expense, 1000000, date: DateTime(2026, 11, 9)),
        tx(
          3,
          TransactionKind.transfer,
          500000,
          toWalletId: 2,
          date: DateTime(2026, 11, 9),
        ),
        tx(4, TransactionKind.expense, 200000, date: DateTime(2026, 6, 9)),
      ];
      final result = monthlyTotals(list, DateTime(2026, 11, 27), 6);
      expect(result.length, 6);
      expect(result.first.month.month, 6);
      expect(result.first.expense, 200000);
      expect(result.last.income, 5000000);
      expect(result.last.expense, 1000000);
      expect(result.last.difference, 4000000);
    });
  });

  group('buildCsv', () {
    test('header titik koma dan baris terurut dari yang terlama', () {
      final csv = buildCsv(
        transactions: [
          tx(
            2,
            TransactionKind.expense,
            50000,
            categoryId: 5,
            note: 'Belanja; pasar',
            date: DateTime(2026, 11, 3),
          ),
          tx(
            1,
            TransactionKind.income,
            5000000,
            categoryId: 1,
            note: 'Gaji',
            date: DateTime(2026, 11, 1),
          ),
        ],
        walletName: (id) => 'Tunai',
        categoryName: (id) => id == 5 ? 'Makanan' : 'Gaji',
      );
      final lines = csv.split('\n');
      expect(
        lines.first,
        'tanggal;jenis;dompet;dompet_tujuan;kategori;catatan;nominal',
      );
      expect(lines[1], '2026-11-01;pemasukan;Tunai;;Gaji;Gaji;5000000');
      expect(
        lines[2],
        '2026-11-03;pengeluaran;Tunai;;Makanan;"Belanja; pasar";50000',
      );
    });
  });

  group('BackupData', () {
    test('encode lalu decode menghasilkan data yang sama', () {
      final data = BackupData(
        wallets: const [
          Wallet(
            id: 1,
            name: 'Tunai',
            kind: WalletKind.cash,
            openingBalance: 100000,
            archived: false,
          ),
        ],
        categories: const [
          Category(id: 5, name: 'Makanan', kind: TransactionKind.expense),
        ],
        budgets: const [Budget(id: 1, categoryId: 5, monthlyLimit: 1000000)],
        transactions: [
          tx(
            1,
            TransactionKind.expense,
            50000,
            categoryId: 5,
            note: 'Pasar',
            date: DateTime(2026, 11, 3),
          ),
        ],
      );
      final restored = BackupData.decode(data.encode());
      expect(restored.wallets.single.openingBalance, 100000);
      expect(restored.budgets.single.monthlyLimit, 1000000);
      expect(restored.transactions.single.note, 'Pasar');
      expect(restored.transactions.single.date, DateTime(2026, 11, 3));
    });

    test('decode menolak berkas yang bukan cadangan Finaku', () {
      expect(
        () => BackupData.decode('{"app":"lain","version":1}'),
        throwsFormatException,
      );
      expect(() => BackupData.decode('bukan json'), throwsFormatException);
    });
  });
}
