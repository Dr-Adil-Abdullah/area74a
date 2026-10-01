import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/hifi.dart';
import '../../../core/utils/money.dart';
import '../../../data/repositories/shift_repository.dart';
import '../../../services/api_client.dart';
import 'shift_close_screen.dart';

/// Hi-fi shift-open screen — section 02 in the design handoff.
class ShiftScreen extends StatefulWidget {
  final ApiClient api;
  final String cashierId;
  final String cashierName;
  final String? workstationId;
  final ShiftRepository? shiftRepository;
  final VoidCallback? onShiftChanged;
  final VoidCallback? onOpenPos;

  const ShiftScreen({
    super.key,
    required this.api,
    required this.cashierId,
    required this.cashierName,
    this.workstationId,
    this.shiftRepository,
    this.onShiftChanged,
    this.onOpenPos,
  });

  @override
  State<ShiftScreen> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  static const denoms = [5000, 1000, 500, 100, 50, 20, 10];

  Map<String, dynamic>? _shift;
  bool _loading = true;
  bool _submitting = false;
  final Map<int, int> _counts = {for (final d in denoms) d: 0};
  int _expected = 0;
  String _shiftNumber = '—';

  int get _totalTiyin => _counts.entries.fold(0, (s, e) => s + e.key * 100 * e.value);

  ShiftRepository? _resolveShiftRepo() {
    if (widget.shiftRepository != null) return widget.shiftRepository;
    try {
      return context.read<ShiftRepository?>();
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadShift();
  }

  Future<void> _loadShift() async {
    setState(() => _loading = true);
    try {
      final repo = _resolveShiftRepo();
      if (repo != null) {
        final openRow = await repo.findLatestOpen(
          userId: widget.cashierId.isEmpty ? null : widget.cashierId,
          workstationId: widget.workstationId,
        );
        if (!mounted) return;
        if (openRow != null) {
          final expectedCash = openRow.cashStartTiyin +
              openRow.totalCashTiyin +
              openRow.totalDepositsTiyin -
              openRow.totalWithdrawalsTiyin -
              openRow.totalReturnsTiyin;
          setState(() {
            _shift = {
              'ID': openRow.id,
              'ShiftNumber': openRow.shiftNumber,
              'ExpectedCash': expectedCash,
            };
            _shiftNumber = openRow.shiftNumber.toString();
            _expected = expectedCash;
            _loading = false;
          });
        } else {
          setState(() {
            _shift = null;
            _loading = false;
          });
        }
        return;
      }

      final resp = await widget.api.getCurrentShift(widget.cashierId);
      setState(() {
        _shift = resp;
        _shiftNumber = resp['ShiftNumber']?.toString() ?? '—';
        _expected = (resp['ExpectedCash'] as num?)?.toInt() ?? 0;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        setState(() {
          _shift = null;
          _loading = false;
        });
      }
    } on Exception catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      final repo = _resolveShiftRepo();
      if (repo != null) {
        final wsId = (widget.workstationId != null && widget.workstationId!.isNotEmpty)
            ? widget.workstationId!
            : 'ws-standalone';
        final userId = widget.cashierId.isEmpty ? 'owner' : widget.cashierId;
        final nextNum = await repo.nextShiftNumber(wsId);
        await repo.open(
          workstationId: wsId,
          userId: userId,
          shiftNumber: nextNum,
          cashStartTiyin: _totalTiyin,
        );
      } else {
        await widget.api.openShift(cashierId: widget.cashierId, cashStart: _totalTiyin);
      }
      if (mounted) {
        await _loadShift();
        widget.onShiftChanged?.call();
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Hifi.canvas,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          // Chrome is rendered by the shell (_MainShell._buildShellChrome);
          // ShiftScreen body fills the remainder.
          : (_shift == null ? _buildOpen(context) : _buildOpenedInfo(context)),
    );
  }

  Widget _buildOpen(BuildContext context) {
    return Row(children: [
      // LEFT pane
      Expanded(
        child: Container(
          color: Hifi.paneBg,
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            HifiSectionHeader(
              icon: '💼',
              title: 'Open Shift',
              subtitle: 'Count the cash in the drawer to start the shift',
              trailing: 'Cashier: ${widget.cashierName}',
            ),
            const SizedBox(height: 10),
            Expanded(child: _denomTable()),
            _deltaRow(),
          ]),
        ),
      ),
      // RIGHT pane (navy)
      _rightPane(context),
    ]);
  }

  Widget _buildOpenedInfo(BuildContext context) {
    final shiftId = _shift?['ID'] as String? ?? '';
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.check_circle_outline, size: 72, color: Hifi.success),
          const SizedBox(height: 16),
          Text('Shift #$_shiftNumber is currently open', style: Hifi.ui(size: 20, weight: FontWeight.w700, color: Hifi.chrome)),
          const SizedBox(height: 8),
          Text('Ring up sales on POS, or close the shift with a Z-Report.',
              style: Hifi.ui(size: 13, color: const Color(0xFF837B6D))),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              if (widget.onOpenPos != null) {
                widget.onOpenPos!();
              } else {
                Navigator.of(context).maybePop();
              }
            },
            icon: const Icon(Icons.point_of_sale),
            label: const Text('Go to POS'),
            style: FilledButton.styleFrom(backgroundColor: Hifi.chrome),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: shiftId.isEmpty
                ? null
                : () async {
                    final closed = await Navigator.of(context).push<bool>(
                      MaterialPageRoute<bool>(
                        builder: (_) => ShiftCloseScreen(
                          api: widget.api,
                          shiftId: shiftId,
                          cashierName: widget.cashierName,
                          shiftRepository: _resolveShiftRepo(),
                        ),
                      ),
                    );
                    if (closed == true && mounted) {
                      await _loadShift();
                      widget.onShiftChanged?.call();
                    }
                  },
            icon: const Icon(Icons.lock_outline),
            label: const Text('Close Shift + Z-Report'),
          ),
        ]),
      ),
    );
  }

  Widget _denomTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Hifi.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Column(children: [
          // header
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: Hifi.tableHead,
              border: Border(bottom: BorderSide(color: Hifi.border)),
            ),
            child: Row(children: [
              SizedBox(width: 120, child: Text('DENOMINATION', style: Hifi.ui(size: 11, weight: FontWeight.w600, color: const Color(0xFF645E52)))),
              Expanded(child: Center(child: Text('COUNT', style: Hifi.ui(size: 11, weight: FontWeight.w600, color: const Color(0xFF645E52))))),
              SizedBox(width: 120, child: Text('AMOUNT', textAlign: TextAlign.right, style: Hifi.ui(size: 11, weight: FontWeight.w600, color: const Color(0xFF645E52)))),
            ]),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (final d in denoms)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Hifi.divider))),
                    child: Row(children: [
                      SizedBox(width: 120, child: Text(Money.formatTenge(d * 100), style: Hifi.mono(size: 14, weight: FontWeight.w600))),
                      Expanded(
                        child: Center(
                          child: HifiStepper(
                            value: _counts[d]!,
                            showInput: true,
                            onDec: () => setState(() => _counts[d] = (_counts[d]! - 1).clamp(0, 999)),
                            onInc: () => setState(() => _counts[d] = _counts[d]! + 1),
                            onChanged: (v) => setState(() => _counts[d] = v.clamp(0, 9999)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Text(
                          Money.formatTenge(d * 100 * _counts[d]!),
                          textAlign: TextAlign.right,
                          style: Hifi.mono(size: 14, weight: FontWeight.w600),
                        ),
                      ),
                    ]),
                  ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _deltaRow() {
    final delta = _totalTiyin - _expected;
    final deltaColor = delta == 0 ? Hifi.success : delta > 0 ? Hifi.warn : Hifi.danger;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text('Expected: ', style: Hifi.ui(size: 13, color: const Color(0xFF837B6D))),
          Text(Money.formatTenge(_expected), style: Hifi.mono(size: 13, color: const Color(0xFF837B6D))),
        ]),
        const SizedBox(height: 2),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text('Difference: ', style: Hifi.ui(size: 13, weight: FontWeight.w600, color: deltaColor)),
          Text('${delta > 0 ? '+' : ''}${Money.formatTenge(delta)}', style: Hifi.mono(size: 13, weight: FontWeight.w600, color: deltaColor)),
        ]),
      ]),
    );
  }

  Widget _rightPane(BuildContext context) {
    final delta = _totalTiyin - _expected;
    final deltaColor = delta == 0 ? Hifi.chromeOnline : Hifi.chromeOffline;
    return Container(
      width: 340,
      color: Hifi.chrome,
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('TOTAL IN DRAWER',
            style: Hifi.ui(size: 11, color: Colors.white.withValues(alpha: 0.7), weight: FontWeight.w600)
                .copyWith(letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Text(Money.formatTenge(_totalTiyin),
            style: Hifi.mono(size: 48, weight: FontWeight.w800, color: Colors.white).copyWith(height: 1)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Expected from last close',
                style: Hifi.ui(size: 11, color: Colors.white.withValues(alpha: 0.7))),
            const SizedBox(height: 4),
            Text(Money.formatTenge(_expected), style: Hifi.mono(size: 15, color: Colors.white)),
            const SizedBox(height: 10),
            Text('Difference',
                style: Hifi.ui(size: 11, color: Colors.white.withValues(alpha: 0.7))),
            const SizedBox(height: 4),
            Text('${delta > 0 ? '+' : ''}${Money.formatTenge(delta)}',
                style: Hifi.mono(size: 15, weight: FontWeight.w700, color: deltaColor)),
          ]),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 64,
          child: FilledButton(
            onPressed: _submitting ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Hifi.chrome,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: _submitting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text('Open Shift', style: Hifi.ui(size: 16, weight: FontWeight.w700, color: Hifi.chrome)),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => Navigator.maybePop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.white.withValues(alpha: 0.7)),
            child: const Text('Cancel'),
          ),
        ),
      ]),
    );
  }
}
