import 'package:flutter_test/flutter_test.dart';
import 'package:pos_system/core/utils/money.dart';
import 'package:pos_system/core/utils/money_config.dart';

void main() {
  setUp(MoneyConfig.resetToDefaults);

  group('Money.format', () {
    test('formats whole rupees with Rs. and /- ', () {
      expect(Money.format(144000), 'Rs. 1,440/-');
      expect(Money.format(100), 'Rs. 1/-');
      expect(Money.format(0), 'Rs. 0/-');
      expect(Money.format(10000000), 'Rs. 100,000/-');
    });

    test('formats with paisa remainder', () {
      expect(Money.format(150), 'Rs. 1.50');
      expect(Money.format(99), 'Rs. 0.99');
      expect(Money.format(1), 'Rs. 0.01');
      expect(Money.format(10), 'Rs. 0.10');
      expect(Money.format(50), 'Rs. 0.50');
    });

    test('formats negative values', () {
      expect(Money.format(-144000), '-Rs. 1,440/-');
      expect(Money.format(-150), '-Rs. 1.50');
      expect(Money.format(-1), '-Rs. 0.01');
      expect(Money.format(-100), '-Rs. 1/-');
    });

    test('formats large numbers with commas', () {
      expect(Money.format(100000000), 'Rs. 1,000,000/-');
      expect(Money.format(999999900), 'Rs. 9,999,999/-');
      expect(Money.format(10000000000), 'Rs. 100,000,000/-');
    });

    test('small rupee values', () {
      expect(Money.format(200), 'Rs. 2/-');
      expect(Money.format(300), 'Rs. 3/-');
      expect(Money.format(1000), 'Rs. 10/-');
    });

    test('follows MoneyConfig.symbol', () {
      MoneyConfig.apply(symbol: r'$');
      expect(Money.format(123400), r'$ 1,234/-');
      expect(Money.format(123450), r'$ 1,234.50');
    });
  });

  group('Money.formatTenge', () {
    test('aliases format (whole uses /-)', () {
      expect(Money.formatTenge(144000), 'Rs. 1,440/-');
      expect(Money.formatTenge(150), 'Rs. 2/-');
      expect(Money.formatTenge(99), 'Rs. 1/-');
    });

    test('zero', () {
      expect(Money.formatTenge(0), 'Rs. 0/-');
    });

    test('large values', () {
      expect(Money.formatTenge(10000000), 'Rs. 100,000/-');
    });
  });

  group('Money.tengeToTiyin', () {
    test('converts whole rupees', () {
      expect(Money.tengeToTiyin(100), 10000);
      expect(Money.tengeToTiyin(0), 0);
      expect(Money.tengeToTiyin(1), 100);
    });

    test('converts fractional rupees', () {
      expect(Money.tengeToTiyin(14.5), 1450);
      expect(Money.tengeToTiyin(0.01), 1);
      expect(Money.tengeToTiyin(0.99), 99);
    });

    test('rounds correctly', () {
      expect(Money.tengeToTiyin(1.005), 100);
      expect(Money.tengeToTiyin(1.004), 100);
      expect(Money.tengeToTiyin(1.006), 101);
    });
  });

  group('Money.tiyinToTenge', () {
    test('converts correctly', () {
      expect(Money.tiyinToTenge(10000), 100.0);
      expect(Money.tiyinToTenge(0), 0.0);
      expect(Money.tiyinToTenge(150), 1.5);
      expect(Money.tiyinToTenge(1), 0.01);
      expect(Money.tiyinToTenge(99), 0.99);
    });
  });

  group('Money.calculateWeightedPrice', () {
    test('basic calculations', () {
      expect(Money.calculateWeightedPrice(200000, 500), 100000);
      expect(Money.calculateWeightedPrice(100000, 1000), 100000);
      expect(Money.calculateWeightedPrice(320000, 450), 144000);
    });

    test('edge cases', () {
      expect(Money.calculateWeightedPrice(100000, 0), 0);
      expect(Money.calculateWeightedPrice(0, 500), 0);
      expect(Money.calculateWeightedPrice(0, 0), 0);
      expect(Money.calculateWeightedPrice(100000, 1), 100);
    });

    test('rounding with odd weights', () {
      expect(Money.calculateWeightedPrice(100000, 333), 33300);
      expect(Money.calculateWeightedPrice(100000, 999), 99900);
    });

    test('small prices', () {
      expect(Money.calculateWeightedPrice(1, 500), 1);
      expect(Money.calculateWeightedPrice(1, 100), 0);
    });
  });

  group('Money.calculateVat', () {
    test('12% VAT from inside', () {
      expect(Money.calculateVat(11200, 12), 1200);
      expect(Money.calculateVat(100000, 12), 10714);
    });

    test('0% VAT returns 0', () {
      expect(Money.calculateVat(10000, 0), 0);
      expect(Money.calculateVat(0, 0), 0);
    });

    test('zero total returns 0', () {
      expect(Money.calculateVat(0, 12), 0);
    });

    test('large amounts truncate', () {
      expect(Money.calculateVat(1000000, 12), 107142);
    });

    test('small amounts truncate', () {
      expect(Money.calculateVat(100, 12), 10);
      expect(Money.calculateVat(1, 12), 0);
    });
  });

  group('Money.calculateVatExclusive', () {
    test('17% on top of price', () {
      expect(Money.calculateVatExclusive(10000, 17), 1700);
      expect(Money.calculateVatExclusive(100, 17), 17);
    });

    test('0% returns 0', () {
      expect(Money.calculateVatExclusive(10000, 0), 0);
    });
  });
}
