/// Runtime money/tax display — filled from Settings, never hardcoded in UI.
/// Defaults match Pakistan until the owner changes Settings.
class MoneyConfig {
  MoneyConfig._();

  static String symbol = 'Rs.';
  static String code = 'PKR';
  static int subunit = 100;
  static int decimals = 2;

  static bool taxEnabled = false;
  static String taxName = 'GST';
  static int taxRatePercent = 17;
  static String taxType = 'inclusive'; // inclusive | exclusive

  static String discountBasis = 'sale_total';
  static String priceTier = 'Retail';

  static int get effectiveVatRate => taxEnabled ? taxRatePercent : 0;

  static String get taxLineLabel {
    if (!taxEnabled) return '';
    return '$taxName $taxRatePercent%';
  }

  static void apply({
    String? symbol,
    String? code,
    int? subunit,
    int? decimals,
    bool? taxEnabled,
    String? taxName,
    int? taxRatePercent,
    String? taxType,
    String? discountBasis,
    String? priceTier,
  }) {
    if (symbol != null && symbol.isNotEmpty) MoneyConfig.symbol = symbol;
    if (code != null && code.isNotEmpty) MoneyConfig.code = code;
    if (subunit != null && subunit > 0) MoneyConfig.subunit = subunit;
    if (decimals != null && decimals >= 0) MoneyConfig.decimals = decimals;
    if (taxEnabled != null) MoneyConfig.taxEnabled = taxEnabled;
    if (taxName != null && taxName.isNotEmpty) MoneyConfig.taxName = taxName;
    if (taxRatePercent != null && taxRatePercent >= 0) {
      MoneyConfig.taxRatePercent = taxRatePercent;
    }
    if (taxType != null && taxType.isNotEmpty) MoneyConfig.taxType = taxType;
    if (discountBasis != null) MoneyConfig.discountBasis = discountBasis;
    if (priceTier != null && priceTier.isNotEmpty) {
      MoneyConfig.priceTier = priceTier;
    }
  }

  static void resetToDefaults() {
    symbol = 'Rs.';
    code = 'PKR';
    subunit = 100;
    decimals = 2;
    taxEnabled = false;
    taxName = 'GST';
    taxRatePercent = 17;
    taxType = 'inclusive';
    discountBasis = 'sale_total';
    priceTier = 'Retail';
  }
}
