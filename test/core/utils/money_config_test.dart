import 'package:flutter_test/flutter_test.dart';
import 'package:pos_system/core/utils/money_config.dart';

void main() {
  setUp(MoneyConfig.resetToDefaults);

  test('defaults are Pakistan seed', () {
    expect(MoneyConfig.symbol, 'Rs.');
    expect(MoneyConfig.code, 'PKR');
    expect(MoneyConfig.subunit, 100);
    expect(MoneyConfig.taxEnabled, isFalse);
    expect(MoneyConfig.effectiveVatRate, 0);
    expect(MoneyConfig.taxLineLabel, '');
  });

  test('tax off forces vat rate 0', () {
    MoneyConfig.apply(taxEnabled: false, taxRatePercent: 17);
    expect(MoneyConfig.effectiveVatRate, 0);
  });

  test('tax on uses settings rate', () {
    MoneyConfig.apply(taxEnabled: true, taxRatePercent: 17, taxName: 'GST');
    expect(MoneyConfig.effectiveVatRate, 17);
    expect(MoneyConfig.taxLineLabel, 'GST 17%');
  });
}
