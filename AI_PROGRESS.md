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

### Cumulative stats

- Sessions: 1
- App Dart files changed: 0
- Docs files: 8
- Broken items in **our** repo: none (no app yet)
- Technical debt: listed in issues above; all in the *base*, not introduced by us

---
