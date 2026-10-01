# AI_PROGRESS.md

Never delete old sessions. Archive only after 5,000 lines.

---

## Session 1 — 15 Sep 2026

**Agent:** Arena.ai Agent Mode  
**Branch:** `arena/01a0a641-area74a`  
**Repo:** https://github.com/Dr-Adil-Abdullah/area74a  
**Phase:** 1 Understanding  
**App code written:** none (standing order)

### Goal

Owner asked: find problems / future conflicts first; explain in Urdu; use
https://github.com/icybeard/pos-register as the code reference; ask before guessing.

### What was done

1. Confirmed this GitHub repo was empty (`README.md` only, `# area74a`).
2. Confirmed `mosespace/pos-register` is **404**.
3. Cloned and read `icybeard/pos-register` (v0.2.2+6, Apache-2.0, Drift, Riverpod,
   UUID, integer money, standalone mode, Kazakhstan retail POS named KeregePOS).
4. Mapped tables, Settings (stub vs owner tree), POS, printing (no ESC/POS),
   barcode (USB intended, camera package absent), FeatureFlags, `dart:io`,
   release API-host boot trap.
5. Asked 4 blocking questions. Owner answers:
   - Base: **fork/copy then customise**
   - Architecture: **keep features/ + Riverpod**
   - Cloud: **standalone only**
   - Tax: **Tax Settings master switch**
6. Wrote tracking + proposal files (this commit). No Dart/Flutter copied yet.

### Files created

- `READ_ME_FIRST.md`
- `AREA_72A_C.md` (owner input only, plus the 4 dated answers)
- `AI_UNDERSTANDING.md`
- `CLEAN_COMPLETE_PROJECT_CONTEXT.md`
- `PROPOSED_CHANGES.md`
- `AI_ROADMAP.md`
- `AI_PROGRESS.md` (this file)
- `README.md` updated

### Database changes

None.

### Packages added

None.

### Tests added

None.

### Git commits this session

(filled after commit)

### Verified

- icybeard README, LICENSE Apache-2.0, pubspec, `database.dart` schemaVersion 7
- tables: users, settings, products, categories, suppliers, clients,
  stock_movements, receipts, receipt_items, shifts, sync_*
- products have **no** batch/expiry/generic/MRP/doctor price
- Settings screen is platform/NKT/Webkassa/printer-stub, not dynamic dictionaries
- `print_service.dart` prints PDF labels via API, not ESC/POS
- `scan_mode.dart` not wired to POS

### Issues / future conflicts found (not code-fixed; documented)

1. Base is Kazakhstan cloud-oriented till, not a pharmacy.
2. Old DO-NOT-TOUCH / Clean Architecture / customers / integer-ID plan does not match source.
3. Q5 GST 17% vs Tax Settings switch → **switch wins**.
4. Q4 contacts+customers vs actual `clients`+`suppliers` → waiting C-reuse vs C-parallel.
5. Money already integer tiyin; rename to paisa waiting A3.
6. Release build can hang without `POS_API_HOST` — must force standalone.
7. DB encrypted (sqlite3mc); naive file copy backup will fail without the key.
8. Web-ready vs `dart:io` in data layer — parked until later.
9. Q15 never recorded.
10. Repo named area74a, docs said area_72a.
11. Arena session cannot use main/develop/feature git flow.
12. POS **must** be touched later for FEFO/expiry/doctor price despite old “don’t touch POS”.
13. Printer, backup, card terminal are stubs.
14. Default FeatureFlags = legacy Go server, not drift.

### Blockers

- Owner must approve `PROPOSED_CHANGES.md` (especially A3 rename tiyin→paisa, C people model).
- Shop display name unknown.
- Doctor-price UX at POS unknown.
- Store name/address/phone/logo unknown (Settings can fill later).

### Handoff

- **Current phase/task:** Phase 1, waiting approval.
- **Last completed:** source audit + docs + 4 decisions saved.
- **Next step:** owner replies on PROPOSED_CHANGES → copy base → Phase 2 standalone boot.
- **Uncommitted:** none after this session’s commit.
- **Do not:** start Dart, add packages, or copy the fork until approval.

---

## Session 2 — 15 Sep 2026

**Phase:** 2 Foundation  
**App code:** yes (fork + standalone boot)

### Owner answers this session

- PROPOSED_CHANGES: **approve recommended**
- People: **C-parallel** (contacts table yes; clients stay for POS)
- App name: **Pharmacy POS**
- Doctor price: customer type Doctor → auto doctor price

### What was done

1. Copied icybeard/pos-register tree into this repo (Apache LICENSE/NOTICE kept; our md files kept).
2. Standalone-only boot: first screen is local owner+PIN, not cloud activation.
3. `FeatureFlags.allDrift` so screens read Drift, not the Go/HTTP legacy path.
4. `assertApiHostIsSecure` is a no-op (release no longer hangs without POS_API_HOST).
5. Tenant/workstation for sales loaded from `StandaloneStore` so `SalesService` is not disabled.
6. Window 1280×800, min 1024×768, not fullscreen.
7. Branding: Pharmacy POS / PAKISTAN on Windows, Linux, Android label, PIN, sidebar, l10n titles.
8. Currency constants: PKR / paisa. `vat_rate` Dart default 0.
9. A3 column rename **not** done (needs build_runner + tests; no Flutter in sandbox).

### Files created / modified (high level)

- Entire upstream Flutter tree (`lib/`, `android/`, `windows/`, `test/`, `third_party/sqlite3mc`, …)
- Targeted: `lib/main.dart`, `lib/core/constants/app_constants.dart`, `lib/features/auth/controllers/auth_controller.dart`, branding, `pubspec.yaml`

### Database changes

None applied (schemaVersion still 7). products.vat_rate default in Dart is 0 for **new** DBs.

### Packages added

None (baseline = upstream pubspec).

### Tests added

None. `flutter test` not run — Flutter SDK missing in this environment.

### Blockers

- Flutter SDK not installed here → cannot analyze/test/build Windows or APK.
- A3 tiyin→paisa still pending.
- English ARB not added yet.
- Contacts table not created yet (Phase 3/4).

### Handoff

- Next: on a machine with Flutter: `flutter pub get && flutter analyze && flutter test`.
- Then Phase 3 Settings (schemaVersion 8) after a short CHANGE PROPOSAL for the first settings tables.
- Uncommitted: this session’s fork + patches (committed after this note).

### Cumulative stats

- Sessions: 2
- Fork + standalone patches in repo
- Flutter verify: not yet (no SDK in sandbox)

---

## Session 3 — 15 Sep 2026

**Phase:** 3 Settings (start)

### Owner (Urdu)

Nothing business-related must be hardcoded. Currency symbol changeable. Shop details
changeable. Customer fields later-editable. Pharmacy vs veterinary details. Prices:
simple, VIP, doctor. Discount on total **or** profit. One Settings folder.
Offline last-data; upload when net returns. Web OK if better.
Asked how Flutter is tested.

### Decisions

- Flutter now, web later
- Currency in Settings, default PKR / Rs.
- Price tiers: Retail, VIP, Doctor + owner can add more
- Start Settings now

### What was done

Settings hub on existing `settings` key/value (no new Drift tables — Flutter SDK
install failed here, so no `build_runner`).
Screens: store, currency, tax switch, discount basis, dictionaries
(categories, kinds, units, dosage, price tiers, contact types, payments, expense heads).
Old hardware Settings remains under Advanced.

Not yet: POS/receipts reading the new currency/tax/tiers; custom fields UI;
schemaVersion 8 SQL tables.

### Handoff

Next: wire Money.format + POS price tier from these keys (small approved change),
or custom fields, when Flutter is available for tests.

---

## Session 4 — 15–16 Sep 2026 & 1 Oct 2026

**Phase:** 2 & 3 & 5 & 7 (Wiring & Offline Completion)  
**App code:** yes

### What was done

1. **MoneyConfig & PriceBook (`2fe2fb6`, `f6977ba`) + `HOW_TO_TEST.md` (`2db14c3`)**:
   - Added `MoneyConfig` (`Rs.`, `PKR`, tax master switch ON/OFF, inclusive/exclusive) and `PriceBook` (`Retail`, `VIP`, `Doctor` extra tiers stored in `settings` under `map.product_prices`).
   - Added unit tests `test/core/utils/money_config_test.dart` and `test/core/utils/price_book_test.dart`.
2. **Step 1 — Wire `PharmacySettingsHome`, `PriceBook.resolve`, and First-Run Hydration**:
   - Wired `PharmacySettingsHome` into `_MainShell` (`_PageId.settings` in `lib/main.dart`) and the POS Settings action tile (`lib/features/sales/screens/pos_screen.dart`).
   - Wired `PriceBook.resolve` into `SalesController.addToCart`, `SalesController.setCustomerType` (including live re-pricing of items already in the cart when switching Customer / VIP / Doctor chips, using `CartItem.effectiveRetailPrice`), and `_SearchResultsOverlay` in `PosScreen`.
   - Fixed first-run `_activeTenantId` / `_activeWorkstationId` hydration in `_PosAppState` so completing `StandaloneSetupScreen` immediately activates local Drift repositories, seeds `PharmacySettingsStore` (including the owner's `storeName`), and hydrates `MoneyConfig` without needing an app restart.
3. **Step 2 — 100% Offline Drift Execution for Products, POS Search/Scan, Shifts/Z-Report, and Cashiers**:
   - `ProductsScreen`: wired Create, Edit, and Delete to local `ProductRepository`; exposed `PurchasePrice` via `ProductCatalogEntry.toLegacyMap()`; filtered out soft-deleted (`isActive: false`) products; added price validation (`Doctor <= Retail`, confirmation warning when `Purchase > Retail`).
   - `SalesController`: wired `searchProduct`, `scanBarcode`, and `loadCategories` to local `ProductCatalogService` and `CategoryRepository` when available, while keeping the legacy `ApiClient` fallback for existing unit tests.
   - `ShiftScreen`, `ShiftCloseScreen`, `XReportSheet`, `_MainShell._loadShift`, and POS cash deposit/withdraw: wired to local `ShiftRepository` and `ReceiptRepository` for all roles (including `owner`); fixed PKR denomination calculation and replaced broken named routes (`'/pos'`, `'/shift-close'`, `'/returns'`) with direct callbacks / `MaterialPageRoute`.
   - `CashiersScreen`: wired list, create, edit, PIN reset (`BCrypt`), and deactivate to local `CashierRepository`.
4. **Step 3 — English Localization (`app_en.arb` + `AppLocalizationsEn` + Default `'en'`)**:
   - Created `lib/core/l10n/app_en.arb` and `lib/core/l10n/app_localizations_en.dart` implementing all 488 localization members in English for Pakistan Pharmacy POS (`PKR` / `Rs.`, `NTN / CNIC`, `Card / JazzCash / EasyPaisa`, etc.).
   - Registered `Locale('en')` as the first supported locale in `AppLocalizations.supportedLocales`, added `'en'` to `LocaleStore._supported`, and set the default app locale to `'en'` in `lib/main.dart` (`_toggleLocale` switches `'en'` ↔ `'ru'`).
   - Translated hardcoded Russian UI strings in `HifiChrome`, `HifiTotals`, `PosScreen`, `ShiftScreen`, `ShiftCloseScreen`, `XReportSheet`, `ReturnsScreen`, `DebtsScreen`, `ProductsScreen`, `ImportScreen`, `AuditScreen`, `CashiersScreen`, `PinScreen`, `SyncStatusChip`, and `SyncStatusSheet` to English while preserving strings directly asserted by existing unit/widget tests in `test/`.

### Tests updated

- `test/features/sales/controllers/sales_controller_test.dart`: added test for `setCustomerType` + `PriceBook.resolve` on `addToCart` and live cart re-pricing across `Customer` → `VIP` → `Doctor` → `Customer`.

