import 'package:flutter/material.dart';

import 'data/models.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/budget_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/history_screen.dart';
import 'screens/report_screen.dart';
import 'store/finaku_store.dart';
import 'theme/finaku_theme.dart';

/// Rangka utama aplikasi: isi layar dan bar navigasi pil melayang
/// berwarna hijau tua, sesuai DESIGN.md.
///
/// Urutan bar: Dasbor, Riwayat, tombol tambah di tengah, Anggaran,
/// Laporan. Item aktif berwarna limau.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.store});

  final FinakuStore store;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  List<Widget> get _screens => [
    DashboardScreen(store: widget.store),
    HistoryScreen(store: widget.store),
    BudgetScreen(store: widget.store),
    ReportScreen(store: widget.store),
  ];

  void _openAdd() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddTransactionScreen(
          store: widget.store,
          initialKind: TransactionKind.expense,
        ),
      ),
    );
  }

  Widget _navItem({
    required int screenIndex,
    required IconData icon,
    required String label,
  }) {
    final active = _index == screenIndex;
    return InkWell(
      borderRadius: BorderRadius.circular(99),
      onTap: () => setState(() => _index = screenIndex),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: active ? FinakuColors.lime : FinakuColors.onDarkMuted,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                color: active ? FinakuColors.lime : FinakuColors.onDarkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _index, children: _screens),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
          child: Container(
            decoration: BoxDecoration(
              color: FinakuColors.darkGreen,
              borderRadius: BorderRadius.circular(99),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(
                  screenIndex: 0,
                  icon: Icons.dashboard_outlined,
                  label: 'Dasbor',
                ),
                _navItem(
                  screenIndex: 1,
                  icon: Icons.list_alt_outlined,
                  label: 'Riwayat',
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(99),
                  onTap: _openAdd,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: FinakuColors.lime,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: FinakuColors.darkGreen,
                      size: 26,
                    ),
                  ),
                ),
                _navItem(
                  screenIndex: 2,
                  icon: Icons.pie_chart_outline,
                  label: 'Anggaran',
                ),
                _navItem(
                  screenIndex: 3,
                  icon: Icons.bar_chart_outlined,
                  label: 'Laporan',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
