// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pharmacy POS';

  @override
  String get appRegion => 'PAKISTAN';

  @override
  String get navPos => 'POS';

  @override
  String get navShift => 'SHIFTS';

  @override
  String get navProducts => 'MEDICINES';

  @override
  String get navStaff => 'STAFF';

  @override
  String get navDebts => 'CREDIT / DEBTS';

  @override
  String get navAnalytics => 'ANALYTICS';

  @override
  String get navDelivery => 'PURCHASES';

  @override
  String get navApproval => 'APPROVAL';

  @override
  String get navAudit => 'AUDIT LOG';

  @override
  String get navSettings => 'SETTINGS';

  @override
  String get navPosShort => 'POS';

  @override
  String get navShiftShort => 'Shifts';

  @override
  String get navMore => 'More';

  @override
  String get navProductsShort => 'Medicines';

  @override
  String get navStaffShort => 'Staff';

  @override
  String get navDebtsShort => 'Debts';

  @override
  String get navAnalyticsShort => 'Analytics';

  @override
  String get navDeliveryShort => 'Purchases';

  @override
  String get navApprovalShort => 'Approval';

  @override
  String get navAuditShort => 'Audit';

  @override
  String get navSettingsShort => 'Settings';

  @override
  String get modeCashier => 'Cashier';

  @override
  String get modeOwner => 'Owner';

  @override
  String get logout => 'Sign Out';

  @override
  String get systemOnline => 'System Online';

  @override
  String get shiftOpened => 'Shift Open';

  @override
  String get shiftClosed => 'Shift Closed';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleSeniorCashier => 'Senior Cashier';

  @override
  String get roleSeniorCashierShort => 'Sr. Cashier';

  @override
  String get roleCashier => 'Cashier';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Close';

  @override
  String get create => 'Create';

  @override
  String get delete => 'Delete';

  @override
  String get refresh => 'Refresh';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get search => 'Search';

  @override
  String get loadMore => 'Load More';

  @override
  String get noData => 'No data';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get pinTerminal => 'Terminal #001';

  @override
  String get pinSelectProfile => 'SELECT PROFILE';

  @override
  String get pinCashierLabel => 'Cashier';

  @override
  String get pinEnterForLogin => 'Enter PIN to sign in';

  @override
  String get pinChangeTerminal => 'Switch Terminal';

  @override
  String get pinWelcome => 'Welcome';

  @override
  String get pinEnterCode => 'Enter 4-digit PIN code';

  @override
  String get pinEncryptedAccess => 'ENCRYPTED ACCESS';

  @override
  String get pinFirstRunTitle => 'Welcome!';

  @override
  String get pinFirstRunSubtitle => 'Create the first user';

  @override
  String get pinFieldName => 'Name';

  @override
  String get pinFieldPin => 'PIN code (4 digits)';

  @override
  String get pinFieldConfirm => 'Confirm PIN';

  @override
  String get pinErrorLength => 'PIN must be 4 digits';

  @override
  String get pinErrorMismatch => 'PIN codes do not match';

  @override
  String get pinCreateAndLogin => 'Create & Sign In';

  @override
  String pinLockedMessage(String display) {
    return 'Locked: $display';
  }

  @override
  String get pinSec => 'sec.';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentToPay => 'Amount Due';

  @override
  String paymentVatLine(String amount) {
    return 'incl. Tax: $amount';
  }

  @override
  String get paymentCash => 'Cash';

  @override
  String get paymentCard => 'Card';

  @override
  String get paymentKaspiQR => 'QR / Wallet';

  @override
  String get paymentMix => 'Split';

  @override
  String get paymentChange => 'Change';

  @override
  String get paymentCardHint => 'Tap or insert card on terminal';

  @override
  String get paymentQRHint => 'Show QR code to customer';

  @override
  String paymentPayButton(String amount) {
    return 'Pay $amount';
  }

  @override
  String paymentPendingButton(String amount) {
    return 'Enter $amount';
  }

  @override
  String get shiftNotOpened => 'Shift Not Open';

  @override
  String shiftCashierLabel(String name) {
    return 'Cashier: $name';
  }

  @override
  String get shiftCashInDrawer => 'Cash in Drawer (Rs.)';

  @override
  String get shiftOpen => 'Open Shift';

  @override
  String get shiftReconciliation => 'Shift Reconciliation';

  @override
  String get shiftCountCash => 'Cash Count';

  @override
  String get shiftCountInstruction => 'Enter the count for each denomination in the drawer.';

  @override
  String get shiftBanknote => 'DENOMINATION';

  @override
  String get shiftCoin => 'COINS';

  @override
  String get shiftSubtotal => 'Subtotal';

  @override
  String get shiftManualAdjust => 'Manual Adjustment';

  @override
  String get shiftAdjustSubtitle => 'Notes on shortage or overage';

  @override
  String get shiftNote => 'Note';

  @override
  String get shiftStatCash => 'CASH';

  @override
  String get shiftStatCard => 'CARD';

  @override
  String get shiftStatKaspiQR => 'QR / WALLET';

  @override
  String get shiftStatReturns => 'RETURNS';

  @override
  String get shiftSummary => 'Shift Summary';

  @override
  String get shiftStartBalance => 'Opening Cash';

  @override
  String get shiftCashSales => 'Cash Sales';

  @override
  String get shiftReturnsPayouts => 'Returns / Payouts';

  @override
  String get shiftExpectedBalance => 'EXPECTED CASH';

  @override
  String get shiftCounted => 'COUNTED';

  @override
  String get shiftDiscrepancy => 'Discrepancy';

  @override
  String get shiftLabel => 'Shift';

  @override
  String shiftNumber(int number) {
    return 'Shift #$number';
  }

  @override
  String get shiftReceipts => 'receipts';

  @override
  String get shiftCashStart => 'Opening Cash';

  @override
  String get shiftCurrentBalance => 'Current Balance';

  @override
  String get shiftCloseZReport => 'Close Shift (Z-Report)';

  @override
  String get shiftCloseConfirmTitle => 'Close Shift?';

  @override
  String get shiftCloseConfirmBody => 'A Z-Report will be generated. This action cannot be undone.';

  @override
  String get shiftCloseButton => 'Close Shift';

  @override
  String get shiftCloseFooter => 'By closing the shift, you confirm the cash count in the drawer.';

  @override
  String get productsTitle => 'Medicines & Products';

  @override
  String productsCountLabel(int count) {
    return '$count items in catalog';
  }

  @override
  String get productsTotalStat => 'TOTAL ITEMS';

  @override
  String get productsWeightedStat => 'WEIGHTED';

  @override
  String get productsPieceStat => 'UNIT / PACK';

  @override
  String get productsAvgPriceStat => 'AVG PRICE';

  @override
  String get productsTotalShort => 'TOTAL';

  @override
  String get productsAvgPriceShort => 'AVG PRICE';

  @override
  String get productsSearchHint => 'Search by medicine name or barcode...';

  @override
  String productsTabAll(int count) {
    return 'All ($count)';
  }

  @override
  String productsTabWeighted(int count) {
    return 'Weighted ($count)';
  }

  @override
  String productsTabPiece(int count) {
    return 'Unit ($count)';
  }

  @override
  String get productsColName => 'PRODUCT';

  @override
  String get productsColBarcode => 'BARCODE';

  @override
  String get productsColVat => 'TAX';

  @override
  String get productsColPrice => 'PRICE';

  @override
  String get productsNotFound => 'Nothing found';

  @override
  String get productsEmpty => 'No products yet';

  @override
  String get productsTryAnother => 'Try another search query';

  @override
  String get productsEmptyHint => 'Add your first medicine using the + Add button above';

  @override
  String get productsDeleteConfirm => 'Delete product?';

  @override
  String get productsNew => 'New Medicine / Product';

  @override
  String get productsFieldBarcode => 'Barcode (GTIN)';

  @override
  String get productsNkt => 'Label';

  @override
  String get productsEnterBarcode => 'Enter barcode';

  @override
  String get productsNktNotFound => 'Not found in catalog';

  @override
  String productsNktError(String error) {
    return 'Lookup error: $error';
  }

  @override
  String get productsFieldName => 'Medicine / Product Name';

  @override
  String get productsFieldPrice => 'Retail Price';

  @override
  String get productsWeighted => 'Sold by weight / measure';

  @override
  String get productsWeightedSubPriceKg => 'Price per kg';

  @override
  String get productsWeightedSubPricePcs => 'Price per unit';

  @override
  String get productsTypeWeighted => 'Weighted';

  @override
  String get productsTypePiece => 'Unit';

  @override
  String get cashiersTitle => 'Staff & Cashiers';

  @override
  String cashiersCountLabel(int count) {
    return '$count staff members';
  }

  @override
  String get cashiersStatTotal => 'Total';

  @override
  String get cashiersStatOwners => 'Owners';

  @override
  String get cashiersStatManagers => 'Managers';

  @override
  String get cashiersColName => 'NAME';

  @override
  String get cashiersColRole => 'ROLE';

  @override
  String get cashiersEmpty => 'No cashiers found';

  @override
  String get cashiersNew => 'New Cashier';

  @override
  String get cashiersFieldName => 'Name';

  @override
  String get cashiersFieldPin => 'PIN (4 digits)';

  @override
  String get cashiersFieldRole => 'Role';

  @override
  String get cashiersEnterName => 'Enter name';

  @override
  String get debtsTitle => 'Customer Credit / Debts';

  @override
  String debtsCountLabel(int open, int clients) {
    return '$open open, $clients customers';
  }

  @override
  String get debtsNewDebt => 'New Credit Entry';

  @override
  String get debtsTotalBanner => 'TOTAL OUTSTANDING';

  @override
  String get debtsRecordsLabel => 'records';

  @override
  String debtsTabOpen(int count) {
    return 'Open ($count)';
  }

  @override
  String debtsTabAll(int count) {
    return 'All ($count)';
  }

  @override
  String get debtsEmpty => 'No credit records';

  @override
  String get debtsPayTitle => 'Receive Credit Payment';

  @override
  String debtsPayRemaining(String amount) {
    return 'Remaining: $amount';
  }

  @override
  String get debtsFieldAmount => 'Amount';

  @override
  String get debtsEnterAmount => 'Enter amount';

  @override
  String get debtsPay => 'Receive Payment';

  @override
  String get debtsCreateTitle => 'Credit Sale';

  @override
  String get debtsFieldClient => 'Customer';

  @override
  String get debtsFieldNote => 'Note';

  @override
  String get debtsSelectClient => 'Select customer';

  @override
  String get debtsRecord => 'Record Credit';

  @override
  String get debtsClientDefault => 'Customer';

  @override
  String get debtsPaid => 'Paid';

  @override
  String debtsOfTotal(String amount) {
    return 'of $amount';
  }

  @override
  String get debtsPayment => 'Pay';

  @override
  String get debtsClosed => 'Closed';

  @override
  String debtsPaidLabel(String amount) {
    return 'Paid: $amount';
  }

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsSubtitle => 'Business overview';

  @override
  String get analyticsToday => 'TODAY';

  @override
  String get analyticsYesterday => 'YESTERDAY';

  @override
  String get analyticsWeek => 'WEEK';

  @override
  String get analyticsMonth => 'MONTH';

  @override
  String get analyticsReceipts => 'receipts';

  @override
  String get analyticsPaymentTypes => 'Sales by Payment Method';

  @override
  String get analyticsTopProducts => 'Top Products (30 days)';

  @override
  String get analyticsCashiers => 'Cashiers';

  @override
  String get analyticsLowStock => 'Low Stock';

  @override
  String get analyticsDebts => 'Credit / Debts';

  @override
  String get analyticsAllNormal => 'All normal';

  @override
  String get analyticsCash => 'Cash';

  @override
  String get analyticsCard => 'Card';

  @override
  String get analyticsKaspiQR => 'QR / Wallet';

  @override
  String get analyticsOpenDebts => 'Open';

  @override
  String get analyticsToPayDebts => 'Outstanding';

  @override
  String get analyticsPaidDebts => 'Collected';

  @override
  String get deliveryTitle => 'Stock Purchase / Receiving';

  @override
  String get deliverySearchHint => 'Search product...';

  @override
  String deliveryCostLabel(String amount) {
    return 'Cost: $amount';
  }

  @override
  String deliveryLinesLabel(int count) {
    return 'Items ($count)';
  }

  @override
  String get deliveryEmptyHint => 'Add products to receive stock';

  @override
  String get deliveryFieldQty => 'Qty';

  @override
  String get deliveryFieldCost => 'Cost Price';

  @override
  String get deliverySubmit => 'Complete Purchase';

  @override
  String get deliverySuccess => 'Purchase recorded';

  @override
  String get approvalTitle => 'Product Approval';

  @override
  String get approvalSubtitle => 'Products awaiting review';

  @override
  String get approvalEmpty => 'No pending products';

  @override
  String get approvalPending => 'PENDING';

  @override
  String approvalFrom(String name) {
    return 'by: $name';
  }

  @override
  String get approvalBarcode => 'Barcode';

  @override
  String get approvalNtin => 'Code';

  @override
  String get approvalSalePrice => 'Sale Price';

  @override
  String get approvalReject => 'Reject';

  @override
  String get approvalApprove => 'Approve';

  @override
  String get approvalApproveTitle => 'Approve Product';

  @override
  String get approvalFieldName => 'Name';

  @override
  String get approvalFieldPrice => 'Sale Price';

  @override
  String get approvalRejectTitle => 'Reject Product';

  @override
  String get approvalRejectReason => 'Reason (optional)';

  @override
  String get approvalApproved => 'Product approved';

  @override
  String get approvalRejected => 'Product rejected';

  @override
  String get auditTitle => 'Audit Log';

  @override
  String auditTotalLabel(int count) {
    return 'Total entries: $count';
  }

  @override
  String get auditEmpty => 'No audit entries';

  @override
  String get auditActionReceiptCreated => 'Receipt created';

  @override
  String get auditActionShiftOpened => 'Shift opened';

  @override
  String get auditActionShiftClosed => 'Shift closed';

  @override
  String get auditActionNktApproved => 'Product approved';

  @override
  String get auditActionNktRejected => 'Product rejected';

  @override
  String get auditActionProductCreated => 'Product created';

  @override
  String get auditActionProductEdited => 'Product updated';

  @override
  String get auditActionProductDeleted => 'Product deleted';

  @override
  String get auditActionDebtCreated => 'Credit recorded';

  @override
  String get auditActionDebtPaid => 'Credit payment received';

  @override
  String get auditActionCashierCreated => 'Cashier added';

  @override
  String get auditActionDeliveryReceived => 'Purchase received';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'System configuration';

  @override
  String get settingsActions => 'Actions';

  @override
  String get settingsSeedDemo => 'Load Demo Data';

  @override
  String get settingsSeedDemoSub => 'Sample products, categories, and customers';

  @override
  String get settingsCheckNkt => 'Catalog Lookup';

  @override
  String get settingsCheckNktSub => 'Search product by barcode or name';

  @override
  String get settingsSystem => 'System';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutSub => 'Pharmacy POS v0.2.2';

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsServerStatus => 'Server Status';

  @override
  String get settingsServerConnected => 'Connected';

  @override
  String get settingsServerUnavailable => 'Offline (Local Mode)';

  @override
  String get settingsIntegrations => 'Integrations';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSub => 'English';

  @override
  String get settingsLanguageKk => 'Қазақша';

  @override
  String get settingsFiscal => 'Fiscal Printer';

  @override
  String get settingsNotConnected => 'Not connected';

  @override
  String get settingsNktTitle => 'National Catalog';

  @override
  String get settingsNktConnected => 'Connected';

  @override
  String get settingsNktNotConfigured => 'Not configured';

  @override
  String get settingsNktSearch => 'Catalog Search';

  @override
  String get settingsNktBarcode => 'Barcode';

  @override
  String get settingsNktName => 'Name';

  @override
  String get settingsNktGtinHint => 'GTIN (barcode)';

  @override
  String get settingsNktNameHint => 'Product name';

  @override
  String get settingsNktNotFound => 'Nothing found';

  @override
  String get settingsNktSocial => 'Essential';

  @override
  String get posTabProducts => 'Products';

  @override
  String get posTabReceipt => 'Receipt';

  @override
  String get posSearchHint => 'Search medicine / barcode / SKU...';

  @override
  String get posCatAll => 'All';

  @override
  String get posCatFood => 'Tablets';

  @override
  String get posCatDrinks => 'Syrups';

  @override
  String get posCatGrocery => 'Surgical';

  @override
  String get posCatDairy => 'Injections';

  @override
  String get posCatOther => 'Other';

  @override
  String get posOnline => 'Online';

  @override
  String get posEnterNameOr => 'Enter medicine name or';

  @override
  String get posScanBarcode => 'scan barcode';

  @override
  String get posNotFoundLocally => 'Not found locally';

  @override
  String get posEnterFullBarcode => 'Enter full barcode (8–14 digits)';

  @override
  String get posForAutoNkt => 'for catalog lookup';

  @override
  String posBarcodeProgress(int current) {
    return 'Entered $current of 8–14 digits';
  }

  @override
  String posNotFoundQuery(String query) {
    return 'No results for "$query"';
  }

  @override
  String get posSearchingNkt => 'Searching catalog...';

  @override
  String get posNotFoundLocallyHeader => 'Product not found locally';

  @override
  String posNktFoundCount(int count, String barcode) {
    return 'Found $count in catalog for barcode $barcode';
  }

  @override
  String get posNktSelectInstruction => 'Select a product to add to catalog:';

  @override
  String get posNktAddTitle => 'Add Product';

  @override
  String get posNktPriceKg => 'Price per kg';

  @override
  String get posNktPricePcs => 'Price';

  @override
  String get posNktAddAndSell => 'Add & Sell';

  @override
  String get posNktSentForApproval => 'Product sent for owner approval';

  @override
  String posNktCreateError(String error) {
    return 'Error creating product: $error';
  }

  @override
  String get posCartTitle => 'Current Receipt';

  @override
  String get posCartItems => 'items';

  @override
  String get posCartEmpty => 'Cart is empty';

  @override
  String get posCartEmptyHint => 'Scan or search a medicine above';

  @override
  String get posQuantity => 'Quantity';

  @override
  String get posVat12 => 'Tax';

  @override
  String get posTotal => 'Total';

  @override
  String get posPayment => 'PAY';

  @override
  String posPaymentWithAmount(String amount) {
    return 'PAY  $amount';
  }

  @override
  String get posTakeaway => 'Takeaway';

  @override
  String get posCancelSale => 'Clear';

  @override
  String get posCancelSaleTitle => 'Cancel sale?';

  @override
  String posCancelSaleBody(int count) {
    return 'There are $count items in the cart. They will be cleared.';
  }

  @override
  String get posCancelSaleConfirm => 'Clear Cart';

  @override
  String get posCancelSaleKeep => 'Keep';

  @override
  String get posOpenShiftFirst => 'Please open a shift first (Shifts tab)';

  @override
  String get analyticsAllTime => 'All Time';

  @override
  String get analyticsAutoRefresh => 'Auto-refresh';

  @override
  String get analyticsAvgReceipt => 'Average Receipt';

  @override
  String get analyticsClearFilter => 'Clear Filter';

  @override
  String get analyticsDateRange => 'Date Range';

  @override
  String get analyticsExport => 'Export';

  @override
  String get analyticsExportSuccess => 'Export completed';

  @override
  String get analyticsProductName => 'Product';

  @override
  String get analyticsQty => 'Qty';

  @override
  String get analyticsRevenue => 'Revenue';

  @override
  String get analyticsRevenueByProduct => 'Revenue by Product';

  @override
  String get approvalBatchApprove => 'Approve Selected';

  @override
  String approvalBatchCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '$count product',
    );
    return '$_temp0';
  }

  @override
  String get approvalDefaultMarkup => 'Default Markup';

  @override
  String get cashiersDeactivate => 'Deactivate';

  @override
  String get cashiersDeactivateConfirm => 'Deactivate cashier?';

  @override
  String get cashiersDeactivateHint => 'This staff member will no longer be able to sign in.';

  @override
  String get cashiersDeactivated => 'Cashier deactivated';

  @override
  String get cashiersEdit => 'Edit';

  @override
  String get cashiersNewPin => 'New PIN';

  @override
  String get cashiersPinConfirm => 'Confirm PIN';

  @override
  String get cashiersResetPin => 'Reset PIN';

  @override
  String get cashiersResetPinSuccess => 'PIN reset successfully';

  @override
  String get cashiersRoleAdminDesc => 'Full access except owner settings';

  @override
  String get cashiersRoleCashierDesc => 'Sales and shifts only';

  @override
  String get cashiersRoleSeniorDesc => 'Cashier + returns and discounts';

  @override
  String get debtsOverdue => 'Overdue';

  @override
  String get debtsRemainingAmount => 'Remaining Balance';

  @override
  String debtsDaysSuffix(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return '$_temp0';
  }

  @override
  String get debtsSearch => 'Search by customer name or phone';

  @override
  String get deliveryActualQty => 'Actual';

  @override
  String get deliveryAddSupplier => 'Add Supplier';

  @override
  String get deliveryCreateProduct => 'Create Product';

  @override
  String get deliveryDiscrepancy => 'Discrepancy';

  @override
  String get deliveryDocNumber => 'Invoice Number';

  @override
  String get deliveryExpectedQty => 'Expected';

  @override
  String get deliveryHistory => 'Purchase History';

  @override
  String get deliveryNoHistory => 'No purchase history';

  @override
  String get deliverySupplier => 'Supplier';

  @override
  String get done => 'Done';

  @override
  String get importConfirm => 'Confirm Import';

  @override
  String get importCreate => 'Created';

  @override
  String get importDone => 'Import completed';

  @override
  String get importDownloadTemplate => 'Download Template';

  @override
  String get importErrors => 'Errors';

  @override
  String get importSelectFile => 'Select File';

  @override
  String get importSkipped => 'Skipped';

  @override
  String get importTemplateSaved => 'Template saved';

  @override
  String get importTitle => 'Import Products';

  @override
  String get importUpdate => 'Updated';

  @override
  String get importUploadHint => 'CSV or Excel supported';

  @override
  String get paymentCancelTimeout => 'Cancel Waiting';

  @override
  String get paymentDebt => 'On Credit';

  @override
  String get paymentDebtHint => 'Recorded as customer credit';

  @override
  String get paymentNewReceipt => 'New Receipt';

  @override
  String get paymentNoShift => 'Open a shift first';

  @override
  String get paymentPrintCopy => 'Print Copy';

  @override
  String get paymentProcessing => 'Processing payment';

  @override
  String paymentReceiptNumber(String number) {
    return 'Receipt #$number';
  }

  @override
  String get paymentSelectClient => 'Select Customer';

  @override
  String get paymentSuccess => 'Payment Complete';

  @override
  String get paymentTimeout => 'Payment timed out';

  @override
  String get posDelete => 'Remove';

  @override
  String get posEnterDiscount => 'Discount';

  @override
  String get posItemDiscount => 'Item Discount';

  @override
  String get posMultiAdd => 'Add Multiple';

  @override
  String get posParkCart => 'Hold Bill';

  @override
  String get posParkedCarts => 'Held Bills';

  @override
  String get posResume => 'Resume';

  @override
  String get posUndoRemove => 'Undo Remove';

  @override
  String get productsEdit => 'Edit Product';

  @override
  String get productsMargin => 'Margin';

  @override
  String get productsPurchasePrice => 'Purchase Price';

  @override
  String get productsSalePrice => 'Retail Price';

  @override
  String get productsStock => 'Stock';

  @override
  String get settingsBackup => 'Backup & Restore';

  @override
  String get settingsBackupExport => 'Export Backup';

  @override
  String get settingsBackupSub => 'Save and restore local database';

  @override
  String get settingsPrinter => 'Receipt Printer';

  @override
  String get settingsPrinterSub => 'Connection and test print';

  @override
  String get settingsReceiptFormat => 'Receipt Format';

  @override
  String get settingsReceiptFormatSub => 'Header, footer, and store details';

  @override
  String get settingsScanner => 'Barcode Scanner';

  @override
  String get settingsScannerSub => 'USB or camera scanner';

  @override
  String get settingsSyncStatus => 'Sync Status';

  @override
  String get settingsWebkassa => 'Fiscal Integration';

  @override
  String get settingsWebkassaLogin => 'Login';

  @override
  String get settingsWebkassPwd => 'Password';

  @override
  String get settingsWebkassaSub => 'Online fiscal receipt service';

  @override
  String get settingsWebkassaTestMode => 'Test Mode';

  @override
  String get shellNoNotifications => 'No notifications';

  @override
  String get switchCashier => 'Switch Cashier';

  @override
  String get shiftDeposit => 'Cash In';

  @override
  String get shiftDepositSuccess => 'Cash added to drawer';

  @override
  String get shiftDiscrepancyNote => 'Discrepancy note';

  @override
  String get shiftEnterAmount => 'Amount';

  @override
  String get shiftEnterNote => 'Note';

  @override
  String get shiftNoReceipts => 'No receipts in this shift';

  @override
  String get shiftOverdue24h => 'Shift open for over 24 hours';

  @override
  String get shiftOverdueWarning => 'Please close the shift on time';

  @override
  String get shiftPrintReport => 'Print Report';

  @override
  String get shiftReceiptList => 'Shift Receipts';

  @override
  String get shiftSkipDenomination => 'Skip Denomination Count';

  @override
  String get shiftManualTotalTitle => 'Enter Cash Total Manually';

  @override
  String get shiftManualTotalBody => 'Enter the counted cash total in the drawer. This replaces the denomination count.';

  @override
  String get shiftManualTotalLabel => 'Total Cash';

  @override
  String get shiftManualTotalClear => 'Reset';

  @override
  String get shiftWithdraw => 'Cash Out';

  @override
  String get shiftWithdrawSuccess => 'Cash removed from drawer';

  @override
  String get shiftXReport => 'X-Report';

  @override
  String posStockExceeded(String qty) {
    return 'Insufficient stock: $qty available';
  }

  @override
  String posParkedCartLabel(int itemCount, String total) {
    return '$itemCount items · $total';
  }

  @override
  String get paymentTerminalUnavailable => 'Payment terminal not connected';

  @override
  String get pinSelectCashier => 'Select Cashier';

  @override
  String pinCashierCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count profiles',
      one: '$count profile',
    );
    return '$_temp0';
  }

  @override
  String get pinSelectedPrefix => 'Selected: ';

  @override
  String get pinProceedToPin => 'Next → PIN';

  @override
  String get pinLastBadge => 'LAST USED';

  @override
  String get pinAdminTile => 'Administrator';

  @override
  String get pinAdminTileSubtitle => 'Email + password';

  @override
  String get pinNewCashier => 'New Cashier';

  @override
  String get posActionHistory => 'History';

  @override
  String get posActionPrintReceipt => 'Print Receipt';

  @override
  String get posActionReportX => 'X-Report';

  @override
  String get posActionReportZ => 'Z-Report';

  @override
  String get posActionDeposit => 'Cash In';

  @override
  String get posActionWithdraw => 'Cash Out';

  @override
  String get posActionOpenDrawer => 'Open Drawer';

  @override
  String get posActionGoodsCodes => 'Item Codes';

  @override
  String get posActionLock => 'Lock Screen';

  @override
  String get shellSwitchCashierTitle => 'Switch cashier?';

  @override
  String get shellSwitchCashierMessage => 'There are items in the cart. Switching cashier will clear the current sale. Continue?';

  @override
  String get shellSwitchCashierConfirm => 'Switch';

  @override
  String get managerOverrideTitle => 'Manager Approval Required';

  @override
  String get managerOverrideActionLabel => 'ACTION';

  @override
  String get managerOverrideLoginLabel => 'Manager Login';

  @override
  String get managerOverridePinLabel => 'Manager PIN';

  @override
  String get managerOverrideConfirm => 'Approve';

  @override
  String get managerOverrideCancel => 'Cancel';

  @override
  String get managerOverrideLocked => 'Locked for 30 sec after 3 failed attempts';

  @override
  String get managerOverrideNotFound => 'Login not found';

  @override
  String get managerOverrideWrongPin => 'Incorrect PIN';

  @override
  String get managerOverrideThisUser => 'This user';

  @override
  String managerOverrideInsufficientRole(String name) {
    return '$name is not authorized for this operation';
  }

  @override
  String get managerOverrideInactive => 'Account is deactivated';

  @override
  String get paymentRemaining => 'Remaining';

  @override
  String get posScanPrompt => 'Scan or search a medicine';

  @override
  String get posScanPromptHint => 'the last added item will appear here';

  @override
  String get platformSectionTitle => 'Platform';

  @override
  String get platformStandaloneTitle => 'Standalone Mode';

  @override
  String get platformStandaloneSubtitle => 'All data is stored on this device.';

  @override
  String get platformLinkedTitle => 'Connected to Platform';

  @override
  String get platformLinkedSyncing => 'Cloud sync is active';

  @override
  String get platformStorePrefix => 'Store';

  @override
  String get platformUnlinkAction => 'Disconnect';

  @override
  String get platformUnlinkSubtitle => 'Disconnect register from cloud — local data stays on this device';

  @override
  String get platformUnlinkConfirmTitle => 'Disconnect register?';

  @override
  String get platformUnlinkConfirmBody => 'All local data will stay on this device and cloud sync will stop.';

  @override
  String get platformUnlinkedByAdmin => 'Register was disconnected by administrator. Local data is preserved.';

  @override
  String get connectSkip => 'Skip — work offline';

  @override
  String get connectSkipHint => 'Run standalone on this device with all data stored locally.';

  @override
  String get standaloneTitle => 'Pharmacy POS Setup';

  @override
  String get standaloneSubtitle => 'All data is stored locally on this device. Create the owner account to manage the store and cashiers.';

  @override
  String get standaloneOwnerName => 'Owner Name';

  @override
  String get standaloneStoreName => 'Medical Store Name (optional)';

  @override
  String get standalonePin => 'PIN (4 digits)';

  @override
  String get standalonePinConfirm => 'Confirm PIN';

  @override
  String get standalonePinMismatch => 'PIN codes do not match';

  @override
  String get standaloneSaveError => 'Could not save setup data — please try again';

  @override
  String get standaloneDbError => 'Local database unavailable — please restart the app';

  @override
  String get standaloneStart => 'Start Pharmacy POS';

  @override
  String get standaloneBackToConnect => 'Back';

  @override
  String get syncStandalone => 'Local Mode';

  @override
  String get standaloneStoreDefault => 'Medical Store';

}
