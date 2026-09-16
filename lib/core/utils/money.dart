import 'money_config.dart';

/// Money helpers. Storage is integer subunits (paisa). Display comes from
/// [MoneyConfig] so the owner can change Rs. / $ from Settings.
class Money {
  Money._();

  /// Line-item format. Whole units: `Rs. 1,234/-`. With subunit: `Rs. 1,234.50`.
  static String format(int paisa) => _format(paisa, receipt: false);

  /// Final receipt total — rounded to whole currency unit, then `Rs. 1,234/-`.
  static String formatReceipt(int paisa) => _format(roundToUnit(paisa), receipt: true);

  /// Whole units only (legacy name: formatTenge).
  static String formatTenge(int paisa) => formatReceipt(paisa);

  static String _format(int paisa, {required bool receipt}) {
    final sign = paisa < 0 ? '-' : '';
    final abs = paisa.abs();
    final sub = MoneyConfig.subunit <= 0 ? 100 : MoneyConfig.subunit;
    final major = abs ~/ sub;
    final remainder = abs % sub;
    final majorStr = _formatWithSeparators(major);
    final sym = MoneyConfig.symbol;

    if (remainder == 0 || receipt) {
      return '$sign$sym $majorStr/-';
    }
    final dec = MoneyConfig.decimals;
    var frac = remainder.toString();
    // pad to log10(subunit) digits then trim/pad to [dec]
    final subDigits = sub == 1 ? 0 : sub.toString().length - 1;
    frac = frac.padLeft(subDigits, '0');
    if (dec <= 0) return '$sign$sym $majorStr/-';
    if (frac.length > dec) {
      frac = frac.substring(0, dec);
    } else if (frac.length < dec) {
      frac = frac.padRight(dec, '0');
    }
    return '$sign$sym $majorStr.$frac';
  }

  /// Round to nearest whole currency unit (paisa → rupee).
  static int roundToUnit(int paisa) {
    final sub = MoneyConfig.subunit <= 0 ? 100 : MoneyConfig.subunit;
    final rem = paisa % sub;
    if (rem == 0) return paisa;
    if (rem.abs() * 2 >= sub) {
      return paisa >= 0 ? paisa + (sub - rem) : paisa - (sub + rem);
    }
    return paisa - rem;
  }

  static int tengeToTiyin(double tenge) => (tenge * MoneyConfig.subunit).round();

  static double tiyinToTenge(int tiyin) => tiyin / MoneyConfig.subunit;

  static int calculateWeightedPrice(int pricePerKgTiyin, int weightGrams) {
    return ((weightGrams * pricePerKgTiyin) + 500) ~/ 1000;
  }

  /// Inclusive VAT (tax inside the price). Integer truncation — parity with
  /// upstream calculator tests.
  static int calculateVat(int totalTiyin, int vatRate) {
    if (vatRate == 0) return 0;
    return (totalTiyin * vatRate) ~/ (100 + vatRate);
  }

  /// Exclusive VAT (added on top of the price).
  static int calculateVatExclusive(int totalTiyin, int vatRate) {
    if (vatRate == 0) return 0;
    return (totalTiyin * vatRate) ~/ 100;
  }

  static int calculateItemTotal({
    required bool isWeighted,
    required int basePriceTiyin,
    required int quantity,
    required int weightGrams,
    required int discountTiyin,
  }) {
    if (basePriceTiyin < 0) {
      throw ArgumentError('basePriceTiyin must be non-negative');
    }
    if (discountTiyin < 0) {
      throw ArgumentError('discountTiyin must be non-negative');
    }
    final subtotal = isWeighted
        ? calculateWeightedPrice(basePriceTiyin, weightGrams)
        : basePriceTiyin * quantity;
    final net = subtotal - discountTiyin;
    return net < 0 ? 0 : net;
  }

  static int calculateChange({
    required int totalTiyin,
    required int cashTiyin,
    required int cardTiyin,
    required int qrTiyin,
  }) {
    final paid = cashTiyin + cardTiyin + qrTiyin;
    final diff = paid - totalTiyin;
    return diff > 0 ? diff : 0;
  }

  static String _formatWithSeparators(int number) {
    final str = number.abs().toString();
    final result = StringBuffer();
    final sign = number < 0 ? '-' : '';
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        result.write(',');
      }
      result.write(str[i]);
    }
    return '$sign$result';
  }
}
