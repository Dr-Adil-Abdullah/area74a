/// Keys in the existing `settings` key/value table.
/// Business data lives here so the owner can change it without a developer.
class PharmacySettingKeys {
  PharmacySettingKeys._();

  static const storeName = 'store.name';
  static const storeAddress = 'store.address';
  static const storePhone = 'store.phone';
  static const storeFooter = 'store.receipt_footer';

  static const currencyCode = 'currency.code';
  static const currencySymbol = 'currency.symbol';
  static const currencySubunit = 'currency.subunit';
  static const currencyDecimals = 'currency.decimals';

  static const taxEnabled = 'tax.enabled';
  static const taxName = 'tax.name';
  static const taxRateBp = 'tax.default_rate_bp';
  static const taxType = 'tax.type'; // inclusive | exclusive

  /// sale_total | profit
  static const discountBasis = 'discount.basis';

  static const paymentMethods = 'list.payment_methods';
  static const units = 'list.units';
  static const dosageForms = 'list.dosage_forms';
  static const contactTypes = 'list.contact_types';
  static const priceTiers = 'list.price_tiers';
  static const productKinds = 'list.product_kinds';
  static const expenseHeads = 'list.expense_heads';
  static const productCategories = 'list.product_categories';
  static const customFields = 'list.custom_fields';
}

class PharmacySettingDefaults {
  PharmacySettingDefaults._();

  static const currencyCode = 'PKR';
  static const currencySymbol = 'Rs.';
  static const currencySubunit = '100';
  static const currencyDecimals = '2';
  static const taxEnabled = 'false';
  static const taxName = 'GST';
  static const taxRateBp = '1700';
  static const taxType = 'inclusive';
  static const discountBasis = 'sale_total';
}
