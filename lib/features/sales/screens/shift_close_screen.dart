import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/hifi.dart';
import '../../../core/utils/money.dart';
import '../../../data/database.dart';
import '../../../data/repositories/receipt_repository.dart';
import '../../../data/repositories/shift_repository.dart';
import '../../../services/api_client.dart';
import '../widgets/x_report_sheet.dart';
import 'returns_screen.dart';

/// Section 03 — shift close / Z-report screen.
///
/// Left pane: header, 4×2 KPI grid, transaction log table, expected cash.
/// Right pane: 5×2 action tile grid + Cancel + "Закрыть смену + Z-отчёт".
class ShiftCloseScreen extends StatefulWidget {
  final ApiClient api;
  final String shiftId;
  final String cashierName;
  final ShiftRepository? shiftRepository;
  final ReceiptRepository? receiptRepository;

  const ShiftCloseScreen({
    super.key,
    required this.api,
    required this.shiftId,
    required this.cashierName,
    this.shiftRepository,
    this.receiptRepository,
  });

  @override
  State<ShiftCloseScreen> createState() => _ShiftCloseScreenState();
}

class _ShiftCloseScreenState extends State<ShiftCloseScreen> {
  Map<String, dynamic>? _shift;
  bool _loading = true;
  bool _closing = false;

  ShiftRepository? _resolveShiftRepo() {
    if (widget.shiftRepository != null) return widget.shiftRepository;
    try {
      return context.read<ShiftRepository?>();
    } catch (_) {
      return null;
    }
  }

  ReceiptRepository? _resolveReceiptRepo() {
    if (widget.receiptRepository != null) return widget.receiptRepository;
    try {
      return context.read<ReceiptRepository?>();
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  static String _fmtTime(DateTime dt) {
    final local = dt.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static String _paymentLabel(ReceiptRow r) {
    if (r.debtAmountTiyin > 0) return 'Credit';
    final hasCash = r.cashAmountTiyin > 0;
    final hasCard = r.cardAmountTiyin > 0;
    final hasQr = r.qrAmountTiyin > 0;
    final count = (hasCash ? 1 : 0) + (hasCard ? 1 : 0) + (hasQr ? 1 : 0);
    if (count > 1) return 'Mixed';
    if (hasCard) return 'Card';
    if (hasQr) return 'QR';
    return 'Cash';
  }

  Future<void> _load() async {
    try {
      final shiftRepo = _resolveShiftRepo();
      if (shiftRepo != null) {
        final row = await shiftRepo.getById(widget.shiftId) ??
            await shiftRepo.findLatestOpen();
        if (row != null) {
          final receiptRepo = _resolveReceiptRepo();
          final receipts = receiptRepo != null
              ? await receiptRepo.recentInShift(row.id, limit: 500)
              : const <ReceiptRow>[];
          var totalDiscount = 0;
          final mappedReceipts = <Map<String, dynamic>>[];
          for (final r in receipts) {
            if (!r.isReturn) {
              totalDiscount += r.discountAmountTiyin;
            }
            mappedReceipts.add({
              'ID': r.id,
              'Time': _fmtTime(r.createdAt),
              'Type': r.isReturn ? 'Return' : (r.debtAmountTiyin > 0 ? 'Credit Sale' : 'Sale'),
              'ReceiptNumber': r.receiptNumber,
              'PaymentType': _paymentLabel(r),
              'Total': r.totalAmountTiyin,
            });
          }
          if (!mounted) return;
          setState(() {
            _shift = {
              'ID': row.id,
              'ShiftNumber': row.shiftNumber,
              'OpenedAt': row.openedAt.toIso8601String(),
              'CashStart': row.cashStartTiyin,
              'TotalSales': row.totalSalesTiyin,
              'TotalCash': row.totalCashTiyin,
              'TotalCard': row.totalCardTiyin,
              'TotalQR': row.totalQrTiyin,
              'TotalReturns': row.totalReturnsTiyin,
              'TotalDeposits': row.totalDepositsTiyin,
              'TotalWithdrawals': row.totalWithdrawalsTiyin,
              'TotalDiscount': totalDiscount,
              'ReceiptCount': row.receiptCount,
              'OpenDebts': row.totalDebtTiyin > 0 ? 1 : 0,
              'ParkedCount': 0,
              'Receipts': mappedReceipts,
            };
            _loading = false;
          });
          return;
        }
      }

      final s = await widget.api.getCurrentShift('');
      if (!mounted) return;
      setState(() {
        _shift = s;
        _loading = false;
      });
    } on Exception {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _closeShift() async {
    if (_closing) return;
    setState(() => _closing = true);
    try {
      final shiftRepo = _resolveShiftRepo();
      if (shiftRepo != null) {
        final s = _shift ?? {};
        final cashStart = (s['CashStart'] as num?)?.toInt() ?? 0;
        final cash = (s['TotalCash'] as num?)?.toInt() ?? 0;
        final returns = (s['TotalReturns'] as num?)?.toInt() ?? 0;
        final deposits = (s['TotalDeposits'] as num?)?.toInt() ?? 0;
        final withdrawals = (s['TotalWithdrawals'] as num?)?.toInt() ?? 0;
        final expected = cashStart + cash + deposits - withdrawals - returns;
        await shiftRepo.close(
          widget.shiftId,
          cashEndTiyin: expected < 0 ? 0 : expected,
        );
      } else {
        await widget.api.closeShift(shiftId: widget.shiftId);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shift closed, Z-Report generated')),
      );
      Navigator.of(context).pop(true);
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _closing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Hifi.canvas,
      body: Column(children: [
        // Push-routed full-screen flow — outside _MainShell, so this screen
        // renders its own chrome with a back button. The shell's chrome
        // covers in-shell pages only (POS / shift / products / etc.).
        HifiChrome(
          leading: BackButton(color: Colors.white, onPressed: () => Navigator.of(context).maybePop()),
          shiftNumber: _shift == null ? 'Shift' : 'Shift #${_shift!['ShiftNumber'] ?? '—'}',
          cashierName: widget.cashierName,
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Row(children: [
                  Expanded(child: _leftPane()),
                  _rightPanel(),
                ]),
        ),
      ]),
    );
  }

  Widget _leftPane() {
    final s = _shift ?? {};
    final sales = (s['TotalSales'] as num?)?.toInt() ?? 0;
    final cash = (s['TotalCash'] as num?)?.toInt() ?? 0;
    final card = (s['TotalCard'] as num?)?.toInt() ?? 0;
    final qr = (s['TotalQR'] as num?)?.toInt() ?? 0;
    final returns = (s['TotalReturns'] as num?)?.toInt() ?? 0;
    final discount = (s['TotalDiscount'] as num?)?.toInt() ?? 0;
    final parked = (s['ParkedCount'] as num?)?.toInt() ?? 0;
    final openedDebts = (s['OpenDebts'] as num?)?.toInt() ?? 0;
    final receiptCount = (s['ReceiptCount'] as num?)?.toInt() ?? 0;
    final cashStart = (s['CashStart'] as num?)?.toInt() ?? 0;
    final expected = cashStart + cash - returns;

    final kpis = <List<dynamic>>[
      ['Shift Sales', '$receiptCount', Hifi.chrome],
      ['Turnover', Money.formatTenge(sales), Hifi.chrome],
      ['Cash', Money.formatTenge(cash), Hifi.success],
      ['Card / QR', Money.formatTenge(card + qr), Hifi.success],
      ['Returns', '−${Money.formatTenge(returns)}', Hifi.danger],
      ['Discounts', '−${Money.formatTenge(discount)}', Hifi.warn],
      ['Held Bills', '$parked', const Color(0xFF837B6D)],
      ['Open Credit', '$openedDebts', Hifi.warn],
    ];

    return Container(
      color: Hifi.paneBg,
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        HifiSectionHeader(
          icon: '🔒',
          title: 'Z-Report · Close Shift',
          subtitle: _shiftTiming(s),
        ),
        const SizedBox(height: 10),
        // KPI grid 4×2
        GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 2.4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [for (final k in kpis) _kpi(k[0] as String, k[1] as String, k[2] as Color)],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: _transactionsTable((s['Receipts'] as List<dynamic>?) ?? const <dynamic>[]),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('Expected in drawer', style: Hifi.ui(size: 11, color: const Color(0xFF837B6D))),
            Text(Money.formatTenge(expected), style: Hifi.mono(size: 28, weight: FontWeight.w700, color: Hifi.chrome)),
          ]),
        ),
      ]),
    );
  }

  String _shiftTiming(Map<String, dynamic> s) {
    String? fmt(String? iso) {
      if (iso == null) return null;
      try {
        final d = DateTime.parse(iso).toLocal();
        String p(int n) => n.toString().padLeft(2, '0');
        return '${p(d.hour)}:${p(d.minute)}';
      } on FormatException {
        return null;
      }
    }

    final opened = fmt(s['OpenedAt'] as String?);
    if (opened == null) return 'Shift open';
    final now = DateTime.now();
    final openedAt = DateTime.tryParse(s['OpenedAt'] as String? ?? '');
    String dur = '';
    if (openedAt != null) {
      final diff = now.difference(openedAt);
      dur = ' · ${diff.inHours}h ${diff.inMinutes.remainder(60)}m';
    }
    return 'Opened $opened · closing now$dur';
  }

  Widget _kpi(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Hifi.tableHead,
        border: Border.all(color: Hifi.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(label.toUpperCase(), style: Hifi.ui(size: 10, color: const Color(0xFF837B6D)).copyWith(letterSpacing: 0.5)),
        const SizedBox(height: 2),
        Text(value, style: Hifi.mono(size: 16, weight: FontWeight.w700, color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    );
  }

  Widget _transactionsTable(List<dynamic> receipts) {
    if (receipts.isEmpty) {
      return Container(
        decoration: BoxDecoration(border: Border.all(color: Hifi.border), borderRadius: BorderRadius.circular(4)),
        child: Center(
          child: Text('No transactions in this shift', style: Hifi.ui(size: 13, color: const Color(0xFFA59C8B))),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Hifi.border), borderRadius: BorderRadius.circular(4)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Column(children: [
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: Hifi.tableHead,
              border: Border(bottom: BorderSide(color: Hifi.border)),
            ),
            child: Row(children: [
              SizedBox(width: 80, child: _th('TIME')),
              Expanded(child: _th('TRANSACTION')),
              SizedBox(width: 90, child: _th('RECEIPT #')),
              SizedBox(width: 100, child: _th('METHOD')),
              SizedBox(width: 110, child: _th('AMOUNT', align: TextAlign.right)),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: receipts.length,
              itemBuilder: (context, i) {
                final r = receipts[i] as Map<String, dynamic>;
                final kind = (r['Type'] as String?) ?? 'Sale';
                final amount = (r['Total'] as num?)?.toInt() ?? 0;
                final lower = kind.toLowerCase();
                final isRefund = lower.contains('return') || lower.contains('возврат');
                final isDebt = lower.contains('credit') || lower.contains('долг');
                final color = isRefund ? Hifi.danger : (isDebt ? Hifi.warn : const Color(0xFF322E28));
                final amtStr = isRefund ? '−${Money.formatTenge(amount.abs())}' : Money.formatTenge(amount);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Hifi.divider))),
                  child: Row(children: [
                    SizedBox(width: 80, child: Text((r['Time'] as String?) ?? '--:--', style: Hifi.mono(size: 12, color: color))),
                    Expanded(child: Text(kind, style: Hifi.ui(size: 12, color: color))),
                    SizedBox(width: 90, child: Text((r['ReceiptNumber'] ?? '').toString(), style: Hifi.mono(size: 12, color: color))),
                    SizedBox(width: 100, child: Text((r['PaymentType'] as String?) ?? '—', style: Hifi.ui(size: 12, color: color))),
                    SizedBox(width: 110, child: Text(amtStr, textAlign: TextAlign.right, style: Hifi.mono(size: 12, weight: FontWeight.w600, color: color))),
                  ]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _th(String label, {TextAlign align = TextAlign.left}) => Text(label,
      textAlign: align, style: Hifi.ui(size: 11, weight: FontWeight.w600, color: const Color(0xFF645E52)).copyWith(letterSpacing: 0.3));

  Widget _rightPanel() {
    final tiles = <ActionTile>[
      ActionTile(
        label: 'Print X-Report',
        hotkey: 'F7',
        onTap: () => XReportSheet.show(
          context,
          api: widget.api,
          shiftId: widget.shiftId,
          cashierName: widget.cashierName,
        ),
      ),
      ActionTile(label: 'Recount', hotkey: 'F3', onTap: () => _todo('Cash recount')),
      ActionTile(label: 'Cash Drop', onTap: () => _todo('Cash collection')),
      ActionTile(label: 'Journal', hotkey: 'F4', onTap: () => _todo('Transaction journal')),
      ActionTile(
        label: 'Returns',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ReturnsScreen(api: widget.api, cashierName: widget.cashierName),
          ),
        ),
      ),
      ActionTile(label: 'Held Bills', onTap: () => _todo('Held bills')),
      ActionTile(label: 'Export .csv', onTap: () => _todo('Export CSV')),
      ActionTile(label: 'Email Report', onTap: () => _todo('Email report')),
      ActionTile(label: 'Fiscal Report', onTap: () => _todo('Fiscal report')),
      ActionTile(label: 'Break', onTap: () => _todo('Break')),
    ];
    return ActionGridPanel(
      tiles: tiles,
      voidTile: ActionTile(
        label: 'Cancel',
        variant: HifiTileVariant.red,
        hotkey: 'Esc',
        onTap: () => Navigator.of(context).maybePop(),
      ),
      payTile: ActionTile(
        label: _closing ? 'Closing…' : 'Close Shift + Z-Report',
        hotkey: 'F2',
        variant: HifiTileVariant.pay,
        onTap: _closing ? null : _closeShift,
        fontSize: 16,
      ),
    );
  }

  void _todo(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — coming soon'), duration: const Duration(seconds: 2)),
    );
  }
}
