import 'package:flutter/material.dart';

import '../data/models.dart';
import '../domain/format.dart';
import '../store/finaku_store.dart';
import '../theme/finaku_theme.dart';

/// Satu baris transaksi: lencana inisial kategori, judul, keterangan
/// dompet dan kategori, lalu nominal bertanda di kanan.
///
/// Dipakai dasbor dan riwayat supaya bentuknya selalu sama.
class TransactionRow extends StatelessWidget {
  const TransactionRow({super.key, required this.store, required this.tx});

  final FinakuStore store;
  final Transaction tx;

  @override
  Widget build(BuildContext context) {
    final category = store.categoryById(tx.categoryId);
    final wallet = store.walletById(tx.walletId);
    final isExpense = tx.kind == TransactionKind.expense;
    final isTransfer = tx.kind == TransactionKind.transfer;

    final String badge;
    final Color badgeBg;
    final Color badgeFg;
    if (isTransfer) {
      badge = 'PD';
      badgeBg = FinakuColors.surfaceMuted;
      badgeFg = FinakuColors.ink;
    } else if (category != null) {
      badge = category.initials;
      badgeBg = isExpense ? const Color(0xFFFBEAE7) : const Color(0xFFE2F0E6);
      badgeFg = isExpense ? FinakuColors.expense : FinakuColors.darkGreen;
    } else {
      badge = 'LN';
      badgeBg = FinakuColors.surfaceMuted;
      badgeFg = FinakuColors.ink;
    }

    final title = tx.note.isNotEmpty
        ? tx.note
        : (category?.name ?? (isTransfer ? 'Pindah dana' : 'Transaksi'));
    final subtitle = isTransfer
        ? '${wallet?.name ?? ''} ke ${store.walletById(tx.toWalletId ?? -1)?.name ?? ''}'
        : '${wallet?.name ?? ''} · ${category?.name ?? ''}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: badgeFg,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: FinakuColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatSignedAmount(tx.amount, tx.kind),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isExpense
                  ? FinakuColors.expense
                  : (isTransfer ? FinakuColors.ink : FinakuColors.darkGreen),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
