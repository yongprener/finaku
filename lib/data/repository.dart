import 'models.dart';

/// Kontrak lapisan data Finaku.
///
/// Layar hanya bicara dengan kontrak ini, bukan dengan basis data
/// langsung. Penerapan utamanya memakai SQLite lewat Drift; penerapan
/// di memori dipakai untuk pengujian.
abstract interface class FinakuRepository {
  /// Mengisi data awal pada pemakaian pertama: kategori bawaan dari
  /// docs/konsep.md dan satu dompet Tunai. Tidak menimpa data yang
  /// sudah ada.
  Future<void> seedIfEmpty();

  Future<List<Wallet>> wallets({bool includeArchived = false});
  Future<List<Category>> categories();
  Future<List<Transaction>> transactions();

  Future<int> addWallet({
    required String name,
    required WalletKind kind,
    required int openingBalance,
  });

  Future<void> archiveWallet(int id);

  Future<int> addTransaction({
    required TransactionKind kind,
    required int amount,
    required int walletId,
    int? toWalletId,
    int? categoryId,
    required String note,
    required DateTime date,
  });

  Future<void> deleteTransaction(int id);

  Future<List<Budget>> budgets();

  /// Menyimpan anggaran satu kategori. Satu kategori hanya punya satu
  /// anggaran: bila sudah ada, batasnya diperbarui.
  Future<void> setBudget({required int categoryId, required int monthlyLimit});

  Future<void> deleteBudget(int id);
}

/// Kategori bawaan dari docs/konsep.md.
const defaultIncomeCategories = ['Gaji', 'Usaha', 'Lainnya'];
const defaultExpenseCategories = [
  'Makanan',
  'Transportasi',
  'Belanja',
  'Tagihan',
  'Kesehatan',
  'Hiburan',
  'Pendidikan',
  'Lainnya',
];
