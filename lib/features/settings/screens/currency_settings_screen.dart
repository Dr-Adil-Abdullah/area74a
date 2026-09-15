import 'package:flutter/material.dart';

import '../pharmacy_settings_store.dart';

class CurrencySettingsScreen extends StatefulWidget {
  const CurrencySettingsScreen({super.key, required this.store});
  final PharmacySettingsStore store;

  @override
  State<CurrencySettingsScreen> createState() => _CurrencySettingsScreenState();
}

class _CurrencySettingsScreenState extends State<CurrencySettingsScreen> {
  final _code = TextEditingController();
  final _symbol = TextEditingController();
  final _subunit = TextEditingController();
  final _decimals = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final c = await widget.store.currency();
    if (!mounted) return;
    _code.text = c['code'] ?? 'PKR';
    _symbol.text = c['symbol'] ?? 'Rs.';
    _subunit.text = c['subunit'] ?? '100';
    _decimals.text = c['decimals'] ?? '2';
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await widget.store.saveCurrency(
      code: _code.text,
      symbol: _symbol.text,
      subunit: _subunit.text,
      decimals: _decimals.text,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Currency saved')),
    );
  }

  @override
  void dispose() {
    _code.dispose();
    _symbol.dispose();
    _subunit.dispose();
    _decimals.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text(
                  'Shown on receipts and the till. Change Rs. to \$ or any sign.',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _code,
                  decoration: const InputDecoration(
                    labelText: 'Code (PKR, USD, …)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _symbol,
                  decoration: const InputDecoration(
                    labelText: 'Symbol (Rs.  or  \$  or  ₨)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _subunit,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Subunits in 1 unit (100 = paisa)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _decimals,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Decimal places on line items',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? 'Saving…' : 'Save'),
                ),
              ],
            ),
    );
  }
}
