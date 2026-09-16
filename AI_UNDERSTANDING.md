# AI_UNDERSTANDING.md

Updated: 15 Sep 2026. Update this file only when scope or base understanding changes.

## 1. Project in one paragraph

Pakistan medical-store POS for a non-technical owner. Single shop today, extensible later.
Windows is the real till. Android is a companion (search / stock / expiry / low-stock) with
full POS as a bonus. 100% offline. Business lists (categories, tax, units, payment methods,
dosage forms, expense heads, users) live in the database and are edited from Settings.
Base: fork of [icybeard/pos-register](https://github.com/icybeard/pos-register) (Apache-2.0,
display name KeregePOS, Dart package `pos_system`). We customise — we do not rebuild.

## 2. What the base actually is (read from source, not from old notes)

Clone inspected at commit `9cb5f8c` (v0.2.2+6, 6 Aug 2026). ~93 Dart files under `lib/`,
~44k LOC, 37 test files, README claims analyze-clean and hundreds of tests.

### Stack (locked — do not replace)

| Layer | Actual |
|---|---|
| Flutter / Dart | SDK `^3.10.7`, Flutter 3.x |
| State | **Riverpod** `Notifier` (`flutter_riverpod` ^2.5.1) + leftover `provider` for a few leaves. Migrated off BLoC. |
| DB | **Drift 2.31/2.32** + SQLite WAL. Encrypted at rest via vendored sqlite3mc (SQLCipher-compat). `schemaVersion = 7`. |
| IDs | **TEXT UUID** already, on almost every table |
| Money | **INTEGER** already (`*_tiyin`, 1 KZT = 100 tiyin) |
| Auth | PIN + bcrypt (`bcrypt` + `pointycastle`). Roles: owner, admin, manager, senior_cashier, cashier |
| l10n | Russian + Kazakh ARB. **No English UI yet** |
| Printing | `printing` + `pdf`. Price-label PDF via API. **No ESC/POS package. Printer tile = “not connected”.** |
| Barcode | USB HID keyboard wedge intended. `scan_mode.dart` is an unwired scaffold. **No `mobile_scanner`.** |
| Platforms | Windows, Linux, macOS, Android, iOS. `web/` folder exists. CLAUDE.md: web is **not** a shipping target. `dart:io` is used in `database.dart` and several screens. |
| Android | `minSdk = flutter.minSdkVersion` (not pinned to 24 in Gradle). applicationId `kz.keregesystem.pos`. File is `android/app/build.gradle.kts` — there is **no** `build.gradle`. |
| Licence | Apache-2.0. Fork / modify / rebrand allowed. Keep LICENSE + NOTICE + attribution. |

### Folder layout (keep)

```
lib/
  main.dart                 (~1500 lines, app wiring)
  core/                     theme, l10n, constants, widgets, feature_flags
  data/database.dart        Drift AppDatabase + migrations v1→v7
  data/tables/              10 table files
  data/repositories/
  features/                 analytics, approval, audit, auth, clients,
                            delivery, products, sales, settings, setup, users
  services/                 api_client, print, sales, stock, sync, auth, …
  sync/                     puller / scheduler / worker (cloud)
  migration/                legacy Go pos.db → drift
```

There is **no** `domain/`, **no** use-case layer, **no** `presentation/` folder.
Old planning docs that assumed Clean Architecture were written for a different imagined repo.

### Tables that exist today

| Table | PK | Notes |
|---|---|---|
| `users` | UUID | pin_hash, role, is_active, updated_at |
| `settings` | (tenant_id, key) | string key/value only |
| `products` | UUID | name, barcode_gtin, category_id, purchase/sale unit + **tiyin** prices, is_weighted, vat_rate default **12**, is_active. **No generic, strength, dosage, company, batch, expiry, MRP, doctor price.** |
| `categories` | UUID | **already hierarchical** (`parent_id`), sort_order, is_active, updated_at. Extra KZ field `oktru_code`. |
| `suppliers` | UUID | name, phone, KZ `bin`, notes, is_active |
| `clients` | UUID | customers. name, phone, KZ `iin`, debt_limit, is_active. **There is no `customers` table.** |
| `stock_movements` | int autoinc + client_uuid | append-only delta log. Stock = `SUM(delta)` **per product**, not per batch. |
| `receipts` | UUID | sale **or** return (`is_return`, `refund_for_receipt_id`). Mixed pay: cash/card/qr/debt. Fiscal Webkassa fields. |
| `receipt_items` | UUID | line snapshot. **No batch_id, no expiry.** |
| `shifts` | UUID | X/Z foundation: cash float, running totals, receipt/return counts |
| `sync_outbox` / `sync_cursors` | — | cloud drain |

### What the base already gives us (reuse)

- Offline SQLite as source of truth, WAL, transactions
- Standalone first-run (“skip — work autonomously”) + local owner PIN
- POS cart, payment screen, returns, shift open/close
- Products / categories / clients / suppliers screens
- UUID + `is_active` + `updated_at` (LAN-sync-ready later)
- Integer money (same idea as paisa)
- bcrypt PIN, roles
- Hierarchical categories
- Receipts-as-returns (do **not** invent a second sales-return table unless batch restock needs it)
- Shifts for X/Z (do **not** invent `cash_daily_summary` as a duplicate)
- `uuid`, `bcrypt`, `pointycastle`, `printing`, `pdf`, `intl`, `mocktail`, `window_manager`
- Tests around repositories, sales, stock oversell guard, Z-report, bcrypt

### What the base does **not** give us (must add)

- Pharmacy fields, batches, FEFO, expiry alerts
- Purchases with batch entry, purchase returns
- Doctor / clinic / commission, doctor vs retail price
- Expenses + expense heads
- Dynamic Settings (the owner’s tree). Current Settings is platform-link, NKT, Webkassa, printer stub, backup snackbar
- ESC/POS thermal USB/COM; Android camera scan
- English UI, PKR display `Rs. 1,234/-`, date `DD/MM/YYYY`
- Tax master switch (inclusive / exclusive)
- Local backup/restore that actually writes a file
- Audit log table of INSERT/UPDATE/DELETE

### Kazakhstan / cloud — must not run in our product

Hardcoded or assumed today:

- Currency KZT, VAT 12% or 0%, NTIN/XTIN, NKT (nct.kz), Webkassa fiscalisation
- IIN / BIN / OKTRU
- `POS_API_HOST` / `env/prod.json` → `https://api.jurek.kz`
- Release build **refuses to boot** on a cleartext/localhost API host
- FeatureFlags default is **legacy Go server**, not drift
- Master data “owned by server, pulled to register”
- Branding: KeregePOS, bundle id `kz.keregesystem.pos`
- gRPC `Subscribe`, REST sync, proto submodule `pos-shared`
- `dart:io` in data layer (web-unready)

Owner decision 15 Sep 2026: **standalone only**. We will not require pos-server.
Do **not** delete this code in the first coding pass (golden rule: don’t remove “unused” code).
Disable it: default standalone, skip activation, never block on network, FeatureFlags → all-drift.

## 3. Locked owner decisions that override old planning text

| Topic | Locked |
|---|---|
| Base use | Copy full tree into this repo, then customise |
| Architecture | Keep `features/` + Riverpod. No Clean Architecture rewrite |
| Cloud | Standalone only |
| Tax | Settings master switch (ON/OFF + name + % + inclusive/exclusive) |
| Currency | PKR, integer paisa, receipt round to whole rupee, 2 decimals on lines |
| Language | English primary now; Urdu later |
| Stock qty | SUM of **batch** quantities. Never cache a product total |
| Valuation | Weighted average cost. FEFO is sell-order only |
| IDs | UUID text (already true) |
| Packages not in pubspec **and** not on the original approved list | Ask first |
| Out of scope | prescriptions, drug interactions, insurance, patients, multi-shop, FBR, e-commerce, CSV import now |

Q15 of the original “16 answers” was never recorded. Unknown. Do not invent it.

## 4. Old DO-NOT-TOUCH list is invalid

It named `core/`, `android/app/build.gradle`, Clean Architecture folders, “sale model”, “use cases”.
Those names do not match this repo. **New list:**

### 🔴 Forbidden without explicit owner approval

- Replacing Riverpod / adding BLoC back / adding GetX
- Changing folder layout (`lib/features`, `lib/data`, `lib/core`)
- Dropping or renaming existing Drift columns or tables
- Rewriting `pos_screen.dart` / `payment_screen.dart` / `main.dart` in one shot
- Removing packages from `pubspec.yaml`
- Deleting existing tests
- Editing already-applied Drift upgrades for schemaVersion 1–7
- Making login / sale / stock / search require the network
- Adding a package that is neither in current `pubspec.yaml` nor on the original approved list, without asking
- Rewriting `windows/runner/` CMake except window title/size if required
- Deleting Kazakhstan/sync files in the same commit as a feature (separate, later, approved cleanup)

### 🟢 Safe

- New Drift tables + `schemaVersion` 8, 9, … with add-only column migrations
- New files under `lib/features/settings/`, `lib/features/medicines/`, `lib/data/tables/`
- New tests
- English ARB (`app_en.arb`) and switching default locale
- Documentation
- FeatureFlags default → `allDrift` + force standalone (small, targeted)

## 5. Conflicts inside the owner’s own documents (resolved or parked)

| Conflict | Resolution |
|---|---|
| Q5 “GST 17% inclusive” vs Tax Settings switch | **Tax Settings wins** (15 Sep 2026). Default values when ON: name GST, 17%, inclusive. |
| Clean Architecture vs “match the base” | **Match the base.** |
| Parallel `contacts` + `customers` | This base has `clients` + `suppliers`, not `customers`. See PROPOSED_CHANGES — recommend **do not** add a third people system. |
| Integer-ID ALTER vs UUID | Base is already UUID. No ID-type migration. |
| “Paisa migration of money columns” | Columns are already INTEGER. Proposed fork exception: document unit as paisa; optionally rename `*_tiyin` → `*_paisa` **before any shop data exists**. Owner must confirm rename. |
| `cash_daily_summary` vs `shifts` | Reuse `shifts`. |
| `sale_returns` vs `receipts.is_return` | Reuse receipts; add batch allocation table. |
| Git `main/develop/feature/*` vs Arena | This session **must** stay on `arena/01a0a641-area74a`. |
| Repo name `area_72a` vs GitHub `area74a` | Real repo is **area74a**. |
| Option D “clean architecture from day one” vs keep-base | keep-base wins. Web-ready remains a **later** constraint; we will not rewrite `database.dart` off `dart:io` in Phase 1. |
| “Do not touch POS screens” vs FEFO / expiry warning / doctor price | POS **must** be extended later, in small diffs, with approval each time. Not in Settings phase. |

## 6. What I do not understand yet (do not guess)

1. Shop / window / APK **display name** (KeregePOS hata ke kya likhein?).
2. Doctor price at POS: toggle on the cart, customer type, or a “doctor sale” mode?
3. Q15 of the original 16 questions — missing.
4. Thermal printer model / 58 mm confirmed, but exact make unknown (any ESC/POS is OK per Q10).
5. Whether owner accepts **disable** of KZ/cloud code (keep files) vs **delete** in a later approved cleanup.
6. Whether `contacts` unified table is still required now that `clients`+`suppliers` exist.
7. Store legal name, address, phone, logo for receipts — not provided.
8. Low-stock default threshold (e.g. 10 units?) — Alert Settings will make it editable; need a seed default.
9. Weighted-average cost: per medicine across batches, or per batch then average? Proposal: per medicine, from purchase lines.
10. Data-volume estimates (Q13 left to AI): assume ~2–5k SKUs, ~10k batches/year, ~100–300 sales/day for a single shop — confirm if wildly wrong.

## 7. First steps after PROPOSED_CHANGES is approved

1. Copy icybeard/pos-register into this repo (keep our `*.md`, LICENSE/NOTICE from base).
2. Force standalone + FeatureFlags.allDrift so the app boots with zero network.
3. English locale + PKR display helpers (no schema yet).
4. Then Phase 3: Settings framework (dynamic lists) — everything else depends on it.
5. Then Phase 4: Drift schemaVersion 8+ medical / settings tables.

No application Dart until the owner replies **approve** on `PROPOSED_CHANGES.md`.
