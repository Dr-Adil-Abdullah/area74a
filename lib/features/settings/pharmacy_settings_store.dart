import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../../core/utils/money_config.dart';
import '../../data/repositories/settings_repository.dart';
import 'pharmacy_setting_keys.dart';
import 'setting_list_item.dart';

/// Owner-editable business data on top of the existing settings key/value table.
/// No new Drift tables yet (needs `build_runner`). JSON lists are still local
/// SQLite — fully offline.
class PharmacySettingsStore {
  PharmacySettingsStore(this._repo);

  final SettingsRepository _repo;
  static const _uuid = Uuid();

  Future<String> getOr(String key, String fallback) async {
    final v = await _repo.get(key);
    if (v == null || v.isEmpty) return fallback;
    return v;
  }

  Future<void> set(String key, String value) => _repo.upsert(key, value);

  Future<Map<String, String>> storeProfile() async {
    return {
      'name': await getOr(PharmacySettingKeys.storeName, ''),
      'address': await getOr(PharmacySettingKeys.storeAddress, ''),
      'phone': await getOr(PharmacySettingKeys.storePhone, ''),
      'footer': await getOr(PharmacySettingKeys.storeFooter, ''),
    };
  }

  Future<void> saveStoreProfile({
    required String name,
    required String address,
    required String phone,
    required String footer,
  }) async {
    await set(PharmacySettingKeys.storeName, name.trim());
    await set(PharmacySettingKeys.storeAddress, address.trim());
    await set(PharmacySettingKeys.storePhone, phone.trim());
    await set(PharmacySettingKeys.storeFooter, footer.trim());
  }

  Future<Map<String, String>> currency() async {
    return {
      'code': await getOr(
          PharmacySettingKeys.currencyCode, PharmacySettingDefaults.currencyCode),
      'symbol': await getOr(PharmacySettingKeys.currencySymbol,
          PharmacySettingDefaults.currencySymbol),
      'subunit': await getOr(PharmacySettingKeys.currencySubunit,
          PharmacySettingDefaults.currencySubunit),
      'decimals': await getOr(PharmacySettingKeys.currencyDecimals,
          PharmacySettingDefaults.currencyDecimals),
    };
  }

  Future<void> saveCurrency({
    required String code,
    required String symbol,
    required String subunit,
    required String decimals,
  }) async {
    await set(PharmacySettingKeys.currencyCode, code.trim().toUpperCase());
    await set(PharmacySettingKeys.currencySymbol, symbol);
    await set(PharmacySettingKeys.currencySubunit, subunit);
    await set(PharmacySettingKeys.currencyDecimals, decimals);
    await hydrateMoneyConfig();
  }

  Future<Map<String, String>> tax() async {
    return {
      'enabled': await getOr(
          PharmacySettingKeys.taxEnabled, PharmacySettingDefaults.taxEnabled),
      'name':
          await getOr(PharmacySettingKeys.taxName, PharmacySettingDefaults.taxName),
      'rate_bp': await getOr(
          PharmacySettingKeys.taxRateBp, PharmacySettingDefaults.taxRateBp),
      'type':
          await getOr(PharmacySettingKeys.taxType, PharmacySettingDefaults.taxType),
    };
  }

  Future<void> saveTax({
    required bool enabled,
    required String name,
    required int rateBp,
    required String type,
  }) async {
    await set(PharmacySettingKeys.taxEnabled, enabled ? 'true' : 'false');
    await set(PharmacySettingKeys.taxName, name.trim());
    await set(PharmacySettingKeys.taxRateBp, '$rateBp');
    await set(PharmacySettingKeys.taxType, type);
    await hydrateMoneyConfig();
  }

  Future<String> discountBasis() => getOr(
        PharmacySettingKeys.discountBasis,
        PharmacySettingDefaults.discountBasis,
      );

  Future<void> saveDiscountBasis(String basis) async {
    await set(PharmacySettingKeys.discountBasis, basis);
    await hydrateMoneyConfig();
  }

  /// Push saved currency/tax into [MoneyConfig] so POS and receipts follow Settings.
  Future<void> hydrateMoneyConfig() async {
    final c = await currency();
    final t = await tax();
    final d = await discountBasis();
    final bp = int.tryParse(t['rate_bp'] ?? '') ?? 1700;
    MoneyConfig.apply(
      symbol: c['symbol'],
      code: c['code'],
      subunit: int.tryParse(c['subunit'] ?? '') ?? 100,
      decimals: int.tryParse(c['decimals'] ?? '') ?? 2,
      taxEnabled: t['enabled'] == 'true',
      taxName: t['name'],
      taxRatePercent: (bp / 100).round(),
      taxType: t['type'],
      discountBasis: d,
    );
  }

  Future<List<SettingListItem>> list(String key) async {
    final raw = await _repo.get(key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return [
        for (final e in decoded)
          if (e is Map<String, dynamic>) SettingListItem.fromJson(e)
          else if (e is Map) SettingListItem.fromJson(Map<String, dynamic>.from(e)),
      ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    } on Object {
      return const [];
    }
  }

  Future<void> saveList(String key, List<SettingListItem> items) async {
    final encoded = jsonEncode([for (final i in items) i.toJson()]);
    await set(key, encoded);
  }

  Future<void> seedIfEmpty() async {
    Future<void> seed(String key, List<String> names) async {
      final existing = await list(key);
      if (existing.isNotEmpty) return;
      final items = <SettingListItem>[];
      for (var i = 0; i < names.length; i++) {
        items.add(SettingListItem(
          id: _uuid.v4(),
          name: names[i],
          sortOrder: i,
        ));
      }
      await saveList(key, items);
    }

    await seed(PharmacySettingKeys.paymentMethods, const [
      'Cash',
      'Card',
      'JazzCash',
      'EasyPaisa',
    ]);
    await seed(PharmacySettingKeys.units, const [
      'Piece',
      'Box',
      'Strip',
      'ml',
    ]);
    await seed(PharmacySettingKeys.dosageForms, const [
      'Tablet',
      'Syrup',
      'Capsule',
      'Injection',
      'Cream',
      'Drops',
    ]);
    await seed(PharmacySettingKeys.contactTypes, const [
      'Customer',
      'VIP',
      'Doctor',
      'Supplier',
    ]);
    await seed(PharmacySettingKeys.priceTiers, const [
      'Retail',
      'VIP',
      'Doctor',
    ]);
    await seed(PharmacySettingKeys.productKinds, const [
      'Pharmacy',
      'Veterinary',
    ]);
    await seed(PharmacySettingKeys.expenseHeads, const [
      'Rent',
      'Salary',
      'Utilities',
      'Other',
    ]);
  }

  static SettingListItem newItem(String name, int sortOrder, {String? parentId}) {
    return SettingListItem(
      id: _uuid.v4(),
      name: name,
      sortOrder: sortOrder,
      parentId: parentId,
    );
  }
}
