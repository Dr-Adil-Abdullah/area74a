import 'package:flutter_test/flutter_test.dart';
import 'package:pos_system/core/utils/money_config.dart';
import 'package:pos_system/core/utils/price_book.dart';

void main() {
  setUp(PriceBook.resetToDefaults);

  test('Customer maps to Retail', () {
    expect(PriceBook.tierForContactType('Customer'), 'Retail');
    expect(PriceBook.tierForContactType('walk-in'), 'Retail');
  });

  test('Doctor maps to Doctor, VIP to VIP', () {
    expect(PriceBook.tierForContactType('Doctor'), 'Doctor');
    expect(PriceBook.tierForContactType('VIP'), 'VIP');
  });

  test('unknown contact type falls back to Retail', () {
    expect(PriceBook.tierForContactType('Supplier'), 'Retail');
    expect(PriceBook.tierForContactType('Friend'), 'Retail');
  });

  test('resolve uses extra tier when set', () {
    PriceBook.apply(extra: {
      'p1': {'VIP': 9000, 'Doctor': 8000},
    });
    expect(PriceBook.resolve('p1', 10000, tier: 'Retail'), 10000);
    expect(PriceBook.resolve('p1', 10000, tier: 'VIP'), 9000);
    expect(PriceBook.resolve('p1', 10000, tier: 'Doctor'), 8000);
  });

  test('resolve falls back to retail when extra missing', () {
    expect(PriceBook.resolve('unknown', 10000, tier: 'Doctor'), 10000);
  });

  test('POS chips hide Supplier', () {
    expect(PriceBook.posContactTypes, isNot(contains('Supplier')));
    expect(PriceBook.posContactTypes, containsAll(['Customer', 'VIP', 'Doctor']));
  });

  test('MoneyConfig.priceTier used when tier omitted', () {
    PriceBook.apply(extra: {
      'p1': {'Doctor': 5000},
    });
    MoneyConfig.apply(priceTier: 'Doctor');
    expect(PriceBook.resolve('p1', 10000), 5000);
  });
}
