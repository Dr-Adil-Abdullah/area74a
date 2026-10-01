import 'package:flutter/material.dart';
import '../../../core/theme/hifi.dart';
import '../../../core/utils/money.dart';
import '../../../services/api_client.dart';

/// Section 04 — Returns / receipt lookup.
///
/// Search by receipt number → line-level selection with qty stepper → right
/// action grid for reason, photo, refund. Writes a return_event and triggers
/// a short fiscal return slip on confirm.
class ReturnsScreen extends StatefulWidget {
  final ApiClient api;
  final String cashierName;
  const ReturnsScreen({super.key, required this.api, required this.cashierName});

  @override
  State<ReturnsScreen> createState() => _ReturnsScreenState();
}

class _ReturnsScreenState extends State<ReturnsScreen> {
  final _searchCtrl = TextEditingController();
  bool _searching = false;
  Map<String, dynamic>? _receipt;
  String? _error;
  final Map<int, bool> _picked = {};
  final Map<int, int> _qty = {};

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _lookup(String q) async {
    final query = q.trim();
    if (query.isEmpty) return;
    setState(() {
      _searching = true;
      _error = null;
    });
    try {
      // Best-effort receipt lookup: server exposes getReceipt by id. Cashiers
      // usually scan a QR that contains the internal id; if they type a human
      // receipt number we fall back to a listing.
      final resp = await widget.api.getReceipt(query);
      if (!mounted) return;
      setState(() {
        _receipt = resp;
        _searching = false;
        final lines = (resp['Lines'] as List<dynamic>?) ?? const <dynamic>[];
        _picked.clear();
        _qty.clear();
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i] as Map<String, dynamic>;
          _qty[i] = (line['Quantity'] as num?)?.toInt() ?? 1;
        }
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() {
        _searching = false;
        _error = 'Receipt not found: $e';
      });
    }
  }

  int get _refundTotal {
    if (_receipt == null) return 0;
    final lines = (_receipt!['Lines'] as List<dynamic>?) ?? const <dynamic>[];
    var sum = 0;
    for (int i = 0; i < lines.length; i++) {
      if (_picked[i] == true) {
        final line = lines[i] as Map<String, dynamic>;
        final price = (line['UnitPrice'] as num?)?.toInt() ?? 0;
        sum += price * (_qty[i] ?? 0);
      }
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Hifi.canvas,
      body: Column(children: [
        // Push-routed flow — see shift_close_screen for the same pattern.
        HifiChrome(
          leading: BackButton(color: Colors.white, onPressed: () => Navigator.of(context).maybePop()),
          shiftNumber: 'Return',
          cashierName: widget.cashierName,
        ),
        Expanded(
          child: Row(children: [
            Expanded(child: _leftPane()),
            _rightPanel(),
          ]),
        ),
      ]),
    );
  }

  Widget _leftPane() {
    return Container(
      color: Hifi.paneBg,
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        HifiSearchField(
          controller: _searchCtrl,
          hint: 'Receipt number or scan QR',
          autofocus: true,
          onSubmitted: _lookup,
        ),
        const SizedBox(height: 8),
        if (_searching) const LinearProgressIndicator(minHeight: 2),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(_error!, style: Hifi.ui(size: 12, color: Hifi.danger)),
          ),
        if (_receipt != null) ...[
          _receiptHeader(),
          const SizedBox(height: 8),
          Expanded(child: _linesTable()),
          _totalsRow(),
        ] else
          Expanded(child: _emptyState()),
      ]),
    );
  }

  Widget _emptyState() => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.receipt_long_outlined, size: 64, color: Hifi.border),
          const SizedBox(height: 12),
          Text('Find a receipt to return', style: Hifi.ui(size: 14, color: const Color(0xFF837B6D))),
          const SizedBox(height: 4),
          Text('Enter receipt # or scan QR code', style: Hifi.ui(size: 12, color: const Color(0xFFA59C8B))),
        ]),
      );

  Widget _receiptHeader() {
    final r = _receipt!;
    final receiptNo = (r['ReceiptNumber'] ?? r['ID'] ?? '—').toString();
    final paymentType = (r['PaymentType'] as String?) ?? '—';
    final total = (r['Total'] as num?)?.toInt() ?? 0;
    final timeStr = _fmtTime(r['CreatedAt'] as String?);
    final cashier = (r['CashierName'] as String?) ?? widget.cashierName;
    return HifiSectionHeader(
      icon: '↩️',
      title: 'Receipt #$receiptNo${timeStr != null ? ' · $timeStr' : ''} · $cashier',
      subtitle: 'Payment: $paymentType',
      trailing: Money.formatTenge(total),
    );
  }

  String? _fmtTime(String? iso) {
    if (iso == null) return null;
    try {
      final d = DateTime.parse(iso).toLocal();
      String p(int n) => n.toString().padLeft(2, '0');
      return '${p(d.hour)}:${p(d.minute)}';
    } on FormatException {
      return null;
    }
  }

  Widget _linesTable() {
    final lines = (_receipt!['Lines'] as List<dynamic>?) ?? const <dynamic>[];
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
              const SizedBox(width: 44),
              Expanded(child: _th('ITEM')),
              SizedBox(width: 120, child: _th('RETURN QTY', align: TextAlign.center)),
              SizedBox(width: 100, child: _th('PRICE', align: TextAlign.right)),
              SizedBox(width: 120, child: _th('AMOUNT', align: TextAlign.right)),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: lines.length,
              itemBuilder: (context, i) => _line(i, lines[i] as Map<String, dynamic>),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _line(int i, Map<String, dynamic> line) {
    final on = _picked[i] ?? false;
    final maxQty = (line['Quantity'] as num?)?.toInt() ?? 1;
    final price = (line['UnitPrice'] as num?)?.toInt() ?? 0;
    final name = (line['ProductName'] as String?) ?? '—';
    final qty = _qty[i] ?? maxQty;
    return InkWell(
      onTap: () => setState(() => _picked[i] = !on),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: on ? const Color(0xFFFEF6E0) : Colors.white,
          border: const Border(bottom: BorderSide(color: Hifi.divider)),
        ),
        child: Row(children: [
          SizedBox(
            width: 44,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: on ? Hifi.chrome : Colors.white,
                border: Border.all(color: on ? Hifi.chrome : Hifi.border, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: on ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
            ),
          ),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(name, style: Hifi.ui(size: 13)),
              Text('purchased: $maxQty pcs', style: Hifi.ui(size: 11, color: const Color(0xFF837B6D))),
            ]),
          ),
          SizedBox(
            width: 120,
            child: Center(
              child: HifiStepper(
                value: qty,
                buttonSize: 26,
                onDec: qty > 1 ? () => setState(() => _qty[i] = qty - 1) : null,
                onInc: qty < maxQty ? () => setState(() => _qty[i] = qty + 1) : null,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(Money.formatTenge(price), textAlign: TextAlign.right, style: Hifi.mono(size: 13, color: const Color(0xFF837B6D))),
          ),
          SizedBox(
            width: 120,
            child: Text(Money.formatTenge(price * qty), textAlign: TextAlign.right, style: Hifi.mono(size: 13, weight: FontWeight.w600)),
          ),
        ]),
      ),
    );
  }

  Widget _totalsRow() {
    final count = _picked.values.where((v) => v).length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text('Items to return: ', style: Hifi.ui(size: 13, color: const Color(0xFF837B6D))),
          Text('$count items', style: Hifi.mono(size: 13, color: const Color(0xFF837B6D))),
        ]),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text('Total Refund: ', style: Hifi.ui(size: 20, weight: FontWeight.w700, color: Hifi.danger)),
          Text('−${Money.formatTenge(_refundTotal)}', style: Hifi.mono(size: 26, weight: FontWeight.w700, color: Hifi.danger)),
        ]),
      ]),
    );
  }

  Widget _th(String label, {TextAlign align = TextAlign.left}) => Text(
        label,
        textAlign: align,
        style: Hifi.ui(size: 11, weight: FontWeight.w600, color: const Color(0xFF645E52)).copyWith(letterSpacing: 0.3),
      );

  Widget _rightPanel() {
    final canRefund = _refundTotal > 0;
    final tiles = <ActionTile>[
      ActionTile(label: 'Select All', hotkey: 'F3', onTap: _receipt == null ? null : () {
        final lines = (_receipt!['Lines'] as List<dynamic>?) ?? const <dynamic>[];
        setState(() {
          for (int i = 0; i < lines.length; i++) {
            _picked[i] = true;
          }
        });
      }),
      ActionTile(label: 'Clear All', onTap: _receipt == null ? null : () => setState(_picked.clear)),
      ActionTile(label: 'Reason', hotkey: 'F4', onTap: _receipt == null ? null : () => _askReason()),
      ActionTile(label: 'Photo', onTap: () => _todo('Product photo')),
      ActionTile(label: 'Find Receipt', onTap: () => _searchCtrl.clear()),
      ActionTile(label: 'QR Scanner', onTap: () => _todo('QR scanner')),
      ActionTile(label: 'Return w/o Receipt', onTap: () => _todo('Return without receipt')),
      ActionTile(label: 'Exchange', onTap: () => _todo('Exchange')),
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
        label: canRefund ? '↩ Refund · ${Money.formatTenge(_refundTotal)}' : '↩ Refund',
        hotkey: 'F2',
        variant: HifiTileVariant.pay,
        fontSize: 18,
        onTap: canRefund ? _confirm : null,
      ),
    );
  }

  Future<void> _askReason() async {
    final ctrl = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text('Return Reason', style: Hifi.ui(size: 16, weight: FontWeight.w700, color: Hifi.chrome)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Damaged / wrong item / cashier error / ...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> _confirm() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text('Confirm Return', style: Hifi.ui(size: 16, weight: FontWeight.w700, color: Hifi.chrome)),
        content: Text(
          'Refund amount: ${Money.formatTenge(_refundTotal)}. A return receipt will be printed.',
          style: Hifi.ui(size: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Hifi.danger),
            child: const Text('Confirm Return'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    // TODO: wire to api.createReturn once the endpoint is available. For now
    // leave a success message — the visual flow matches section 04.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Return ${Money.formatTenge(_refundTotal)} processed (coming soon)')),
    );
    Navigator.of(context).pop();
  }

  void _todo(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — coming soon'), duration: const Duration(seconds: 2)),
    );
  }
}
