import 'package:drift/drift.dart';

import 'connection.dart' as connection;

part 'database.g.dart';

/// Tabel dompet. Saldo awal disimpan di sini; saldo berjalan selalu
/// dihitung dari transaksi, tidak disimpan.
class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get kind => text()();
  IntColumn get openingBalance => integer()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

/// Tabel kategori. kind berisi income atau expense.
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get kind => text()();
}

/// Tabel transaksi. kind berisi income, expense, atau transfer.
/// toWalletId hanya terisi untuk transfer, categoryId hanya untuk
/// income dan expense.
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()();
  IntColumn get amount => integer()();
  IntColumn get walletId => integer()();
  IntColumn get toWalletId => integer().nullable()();
  IntColumn get categoryId => integer().nullable()();
  TextColumn get note => text()();
  DateTimeColumn get date => dateTime()();
}

/// Basis data lokal Finaku (SQLite lewat Drift).
@DriftDatabase(tables: [Wallets, Categories, Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connection.openConnection());

  /// Untuk pengujian: basis data di memori proses.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}
