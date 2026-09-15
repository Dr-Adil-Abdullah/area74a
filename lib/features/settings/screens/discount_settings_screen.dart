import 'package:flutter/material.dart';

import '../pharmacy_settings_store.dart';

class DiscountSettingsScreen extends StatefulWidget {
  const DiscountSettingsScreen({super.key, required this.store});
  final PharmacySettingsStore store;

  @override
  State<DiscountSettingsScreen> createState() => _DiscountSettingsScreenState();
}

class _DiscountSettingsScreenState extends State<DiscountSettingsScreen> {
  String _basis = 'sale_total';
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final v = await widget.store.discountBasis();
    if (!mounted) return;
    setState(() {
      _basis = v == 'profit' ? 'profit' : 'sale_total';
      _loading = false;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await widget.store.saveDiscountBasis(_basis);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Discount basis saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discount basis')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                RadioListTile<String>(
                  title: const Text('On bill total'),
                  subtitle: const Text('Discount % or amount off the sale price'),
                  value: 'sale_total',
                  groupValue: _basis,
                  onChanged: (v) => setState(() => _basis = v!),
                ),
                RadioListTile<String>(
                  title: const Text('On profit'),
                  subtitle: const Text('Discount taken from (sale − cost), not the full price'),
                  value: 'profit',
                  groupValue: _basis,
                  onChanged: (v) => setState(() => _basis = v!),
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
