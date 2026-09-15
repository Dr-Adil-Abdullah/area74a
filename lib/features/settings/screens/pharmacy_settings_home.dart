import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/database.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../services/api_client.dart';
import '../pharmacy_setting_keys.dart';
import '../pharmacy_settings_store.dart';
import 'currency_settings_screen.dart';
import 'dictionary_list_screen.dart';
import 'discount_settings_screen.dart';
import 'settings_screen.dart';
import 'store_info_screen.dart';
import 'tax_settings_screen.dart';

/// Owner's Settings tree. Business data is edited here, never hardcoded.
class PharmacySettingsHome extends StatefulWidget {
  const PharmacySettingsHome({
    super.key,
    required this.db,
    required this.tenantId,
    required this.api,
    required this.onLogout,
    required this.role,
  });

  final AppDatabase db;
  final String? tenantId;
  final ApiClient api;
  final VoidCallback onLogout;
  final String role;

  @override
  State<PharmacySettingsHome> createState() => _PharmacySettingsHomeState();
}

class _PharmacySettingsHomeState extends State<PharmacySettingsHome> {
  PharmacySettingsStore? _store;
  bool _seeding = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final tenant = widget.tenantId;
    if (tenant == null || tenant.isEmpty) {
      setState(() {
        _seeding = false;
        _error = 'Local shop is not set up yet. Finish first-run PIN setup.';
      });
      return;
    }
    final store = PharmacySettingsStore(SettingsRepository(widget.db, tenantId: tenant));
    try {
      await store.seedIfEmpty();
      await store.hydrateMoneyConfig();
      if (!mounted) return;
      setState(() {
        _store = store;
        _seeding = false;
      });
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _seeding = false;
      });
    }
  }

  void _open(Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (_seeding) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null || _store == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_error ?? 'Settings unavailable',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Inter', color: cs.error)),
          ),
        ),
      );
    }
    final store = _store!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Settings',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  Text(
                    'Shop data lives here. Nothing important is hardcoded.',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _section('Shop'),
                _card([
                  _tile(Icons.storefront_outlined, 'Store information',
                      'Name, address, phone, receipt footer',
                      () => _open(StoreInfoScreen(store: store))),
                  _tile(Icons.payments_outlined, 'Currency',
                      'Code, symbol (Rs. or \$), decimals',
                      () => _open(CurrencySettingsScreen(store: store))),
                  _tile(Icons.receipt_long_outlined, 'Tax',
                      'On/off, name, rate, inclusive or exclusive',
                      () => _open(TaxSettingsScreen(store: store))),
                  _tile(Icons.percent_outlined, 'Discount basis',
                      'On bill total or on profit',
                      () => _open(DiscountSettingsScreen(store: store))),
                ]),
                _section('Catalog'),
                _card([
                  _tile(Icons.account_tree_outlined, 'Product categories',
                      'Add, rename, disable, nest under a parent',
                      () => _open(DictionaryListScreen(
                            store: store,
                            listKey: PharmacySettingKeys.productCategories,
                            title: 'Product categories',
                            hierarchical: true,
                          ))),
                  _tile(Icons.science_outlined, 'Product kinds',
                      'Pharmacy, Veterinary, or add your own',
                      () => _open(DictionaryListScreen(
                            store: store,
                            listKey: PharmacySettingKeys.productKinds,
                            title: 'Product kinds',
                          ))),
                  _tile(Icons.straighten, 'Units', 'Piece, Box, Strip, ml, …',
                      () => _open(DictionaryListScreen(
                            store: store,
                            listKey: PharmacySettingKeys.units,
                            title: 'Units',
                          ))),
                  _tile(Icons.medication_outlined, 'Dosage forms',
                      'Tablet, Syrup, Injection, …',
                      () => _open(DictionaryListScreen(
                            store: store,
                            listKey: PharmacySettingKeys.dosageForms,
                            title: 'Dosage forms',
                          ))),
                  _tile(Icons.sell_outlined, 'Price tiers',
                      'Retail, VIP, Doctor — add more if needed',
                      () => _open(DictionaryListScreen(
                            store: store,
                            listKey: PharmacySettingKeys.priceTiers,
                            title: 'Price tiers',
                          ))),
                ]),
                _section('People & money'),
                _card([
                  _tile(Icons.badge_outlined, 'Contact types',
                      'Customer, VIP, Doctor, Supplier, …',
                      () => _open(DictionaryListScreen(
                            store: store,
                            listKey: PharmacySettingKeys.contactTypes,
                            title: 'Contact types',
                          ))),
                  _tile(Icons.account_balance_wallet_outlined, 'Payment methods',
                      'Cash, Card, JazzCash, EasyPaisa, …',
                      () => _open(DictionaryListScreen(
                            store: store,
                            listKey: PharmacySettingKeys.paymentMethods,
                            title: 'Payment methods',
                          ))),
                  _tile(Icons.account_balance_outlined, 'Expense heads',
                      'Rent, Salary, Utilities, …',
                      () => _open(DictionaryListScreen(
                            store: store,
                            listKey: PharmacySettingKeys.expenseHeads,
                            title: 'Expense heads',
                            hierarchical: true,
                          ))),
                ]),
                _section('System'),
                _card([
                  _tile(Icons.tune, 'Advanced / hardware',
                      'Printer stub, language, backup stub', () {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => SettingsScreen(
                        api: widget.api,
                        onLogout: widget.onLogout,
                        role: widget.role,
                      ),
                    ));
                  }),
                ]),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String text) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: cs.outline,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x0A0D1C2F), blurRadius: 24, offset: Offset(0, 8)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _tile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: cs.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: cs.outline),
        ]),
      ),
    );
  }
}
