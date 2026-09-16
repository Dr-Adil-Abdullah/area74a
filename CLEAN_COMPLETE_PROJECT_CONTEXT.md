# CLEAN_COMPLETE_PROJECT_CONTEXT.md

Merged working truth. Owner raw input stays in `AREA_72A_C.md`.
If this file disagrees with AREA_72A_C, AREA_72A_C wins unless a later owner answer
(recorded here with date) explicitly overrides it.

Last merge: 15 Sep 2026.

## Product

Professional medical-store POS. Personal use, one shop, may grow later (vet / hospital /
other business). Non-technical owner must run categories, contacts, tax, expenses, users
from Settings without calling a developer.

- Windows: full POS, `.exe`, default window 1280×800, min 1024×768
- Android: companion minimum (search, stock, near-expiry, expired, low-stock, dashboard). Full POS bonus
- One Flutter codebase
- Web: not now. Do not spend Phase 1 rewriting off `dart:io`. Keep new business logic free of platform APIs where cheap
- Offline always: login, sales, inventory, search, reports, printing, backup. Network must never block

Licence path: Apache-2.0 base → we can rebrand and extend.

## Base

https://github.com/icybeard/pos-register (icybeard, Apache-2.0).
`mosespace/pos-register` is dead (404).

Copy the full tree into https://github.com/Dr-Adil-Abdullah/area74a (this repo).
Customise. Do not write a second app.

## Decisions that override earlier planning (15 Sep 2026)

1. Fork + customise the real tree
2. Keep `lib/features/` + Riverpod — no Clean Architecture rewrite
3. Standalone only — cloud/server not required
4. Tax Settings specification (master switch) — not hardcoded GST 17%
   - When ON, seed: name `GST`, rate `17`, type `inclusive`
   - When OFF, no tax anywhere

## Money (Pakistan)

- Currency PKR, display `Rs. 1,234/-`
- Storage: integer paisa (`525.50` → `52550`)
- Line items: 2 decimal display; **final receipt total rounds to whole rupee**
- Discounts: per-line and per-invoice, % and fixed
- Base columns are already integer (`*_tiyin`). Same storage idea. Display/semantics become paisa.
- Rename `*_tiyin` → `*_paisa` only if owner approves the fork exception in `PROPOSED_CHANGES.md` (no live shop data yet)

## Tax (Settings)

Enable Tax System ON/OFF.
If ON: Tax Name, Default Rate %, Inclusive in MRP **or** Exclusive on the bill.
Multiple rates table (GST 17%, 5%, …) still exists for per-item override later.
Expired/near-expiry/FEFO rules are independent of tax.

## People

Owner originally: keep `customers` + add `contacts`.
This base has `clients` (POS customers) + `suppliers`. No `customers` table.
**Proposal (needs approve):** do not add a parallel `contacts` table. Keep `clients` for walk-in/credit customers, `suppliers` for vendors, new `doctors` for commission. Add `contact_types` as a Settings list and optional `type_id` columns. See PROPOSED_CHANGES.

## Stock

- Quantity on hand = `SUM(product_batches.quantity)` (qty > 0 sellable)
- FEFO: earliest expiry batch sells first
- Expired batch: hidden from POS
- Near-expiry ≤30 days: POS warning; colour bands 7/30/60/90 in alerts
- Qty 0 batch: hidden
- Never negative stock
- Damage/expiry: stock adjustment, never delete the batch row
- Every sale line records batch id
- Valuation: weighted average cost, not FEFO cost
- `stock_movements` stays as the audit delta log

## Medical product fields

Brand name, generic name, strength, dosage form, company, batch number, expiry,
purchase price, retail price, doctor price, MRP.
Warn if purchase > retail. Doctor price ≤ retail.

## Users

Roles for **our** product: Admin (full), Cashier (sales only), Manager (reports + limited).
Base also has owner / senior_cashier — map, don’t explode the enum in Phase 1.
PIN/password: bcrypt (already in base). Reset: Admin only; emergency = direct DB.
Audit log: INSERT/UPDATE/DELETE on key tables (new table, later phase).

## Hardware (provisional)

- USB HID scanner (keyboard wedge) — Windows
- Android camera scan — later package `mobile_scanner` (ask before add)
- Thermal any ESC/POS, USB primary, 58 mm. Packages not yet in pubspec — ask before add
- Receipt: store name, logo, items + batch + expiry, tax, barcode
- Cash drawer: not now
- Barcode generation for items without manufacturer codes: Phase 11, `barcode_widget` (ask before add)

## Language / formats

English UI now. Urdu later. Date `DD/MM/YYYY`.

## Backup (provisional)

Local folder + USB, daily auto, 30 days retain. Encryption decide in Phase 12.
Base Settings backup is a stub (snackbar). Must be built for real.
Note: DB file is SQLCipher-encrypted with a per-device key. Backup must copy the
key strategy or export a usable file — detail in Phase 12. Do not pretend copy-paste
of `pos.drift.sqlite` alone is enough without the key.

## Sync

Phases 1–8: Android read-only via **manual DB file copy** (after we solve encryption/key).
Phase 9: LAN Wi-Fi. Design: UUID + `updated_at` + `is_active` (already on base tables).
Cloud optional future. Must never block.

## Out of scope

Prescriptions, drug interactions, insurance, patients, multi-shop, FBR, e-commerce,
CSV import (now).

## Packages

**Baseline = current icybeard `pubspec.yaml`** (drift, riverpod, uuid, bcrypt, printing, pdf, …).
Those are already in the fork; we do not re-ask for them.

**Original approved-but-not-in-base** (ask again only when the phase needs them):
data_table_2, fl_chart, flutter_form_builder, dropdown_search, flutter_speed_dial,
flutter_slidable, mobile_scanner, esc_pos_utils, esc_pos_printer,
flutter_local_notifications, file_picker, share_plus, excel, csv, archive, fuzzywuzzy,
barcode_widget.

Anything else: ask first.

## Phases (same 13 + foundation)

See `AI_ROADMAP.md`. Settings framework first after the fork boots standalone.

## Standing order

**NO application code until owner approves `PROPOSED_CHANGES.md`.**
After approve: copy base → standalone boot → Settings.
