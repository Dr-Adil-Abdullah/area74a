import 'money_config.dart';

/// Extra sale prices per product (VIP / Doctor / owner-added tiers).
/// Retail always lives on the product row. Extra tiers sit in Settings JSON
/// until Drift columns can be generated.
class PriceBook {
  PriceBook._();

  static List<String> priceTiers = const ['Retail', 'VIP', 'Doctor'];
  static List<String> contactTypes = const [
    'Customer',
    'VIP',
    'Doctor',
    'Supplier',
  ];

  /// productId → {tierName: paisa}
  static Map<String, Map<String, int>> extra = {};

  static List<String> get extraTiers => [
        for (final t in priceTiers)
          if (!isRetailName(t)) t,
      ];

  /// POS chips — Supplier is not a till customer.
  static List<String> get posContactTypes {
    final list = [
      for (final t in contactTypes)
        if (t.toLowerCase() != 'supplier') t,
    ];
    return list.isEmpty ? const ['Customer', 'VIP', 'Doctor'] : list;
  }

  static bool isRetailName(String name) {
    final n = name.toLowerCase().trim();
    return n == 'retail' ||
        n == 'customer' ||
        n == 'walk-in' ||
        n == 'walk in' ||
        n == 'walkin';
  }

  static String tierForContactType(String contactType) {
    if (isRetailName(contactType)) return 'Retail';
    for (final t in priceTiers) {
      if (t.toLowerCase() == contactType.toLowerCase().trim()) return t;
    }
    return 'Retail';
  }

  static int resolve(String productId, int retailPaisa, {String? tier}) {
    final t = (tier ?? MoneyConfig.priceTier).trim();
    if (t.isEmpty || isRetailName(t)) return retailPaisa;
    final map = extra[productId];
    if (map == null) return retailPaisa;
    for (final e in map.entries) {
      if (e.key.toLowerCase() == t.toLowerCase() && e.value > 0) {
        return e.value;
      }
    }
    return retailPaisa;
  }

  static void apply({
    List<String>? priceTiers,
    List<String>? contactTypes,
    Map<String, Map<String, int>>? extra,
  }) {
    if (priceTiers != null && priceTiers.isNotEmpty) {
      PriceBook.priceTiers = List<String>.from(priceTiers);
    }
    if (contactTypes != null && contactTypes.isNotEmpty) {
      PriceBook.contactTypes = List<String>.from(contactTypes);
    }
    if (extra != null) {
      PriceBook.extra = extra;
    }
  }

  static void resetToDefaults() {
    priceTiers = const ['Retail', 'VIP', 'Doctor'];
    contactTypes = const ['Customer', 'VIP', 'Doctor', 'Supplier'];
    extra = {};
    MoneyConfig.apply(priceTier: 'Retail');
  }
}
