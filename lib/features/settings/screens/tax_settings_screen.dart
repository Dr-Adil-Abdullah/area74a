import 'package:flutter/material.dart';

import '../pharmacy_settings_store.dart';

class TaxSettingsScreen extends StatefulWidget {
  const TaxSettingsScreen({super.key, required this.store});
  final PharmacySettingsStore store;

  @override
  State<TaxSettingsScreen> createState() => _TaxSettingsScreenState();
}

class _TaxSettingsScreenState extends State<TaxSettingsScreen> {
  bool _enabled = false;
  final _name = TextEditingController(text: 'GST');
  final _rate = TextEditingController(text: '17');
  String _type = 'inclusive';
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final t = await widget.store.tax();
    if (!mounted) return;
    final bp = int.tryParse(t['rate_bp'] ?? '1700') ?? 1700;
    setState(() {
      _enabled = t['enabled'] == 'true';
      _name.text = t['name'] ?? 'GST';
      _rate.text = (bp / 100).toStringAsFixed(bp % 100 == 0 ? 0 : 2);
      _type = t['type'] == 'exclusive' ? 'exclusive' : 'inclusive';
      _loading = false;
    });
  }

  Future<void> _save() async {
    final pct = double.tryParse(_rate.text.trim()) ?? 17;
    final bp = (pct * 100).round();
    setState(() => _saving = true);
    await widget.store.saveTax(
      enabled: _enabled,
      name: _name.text,
      rateBp: bp,
      type: _type,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tax settings saved')),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tax')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                SwitchListTile(
                  title: const Text('Enable tax system'),
                  subtitle: const Text('Off = no tax anywhere'),
                  value: _enabled,
                  onChanged: (v) => setState(() => _enabled = v),
                ),
                if (_enabled) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Tax name (GST / Sales Tax)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _rate,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Default rate %',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Tax type',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
                  RadioListTile<String>(
                    title: const Text('Inclusive in MRP'),
                    subtitle: const Text('Price already includes tax'),
                    value: 'inclusive',
                    groupValue: _type,
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Exclusive'),
                    subtitle: const Text('Added on top of the bill'),
                    value: 'exclusive',
                    groupValue: _type,
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                ],
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
