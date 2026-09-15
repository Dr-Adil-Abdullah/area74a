# PROPOSED_CHANGES.md

**Status: WAITING FOR OWNER APPROVAL — no application code until you say approve.**

Date: 15 Sep 2026.
This is the AI’s proposal after reading the real [icybeard/pos-register](https://github.com/icybeard/pos-register) source.
It replaces the old imagined schemas (integer IDs, `customers` table, numbered SQL files, Clean Architecture folders).

Reply with: **approve** / **approve with notes** / **change X**.

---

## A. Fork exception (do this once, before any shop data)

We have **zero pharmacy data**. A live-DB rule of “never rename columns” still applies **after** the first real backup. Before that, three one-time fork cleanups prevent Kazakhstan names from living in a Pakistan app forever.

| # | Proposal | Why | Risk if we skip |
|---|---|---|---|
| A1 | Copy full icybeard tree into this repo. Keep Apache LICENSE + NOTICE. Keep our `*.md`. | Owner: fork then customise | Cannot reuse 60–80% |
| A2 | Default **standalone**. Skip activation. Do not call `api.jurek.kz`. FeatureFlags → `allDrift`. Release must boot **without** `POS_API_HOST`. | Owner: standalone only; internet may die | App hangs on launch (known upstream bug) |
| A3 | **Money unit = paisa.** Keep INTEGER columns. **Rename** `*_tiyin` → `*_paisa` in Drift tables **in this fork commit only** (products, receipts, receipt_items, shifts, clients.debt_limit). | Names must match Pakistan. No live rows. | Developers forever think in tenge |
| A4 | `products.vat_rate` default **12 → 0**. Real tax comes from Tax Settings, not a KZ constant. | Tax switch | Silent 12% VAT on medicines |
| A5 | Do **not** delete sync/NKT/Webkassa/gRPC files in the fork commit. Hide/disable only. | Golden rule: don’t remove “unused” code yet | Big risky diff |

**Need a yes/no on A3.** Recommendation: **YES, rename now.**

---

## B. What we will NOT build (reuse instead)

| Old planned table | Reuse |
|---|---|
| `customers` | `clients` |
| `sale_returns` + `sale_return_items` | `receipts.is_return` + `receipt_items` + new **batch allocation** rows |
| `cash_daily_summary` | `shifts` (already has cash/card/qr/debt/returns totals) |
| New integer IDs | Already UUID |
| Numbered raw SQL migration files | Drift `schemaVersion` 8, 9, … in `database.dart` `onUpgrade`. Never edit v1–v7. |
| Parallel Clean Architecture tree | Keep `lib/features/` + Riverpod |
| `contacts` unified table | **Recommend skip** — see C |

---

## C. People model (needs owner confirm)

Owner Q4: keep customers + add contacts (suppliers/doctors/wholesalers).
Reality: `clients` + `suppliers` already exist.

**Recommendation (C-reuse):**

- POS walk-in / credit customer → `clients` (untouched fields; add-only columns later)
- Vendors → `suppliers` (add-only)
- Doctors → **new** `doctors` table (commission, specialisation, clinic)
- Settings list `contact_types` (Customer, Supplier, Doctor, Wholesaler, …) for labels + future
- Optional `type_id` TEXT on clients/suppliers, default empty
- **No** `contacts` table — a third people system will desync POS

Alternative (C-parallel): add `contacts` anyway, leave `clients` for POS. Two customer lists. I advise against.

**Need: C-reuse or C-parallel. Recommendation: C-reuse.**

---

## D. Drift migrations (add-only)

All new tables: `id TEXT PK` (UUID), `is_active DEFAULT 1`, `created_at`, `updated_at`,
`sort_order DEFAULT 0` where the Settings list can reorder.
Money: `INTEGER` paisa. FK `ON DELETE RESTRICT` unless noted.
Soft delete only.

Schema versions (proposed):

- **v8** — settings dictionaries (no POS behaviour change)
- **v9** — medical columns on `products` + `product_batches` + allocation + purchases + doctors + expenses + adjustments + audit
- Later versions one feature at a time if v9 is too large — **recommendation: split v8 / v9** as above so Settings can ship first

### D1. schemaVersion 8 — Settings dictionaries

```
store_profiles
  id TEXT PK
  name TEXT NOT NULL DEFAULT ''
  address TEXT NOT NULL DEFAULT ''
  phone TEXT NOT NULL DEFAULT ''
  logo_path TEXT NULL
  receipt_footer TEXT NOT NULL DEFAULT ''
  updated_at DATETIME NOT NULL

contact_types
  id TEXT PK
  name TEXT NOT NULL
  sort_order INT DEFAULT 0
  is_active INT DEFAULT 1
  created_at, updated_at

-- categories table ALREADY exists (UUID, parent_id, sort_order, is_active).
-- ADD COLUMN only:
--   kind TEXT NOT NULL DEFAULT 'product'
--     check in app: product | expense | contact
-- Do not drop oktru_code (KZ). Leave it nullable, unused.

payment_methods
  id TEXT PK
  name TEXT NOT NULL          -- Cash, Card, JazzCash, EasyPaisa, …
  sort_order, is_active, created_at, updated_at

units
  id TEXT PK
  name TEXT NOT NULL          -- Piece, Box, Strip, ml, …
  sort_order, is_active, created_at, updated_at

dosage_forms
  id TEXT PK
  name TEXT NOT NULL          -- Tablet, Syrup, Injection, …
  sort_order, is_active, created_at, updated_at

tax_rates
  id TEXT PK
  name TEXT NOT NULL          -- GST, …
  rate_bp INT NOT NULL        -- 1700 = 17.00%  (basis points, integer, no floats)
  is_default INT DEFAULT 0
  sort_order, is_active, created_at, updated_at

expense_heads
  id TEXT PK
  name TEXT NOT NULL
  parent_id TEXT NULL         -- hierarchical
  sort_order, is_active, created_at, updated_at

custom_fields
  id TEXT PK
  entity TEXT NOT NULL        -- product | client | supplier | doctor | expense
  name TEXT NOT NULL
  field_type TEXT NOT NULL    -- text | number | date | bool
  sort_order, is_active, created_at, updated_at

-- Tax master switch lives in existing `settings` key/value:
--   tax.enabled = 'true' | 'false'
--   tax.name = 'GST'
--   tax.default_rate_bp = '1700'
--   tax.type = 'inclusive' | 'exclusive'
-- Alert / backup / printer keys also in `settings` (no new table).
```

Seed on first run (only if table empty): Cash, Card, JazzCash, EasyPaisa; Piece, Box, Strip, ml; Tablet, Syrup, Capsule, Injection, Cream, Drops; GST 17% default; expense heads Rent, Salary, Utilities, Other; contact types Customer, Supplier, Doctor.

### D2. schemaVersion 9 — Medical + purchases + people extra + audit

**products — ADD COLUMN only (never drop KZ columns):**

```
generic_name TEXT NOT NULL DEFAULT ''
strength TEXT NOT NULL DEFAULT ''
dosage_form_id TEXT NULL
company TEXT NOT NULL DEFAULT ''
mrp_paisa INT NOT NULL DEFAULT 0
doctor_price_paisa INT NOT NULL DEFAULT 0
low_stock_threshold INT NOT NULL DEFAULT 10
-- retail = existing sale_price_* ; purchase = existing purchase_price_*
```

```
product_batches          -- MOST CRITICAL
  id TEXT PK
  product_id TEXT NOT NULL          -- FK products RESTRICT
  batch_number TEXT NOT NULL
  expiry_date DATE NOT NULL
  quantity INT NOT NULL DEFAULT 0   -- never negative; 0 = hidden from POS
  purchase_price_paisa INT NOT NULL DEFAULT 0   -- this batch's cost (WAC input)
  supplier_id TEXT NULL
  purchase_item_id TEXT NULL
  is_active INT DEFAULT 1           -- false = written off, row remains
  created_at, updated_at
  UNIQUE(product_id, batch_number)

receipt_item_batches     -- FEFO allocation (sale AND return)
  id TEXT PK
  receipt_item_id TEXT NOT NULL
  batch_id TEXT NOT NULL
  quantity INT NOT NULL             -- positive; returns also positive + receipts.is_return
  created_at

purchases
  id TEXT PK
  supplier_id TEXT NOT NULL
  invoice_number TEXT NOT NULL DEFAULT ''
  purchased_at DATETIME NOT NULL
  total_paisa INT NOT NULL DEFAULT 0
  notes TEXT NOT NULL DEFAULT ''
  is_active INT DEFAULT 1
  created_at, updated_at

purchase_items
  id TEXT PK
  purchase_id TEXT NOT NULL
  product_id TEXT NOT NULL
  batch_number TEXT NOT NULL
  expiry_date DATE NOT NULL
  quantity INT NOT NULL
  purchase_price_paisa INT NOT NULL
  retail_price_paisa INT NOT NULL DEFAULT 0
  line_total_paisa INT NOT NULL
  created_at

purchase_returns
  id TEXT PK
  purchase_id TEXT NOT NULL
  supplier_id TEXT NOT NULL
  returned_at DATETIME NOT NULL
  total_paisa INT NOT NULL DEFAULT 0
  notes TEXT NOT NULL DEFAULT ''
  created_at, updated_at

purchase_return_items
  id TEXT PK
  purchase_return_id TEXT NOT NULL
  purchase_item_id TEXT NULL
  product_id TEXT NOT NULL
  batch_id TEXT NOT NULL
  quantity INT NOT NULL
  line_total_paisa INT NOT NULL
  created_at

doctors
  id TEXT PK
  name TEXT NOT NULL
  specialisation TEXT NOT NULL DEFAULT ''
  clinic TEXT NOT NULL DEFAULT ''
  phone TEXT NOT NULL DEFAULT ''
  commission_bp INT NOT NULL DEFAULT 0   -- 500 = 5.00%
  is_active INT DEFAULT 1
  created_at, updated_at

-- receipts ADD COLUMN:
--   doctor_id TEXT NULL
--   price_tier TEXT NOT NULL DEFAULT 'retail'   -- retail | doctor

stock_adjustments
  id TEXT PK
  batch_id TEXT NOT NULL
  product_id TEXT NOT NULL
  reason TEXT NOT NULL          -- damage | expired | correction | return_to_stock | recount
  quantity_delta INT NOT NULL   -- signed
  notes TEXT NOT NULL DEFAULT ''
  user_id TEXT NULL
  created_at

expenses
  id TEXT PK
  expense_head_id TEXT NOT NULL
  amount_paisa INT NOT NULL
  spent_at DATETIME NOT NULL
  notes TEXT NOT NULL DEFAULT ''
  payment_method_id TEXT NULL
  created_at, updated_at

audit_log
  id TEXT PK
  at DATETIME NOT NULL
  user_id TEXT NULL
  table_name TEXT NOT NULL
  row_id TEXT NOT NULL
  action TEXT NOT NULL          -- insert | update | delete
  before_json TEXT NULL
  after_json TEXT NULL
```

**Near-expiry:** not a table. Drift query / view:

```sql
SELECT b.*, p.name, p.generic_name
FROM product_batches b
JOIN products p ON p.id = b.product_id
WHERE b.quantity > 0 AND b.is_active = 1
  AND b.expiry_date <= DATE('now', '+90 days')
ORDER BY b.expiry_date ASC;
```

Colour: ≤0 expired, ≤7, ≤30, ≤60, ≤90.

---

## E. Stock maths (locked rules → code)

```
sellable(product) = SUM(quantity) FROM product_batches
                    WHERE product_id=? AND is_active=1 AND quantity>0
                      AND expiry_date > today()

FEFO pick: ORDER BY expiry_date ASC, created_at ASC
           skip qty=0, skip expired, skip is_active=0

On sale of N units:
  while N>0: take next FEFO batch, allocate min(N, batch.qty),
             write receipt_item_batches, decrement batch.qty,
             insert stock_movements delta = -allocated (reason=sale)
  if cannot fill N: refuse (no negative)

Weighted average cost (valuation, not sell order):
  WAC(product) = SUM(batch.quantity * batch.purchase_price_paisa)
                 / SUM(batch.quantity)
                 over active batches with quantity>0
                 (include expired still-on-shelf for valuation? 
                  YES — they still have cost until adjusted out)
  stock_value = SUM over products of (qty_on_hand * WAC)

Purchase line: INSERT purchase_item + INSERT/increment product_batches
               in ONE transaction.
```

Warn at POS if nearest allocated batch expiry ≤ 30 days.
Expired never appears in search/scan results.

Purchase price > retail → warn (do not hard-block unless you say so).
Doctor price > retail → block save.

---

## F. Tax application (when we touch POS — not in Settings phase)

Read `settings` keys.

- OFF → vat/tax amounts 0, prices unchanged
- ON + inclusive → printed price = MRP; show tax portion
  `tax = round(mrp * rate / (100 + rate))` using integer paisa, then
  receipt **total** rounded to whole rupee (paisa % 100 → nearest rupee)
- ON + exclusive → line = retail, tax added on top, then whole-rupee total

Default seed when owner first enables: GST / 17% / inclusive.

---

## G. Settings UI (Phase 3) — behaviour

Every dictionary row: add, edit, disable/enable (never DELETE FROM), search/filter.
Reorder: `sort_order` via up/down in v1 (drag-and-drop needs a package — **ask before** `flutter_slidable` / reorderable). Recommendation: up/down first, drag later.

Categories: unlimited parent_id depth, move to another parent, `kind` = product | expense | contact.

Store Information edits `store_profiles` (single row).

Users & Roles: reuse `users` screen; don’t rebuild.

Theme & Language: English default; Urdu later (placeholder).

Printer / Alert / Backup: **screens exist as stubs** — real behaviour in Phases 11–12. Phase 3 only persists keys (expiry bands 7/30/60/90, low-stock default 10, backup folder path).

---

## H. Packages for Phase 3 (Settings)

**None new.** Forms = Flutter material. Lists = existing widgets.
When a later phase needs `data_table_2` / `dropdown_search` / `flutter_form_builder`, we ask.

---

## I. Explicitly out of this proposal

- ESC/POS, camera scanner, barcode_widget
- LAN sync
- Deleting `lib/sync`, proto, NKT, Webkassa
- Rewriting POS cart
- English translation of every Russian string (Phase 2 will add `app_en.arb` and default to it; untranslated keys can fall back — we will not paste 1000 translations in the fork commit)
- Window size 1280×800 (small `window_manager` change in Phase 2, allowed)

---

## J. Approval checklist (owner)

Please tick in your reply:

- [ ] A1 Copy base tree into area74a
- [ ] A2 Standalone default, no cloud boot
- [ ] A3 Rename `*_tiyin` → `*_paisa` in the fork (yes/no)
- [ ] A4 vat_rate default 0
- [ ] A5 Keep KZ/sync files, disabled
- [ ] C-reuse people (no `contacts` table) **or** C-parallel
- [ ] D1 v8 settings tables
- [ ] D2 v9 medical / purchase / doctors / expenses / audit
- [ ] E stock maths
- [ ] F tax switch behaviour
- [ ] G Settings UX (up/down now, drag later)
- [ ] H no new packages in Phase 3

**Recommendation: approve all, with A3=yes and C-reuse.**

After your approve, next commit is the fork copy + A2 standalone boot, still **no** v8 tables until Phase 3 starts.
