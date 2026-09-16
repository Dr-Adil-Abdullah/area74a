# AI_ROADMAP.md

Statuses: ⬜ not started · 🟡 in progress · ✅ completed · ❌ cancelled (keep row) · ⏸️ paused · 🔄 needs rework

Updated: 15 Sep 2026.

## Current

**Phase 3 (Settings)** 🟡 — hub + store/currency/tax/discount + dictionaries on existing settings table.
POS still uses old money format until a later wiring change. Flutter SDK still missing in sandbox.

---

## Phase 1 — Understanding (no app code)

| Task | Status |
|---|---|
| Read AREA_72A_C / owner answers / tax spec | ✅ |
| Read real icybeard/pos-register (tables, POS, settings, packages, licence) | ✅ |
| Record that mosespace/pos-register is 404 | ✅ |
| Create/update AI_UNDERSTANDING.md against **actual** base | ✅ |
| Create AI_PROGRESS.md | ✅ |
| Create AI_ROADMAP.md | ✅ |
| Create PROPOSED_CHANGES.md (schemas + fork exceptions) | ✅ |
| Create CLEAN_COMPLETE_PROJECT_CONTEXT.md | ✅ |
| Owner approves PROPOSED_CHANGES.md | ✅ 15 Sep 2026 (C-parallel + Pharmacy POS + doctor=customer type) |

## Phase 2 — Foundation (after approval)

| Task | Status |
|---|---|
| Copy icybeard tree into this repo (keep md + Apache NOTICE) | ✅ |
| Force standalone boot; FeatureFlags.allDrift; never require API host | ✅ |
| Confirm `flutter analyze` / `flutter test` on the untouched fork | ⏸️ no Flutter SDK in sandbox |
| Add `app_en.arb`, default locale English | ⬜ |
| PKR display helper `Rs. 1,234/-`, date `DD/MM/YYYY` | 🟡 constants PKR/paisa; formatter not yet |
| Window default 1280×800 min 1024×768 (`window_manager`, small change) | ✅ |
| Branding strings: Pharmacy POS | ✅ |
| Map DO-NOT-TOUCH to real files | ✅ (see AI_UNDERSTANDING) |
| Document baseline packages = current pubspec | ✅ |

## Phase 3 — Settings framework (BUILD FIRST)

| Task | Status |
|---|---|
| Drift schemaVersion 8 (D1 tables + categories.kind) | ⏸️ no build_runner yet; JSON in `settings` table instead |
| Store Information screen | ✅ |
| Generic dictionary CRUD (add/edit/disable/search/up-down) | ✅ |
| Categories tree (product/expense/contact kinds, parent move) | 🟡 parent via sub-item; drag-drop later |
| Contact types | ✅ |
| Payment methods | ✅ |
| Units | ✅ |
| Dosage forms | ✅ |
| Tax rates + Tax Settings master switch (ON/OFF, name, %, incl/excl) | ✅ master switch; extra rates list later |
| Expense heads (hierarchical) | ✅ |
| Custom fields registry UI | ⬜ |
| Currency in Settings (code, symbol, subunit) | ✅ |
| Price tiers list (Retail/VIP/Doctor + add) | ✅ |
| Product kinds (Pharmacy/Veterinary + add) | ✅ |
| Discount basis (total vs profit) | ✅ setting only; POS not wired yet |
| Alert / backup / printer **keys** persisted (behaviour later) | ⬜ |
| Users & roles = reuse existing users feature | ⬜ |
| Theme & language (English default) | ⬜ |
| Tests for v8 migration + dictionary repo | ⬜ |

## Phase 4 — Medical database

| Task | Status |
|---|---|
| Drift schemaVersion 9 (batches, allocations, purchases, doctors, expenses, adjustments, audit, product add-columns) | ⬜ |
| Near-expiry query | ⬜ |
| Migration tests: fresh DB + upgrade from v8 | ⬜ |

## Phase 5 — Medicine management

| Task | Status |
|---|---|
| Extend products screen: generic, strength, dosage, company, MRP, doctor price | ⬜ |
| Validation: doctor ≤ retail; warn purchase > retail | ⬜ |
| Search by brand / generic / barcode | ⬜ |

## Phase 6 — Purchase & supplier

| Task | Status |
|---|---|
| Purchase invoice + lines with batch + expiry | ⬜ |
| Creates/updates `product_batches` in one transaction | ⬜ |
| Opening stock = a purchase (no CSV) | ⬜ |
| Purchase return | ⬜ |

## Phase 7 — Pricing tiers

| Task | Status |
|---|---|
| Retail vs doctor on the medicine | ⬜ |
| POS price_tier + optional doctor_id on receipt (small POS diff, approved separately) | ⬜ |

## Phase 8 — Expiry & alerts

| Task | Status |
|---|---|
| Hide expired from POS search/scan | ⬜ |
| ≤30 day warning at add-to-cart | ⬜ |
| Colour lists 7/30/60/90 + expired + low stock | ⬜ |

## Phase 9 — Stock

| Task | Status |
|---|---|
| Qty = SUM(batches); FEFO allocation on sale | ⬜ |
| receipt_item_batches written every sale | ⬜ |
| Stock adjustments (damage, expiry, correction) | ⬜ |
| Never negative; qty 0 hidden | ⬜ |
| WAC valuation | ⬜ |
| Android still read-only; manual file copy (encryption caveat) | ⬜ |

## Phase 10 — Android companion

| Task | Status |
|---|---|
| Search name/generic/barcode | ⬜ |
| Current stock, near-expiry, expired, low-stock, dashboard | ⬜ |
| Camera scan — **ask to add `mobile_scanner` first** | ⬜ |
| Full Android POS = bonus, not required | ⬜ |

## Phase 11 — Reports

| Task | Status |
|---|---|
| Daily/monthly/yearly sales, purchases | ⬜ |
| Expiry, stock valuation, P/L | ⬜ |
| Supplier ledger, doctor commission | ⬜ |
| Reuse shifts for X/Z | ⬜ |
| Charts package — **ask first** | ⬜ |

## Phase 12 — Printing

| Task | Status |
|---|---|
| ESC/POS 58 mm USB — **ask packages first** | ⬜ |
| Receipt: store, logo, item, batch, expiry, tax, barcode | ⬜ |
| A4 invoice via existing `pdf`/`printing` | ⬜ |
| `barcode_widget` for labels — **ask first** | ⬜ |

## Phase 13 — Backup & security

| Task | Status |
|---|---|
| Real backup/restore local folder + USB | ⬜ |
| Daily auto, 30-day retain | ⬜ |
| sqlite3mc key strategy documented + tested | ⬜ |
| Encryption of backup files: decide here | ⬜ |
| Audit log writers on key tables | ⬜ |

## Phase 14 — Expenses

| Task | Status |
|---|---|
| Expense entry against dynamic heads | ⬜ |
| Expense reports | ⬜ |

(Owner listed Expenses after Backup. Kept as last build phase. Numbering in original doc mixed 13 phases with 14 titles — this file has 1–14 so nothing is dropped.)

---

## Cancelled / parked

| Item | Status | Reason |
|---|---|---|
| Rewrite to Clean Architecture | ❌ | Owner 15 Sep 2026: keep base features/ + Riverpod |
| Require pos-server / gRPC | ❌ | Owner 15 Sep 2026: standalone only |
| Hardcoded GST 17% with no switch | ❌ | Tax Settings spec wins |
| Use mosespace/pos-register | ❌ | 404; icybeard is the base |
| Numbered raw SQL migration folder | ❌ | Base uses Drift schemaVersion |
| New `customers` table | ❌ | Base has `clients` |
| `cash_daily_summary` duplicate of `shifts` | ❌ proposed | Reuse shifts — confirm in PROPOSED_CHANGES |
| Unified `contacts` table | ✅ C-parallel | POS `clients` untouched; new `contacts` in v8/v9 |
| Rename `*_tiyin` → `*_paisa` | ⏸️ | Approved; wait for Flutter SDK + build_runner |
| Delete KZ/sync source | ⏸️ | Disable first; delete only with later approval |
| Web as Phase 1 target | ❌ | Option D remains future; no dart:io rewrite now |
| Git main/develop/feature in this Arena session | ❌ | Fixed branch `arena/01a0a641-area74a` |
