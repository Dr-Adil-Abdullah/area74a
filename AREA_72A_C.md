# AREA_72A_C — USER INPUT ONLY

What this file is: everything the project owner has provided — every requirement,
every decision, every instruction, every link — from the whole conversation.
What this file is NOT: AI analysis, AI recommendations, code audit findings, proposed
schemas, or a task roadmap. None of the AI's derived work is in here.

Sources: the owner's COMPLETE_PROJECT_CONTEXT v1.0 document, the owner's answer sheet
to 16 questions, the owner's Tax Settings specification, the owner's link correction, and
the owner's handover instructions.

Language: kept in English (technical accuracy). Owner communicates in Urdu / Roman-Urdu.

Additional owner decisions captured 15 Sep 2026 (Arena session), after seeing the real
icybeard/pos-register codebase:

- Base strategy: fork/copy the full icybeard/pos-register tree into this repo, then customise. Do not build from scratch. Do not treat it as reference-only.
- Architecture: keep the base as-is (`lib/features/` + Riverpod). Do not rewrite to Clean Architecture.
- Cloud: standalone / local only. Remove cloud as the operating mode (pos-server, Kazakhstan API, gRPC sync must not block or be required).
- Tax: implement the Tax Settings specification (master ON/OFF switch, tax name, rate %, inclusive in MRP or exclusive on the bill). Not a hardcoded GST 17%.

GitHub repository that actually exists for this project: `Dr-Adil-Abdullah/area74a`
(the planning documents called it `area_72a`).

---

1. THE LINK THE OWNER PROVIDED
First given: https://github.com/mosespace/pos-register
Then corrected by the owner: https://github.com/icybeard/pos-register — owner's words: "(if old not work)"
Instruction: fork it, clone it, use it as the base.
Repository name for this project: area_72a
Instruction: upload all files to that repo.
2. CORE REQUIREMENT
Build a professional Medical Store (Pharmacy) POS application.
Must be based on an existing open-source project with 60–80% of features already built.
AI must only customise and extend — not build from scratch.
3. PLATFORM REQUIREMENTS
Windows — primary platform, full POS system, desktop .exe.
Android — companion app. Minimum: stock search, expiry alerts, low-stock alerts,
medicine search. Full POS on Android is a bonus.
One codebase — both platforms from a single Flutter codebase.
Web (future) — architecture must remain web-compatible so a browser version can be
added later without rewriting code.
4. OFFLINE REQUIREMENT — STRICT, NON-NEGOTIABLE
Owner's words: "Internet can go down at any time. The app must continue working on the
last available data."

Must work offline: login · sales · inventory · search · reports · printing · backup.
Cloud sync, if added, is optional and must never block local work.

5. OWNER'S PHILOSOPHY — DIRECT QUOTES
"Jo cheezein mil jayein ek behtareen software mein woh theek hai, jo nahi hai ya jo hum
custom change karwana chahte hain woh custom karwa lenge."
(Whatever a good software already has is fine; whatever is missing we will customise.)
"Mera dil kehta hai iske andar pehle hi basic saara hoga — printing, barcode scanning —
pehle hi hoti hai."
(I feel the basics — printing, barcode — will already be built in.)
"Non-technical banda bhi yeh saara kaam khud kar sake."
(Even a non-technical person must be able to manage everything themselves.)
"AI bohat zyada galtiyan karta hai — minimize karein."
(AI makes too many mistakes — minimise them.)
"Ready-to-make cheezein use kar lein."
(Use ready-made things wherever possible.)
6. SCALE & FUTURE
Now: personal use, single shop, small scale.
Later: may grow to multiple shops, or a veterinary store, or a hospital, or other
business types.
Therefore the licence must allow future expansion.
Therefore the architecture must be extensible.
7. DYNAMIC SETTINGS REQUIREMENT — VERY IMPORTANT
All business data must be manageable from a Settings screen by a non-technical person:

Categories and sub-categories, unlimited depth
Contact types
Expense heads
Payment methods
Units of measurement
Dosage forms
Tax rates
Custom fields on any entity
Why: so the owner never has to call a developer just to add a new category or expense type.

8. COMPLETE FEATURE LIST REQUIRED
Medicines — brand name, generic name, strength, dosage form, company, batch number,
expiry date, purchase price, retail price, doctor price, MRP.

Inventory — stock tracking per batch, FEFO, stock adjustment (damage, return,
correction, expiry), low-stock alerts.

Transactions — sales (POS with cart), purchases from suppliers with batch entry,
returns (customer returns, supplier returns), damage tracking.

People — customers with types, suppliers with types, doctors with specialisation,
clinic and commission.

POS — barcode scanning (USB hardware + Android camera), cart management, multiple
payment types, thermal ESC/POS receipt printing, price selection (retail vs doctor).

Alerts — near expiry at 7/30/60/90 days colour-coded, expired medicines, low stock.

Users — login system, roles, permissions, audit log.

Reports — daily/monthly/yearly sales, purchases, expiry, stock valuation, profit/loss,
supplier ledger, doctor commission.

System — backup/restore manual and auto, export to CSV/Excel, thermal printing,
A4 invoice printing, offline database (SQLite), audit logging.

Expenses — expense entry with dynamic heads, expense reports.

Android companion (minimum) — medicine search by name/generic/barcode, current stock
view, near-expiry list, expired list, low-stock alerts, quick dashboard stats.

Settings (user-managed) — store information, categories/sub-categories, contact types,
payment methods, units, dosage forms, tax rates, expense heads, custom fields, printer
settings, alert settings, backup settings, users & roles, theme & language.

9. STRATEGY DECISION — OPTION D CHOSEN
Four options were evaluated:

Option A — Pure Flutter native. Good, but closes future doors.
Option B — Pure Web/PWA. Too risky; offline reliability only 60–70%; data loss risk.
Option C — Web + local server. Good for tech-savvy users, not for this owner.
Option D — Flutter native now + web-ready architecture. ✅ CHOSEN.
Option D means: Phase 1 = Windows .exe + Android .apk; Phase 2 = same codebase builds
to web; 100% offline today, web option tomorrow; clean architecture enforced from day one;
no extra work, cost or risk today.

10. BASE PROJECT SELECTION
Seven candidates were evaluated. pos-register was selected.

Runner-up candidates kept as reference only: Due Kasir, flutter_pos2, Olgax POS, nodedr-pos.
Bayaa POS rejected — proprietary / All Rights Reserved licence. Public GitHub ≠ open source.
MedPharm ERP not suitable — too clinical/complex; we need shop inventory + sales, not
patients + insurance + drug interactions.
Selection principle, owner-endorsed: "We don't need the project with the MOST features. We
need the project with the BEST foundation. A clean 60% base is better than a messy 90% base."

11. TECHNOLOGY STACK CHOSEN
Framework: Flutter, latest stable channel
Language: Dart, strict null-safety
Database: SQLite (match the base — sqflite or drift)
State management: DO NOT CHANGE — match whatever the base uses
Architecture: Clean Architecture (Presentation → Domain → Data)
Platforms: Windows + Android
Future: Web — architecture must support it
Testing: flutter_test, mocktail, integration_test
Version control: Git with conventional commits
12. ARCHITECTURE RULES
Layered: core · data (models, datasources, migrations, repositories) · domain
(entities, usecases, repository interfaces) · presentation · di
Mandatory data flow: UI → Presentation → Domain (use case) → Repository interface →
Data layer → SQLite. Never skip layers. Never call the database directly from the UI.
Web-ready rules: no dart:io in domain or data layers; abstraction interfaces for all
platform-specific operations; path_provider only through an injected service; business
logic testable without platform dependencies; no hardcoded paths.
Windows: minimum window 1024×768, default 1280×800; keyboard shortcuts; USB barcode
scanner as keyboard input; thermal printer via USB/COM (ESC/POS); system-tray notifications.
Android: minimum SDK Android 7.0 (API 24); camera barcode scanning; Bluetooth thermal
printer; portrait + landscape; touch-friendly 48 dp minimum tap targets; push notifications.
Shared: business logic 100% shared, database 100% shared, models 100% shared,
UI platform-adaptive with platform checks only in the UI layer.
13. DATABASE RULES — NON-NEGOTIABLE
Every schema change = a numbered migration file
Never modify an already-applied migration
Never delete or rename existing columns
Never drop existing tables
New columns must have DEFAULT values
Test migrations on a fresh and an existing database
Back up the database before running a migration
Use transactions for multi-table writes
Foreign keys must define ON DELETE behaviour
Existing tables from the base are not to be modified
14. DATABASE TABLES THE OWNER WANTS
Medical tables: medicine_details · product_batches (most critical) ·
stock_adjustments · audit_log · a near-expiry view.

Dynamic settings tables: categories (hierarchical) · contact_types · contacts
(unified) · expense_heads (hierarchical) · expenses · payment_methods · units ·
tax_rates · dosage_forms · custom_fields.

Tables the owner later confirmed must be added: purchases + purchase_items ·
sale-items batch allocation for FEFO · doctors (commission) · sale_returns +
sale_return_items · purchase_returns (same pattern) · cash_daily_summary (X-Z reports).

Stock calculation rule: total stock = SUM of all batch quantities. Never store the
total separately — always calculate from batches.

15. APPROVED PACKAGES
Database & storage: sqflite or drift (match existing) · path_provider · shared_preferences ·
hive (only if needed).
State management: match existing, do not change.
UI: data_table_2 · fl_chart or syncfusion_flutter_charts · flutter_form_builder +
form_builder_validators · dropdown_search · flutter_speed_dial · flutter_slidable · intl.
Barcode: mobile_scanner · flutter_barcode_scanner (alternative) · USB scanners need no package.
Printing: esc_pos_utils + esc_pos_printer · printing · pdf.
Notifications: flutter_local_notifications · awesome_notifications.
Files: file_picker · share_plus · excel · csv.
Backup: archive.
Utilities: uuid · equatable · dartz (if the project uses it) · logger · fuzzywuzzy.
Testing: flutter_test · mocktail · integration_test.

RULE: any package not on this list → ASK THE OWNER FIRST.

16. MEDICAL DOMAIN TERMS
Generic name = chemical name · Brand name = commercial name · Strength = dosage amount ·
Dosage form = physical form · Batch number = manufacturer's batch identifier ·
Expiry date = after which the medicine must not be sold · MRP = maximum retail price printed
on the box · Doctor price = special discounted price for doctors/clinics ·
Retail price = normal customer price · Purchase price = what the store paid the supplier ·
FEFO = First Expiry First Out.

17. BUSINESS RULES — MANDATORY
Expired medicines must not appear in POS for sale.
Near-expiry (≤30 days) must show a warning at POS.
The earliest-expiry batch must sell first (FEFO).
Stock cannot go negative.
Warn if purchase price > retail price.
Doctor price must be ≤ retail price.
Every sale must record which batch was sold.
Damaged/expired stock goes through stock adjustments — never deleted.
A batch with quantity 0 must be hidden from sale selection.
18. AI DEVELOPMENT RULES — THE GOLDEN RULES
Three principles: REUSE FIRST (check existing code → check packages → then write) ·
MAKE IT DYNAMIC (business data in the database, not hardcoded) · MINIMIZE AI CODE (every
AI-written line is a potential bug).

Before every code change: search the existing codebase · check the approved packages ·
identify affected layers/files/tables · identify breaking risks · post a CHANGE PROPOSAL ·
wait for the owner's approval.

After every code change: flutter analyze zero warnings · flutter test all pass ·
flutter build windows success · flutter build apk --debug success · manually verify
existing features are not broken · update AI_PROGRESS.md · update AI_ROADMAP.md · git commit.

When unsure: STOP, do not guess, ask the owner with options and a recommendation.

When something breaks: do not "fix forward" — revert to the last working state, identify
the breaking commit, understand why, then fix properly.

Mistakes to avoid: rewriting a whole file when 3 lines need changing · replacing the
state-management library · adding packages when existing ones work · changing the folder
structure · removing "unused" code · schema changes without a migration · internet-dependent
code in offline flows · platform-specific code in shared logic · duplicate models for the
same table · hardcoded paths · empty catch blocks · hardcoding lists that should be dynamic ·
using ! without justification · mixing multiple features in one change.

19. DO NOT TOUCH LIST
🔴 Forbidden without explicit approval: the entire core/ directory · existing fields of the
product, sale and user models · existing sales and inventory use cases · existing POS screens ·
the existing home screen · android/app/build.gradle · windows/runner/ · removing
dependencies from pubspec.yaml · any existing migration file · any existing test file.

🟢 Safe to create/modify: new medical folders in presentation/domain/data · new settings
folders · new migration files (add-only) · new model files · new test files · documentation.

20. FEATURE IMPLEMENTATION ORDER — 13 PHASES
Understanding (no code) — read the context, read the codebase, create the three AI files
Foundation Audit — map tables, screens, state management, packages (no code)
Settings Framework — BUILD THIS FIRST, everything depends on it
Medical Database — all migrations
Medicine Management
Purchase & Supplier Flow
Pricing Tiers
Expiry & Alerts
Stock Management
Android Companion
Reports
Printing
Backup & Security
Expenses Module
21. GIT WORKFLOW
main (protected, never a direct commit) ← develop (integration) ← feature/* branches ·
hotfix/* for emergencies only.
One feature per branch · commit frequently · conventional commits (feat, fix, refactor,
docs, test) · never commit broken code · never force-push main or develop.

22. TESTING REQUIREMENTS
Unit tests for every new use case · widget tests for every new screen · integration tests for
critical flows. Coverage target: 60% minimum for all new code.

23. AI TRACKING FILES — THREE, MUST BE MAINTAINED
AI_UNDERSTANDING.md — the AI's own understanding, base-project analysis, what will not
be touched, unclear items, proposed first steps. Updated only when scope changes.
AI_PROGRESS.md — updated after every task. Session history, files created/modified,
database changes, packages added, tests added, git commits, verified items, issues,
blockers, handoff notes, cumulative stats, broken items, technical debt.
Never delete old sessions. Archive if over 5,000 lines.
AI_ROADMAP.md — all phases and tasks with statuses: ⬜ not started, 🟡 in progress,
✅ completed, ❌ cancelled with reason, ⏸️ paused with reason, 🔄 needs rework.
Cancelled items are never deleted.
COMPLETE_PROJECT_CONTEXT.md — only the owner modifies it. The AI may suggest changes
via a separate
PROPOSED_CHANGES.md
.
24. SESSION PROTOCOLS
Startup, every new session: read the context file → read AI_UNDERSTANDING.md → read the
last 3 sessions of AI_PROGRESS.md → read AI_ROADMAP.md (current phase + next tasks) → report
to the owner: project, current phase, last session, last completed, ready to continue,
blockers → await instruction.

Handoff, end of every session: AI_PROGRESS.md has the current session entry ·
AI_ROADMAP.md is up to date · all code changes are committed · write a handoff note covering
current phase/task, last completed, next step, blockers, uncommitted files.

25. FINAL PRINCIPLES — READ BEFORE EVERY TASK
You are extending, not rebuilding.
The existing app works — your job is not to break it.
Smallest possible change wins.
Every feature must work offline.
Every schema change = a migration.
Every change must be tested before committing.
The user's data is more important than code elegance.
Ask before changing. Never assume.
Dynamic > hardcoded — the user manages business data from Settings.
REUSE > EXTEND > BUILD, in that order.
This is a real pharmacy — bugs cause real financial loss.
A non-technical user must manage categories, contacts and expenses from Settings
without calling a developer.
Ready-made packages > AI-written code.
One feature at a time — build → test → commit.
Update the tracking files after every task.
PART TWO — THE OWNER'S 16 ANSWERS (DECISIONS)
These were given in reply to 16 clarification questions. They are decisions, not suggestions.

Q1 — Base repository. https://github.com/mosespace/pos-register. Fork it, clone it,
use it as the base. (Later corrected by the owner to icybeard/pos-register.)

Q2 — Categories contradiction. Use the ALTER TABLE ADD COLUMN approach — add-only, zero
data loss. Keep the existing categories table and add new columns via migration.

Q3 — ID type. Use TEXT UUID for all new tables. For integer ID references, store as TEXT.
Use the uuid package (already approved).

Q4 — Contacts vs customers. Keep both parallel — no replacement. The existing
customers table stays untouched and is used in POS. A new contacts table is added for
suppliers, doctors and wholesalers. Not a replacement — a new system alongside the old.

Q5 — Money, tax and rounding (Pakistan).

Currency: PKR
Tax: GST 17%, inclusive in MRP — show the breakdown, total = MRP
Rounding: whole rupee on the final receipt, 2 decimals on line items
Money storage: INTEGER PAISA (Rs. 525.50 = 52550)
Discounts: per-line AND per-invoice, both percentage and fixed
Q6 — Windows ↔ Android flow.

Phases 1–8: Android is read-only, manual database file copy via USB/folder
Phase 9: LAN Wi-Fi sync
Design now for it: UUID + updated_at on all tables, soft deletes via is_active
Q7 — Missing tables. Add these and draft migrations: purchases + purchase_items ·
sale-items batch allocation for FEFO · doctors (commission) · sale_returns +
sale_return_items · purchase_returns (same pattern) · cash_daily_summary (X-Z reports).

Q8 — Stock valuation. Weighted average cost method. FEFO is for the selling order
only, not for valuation. Formula: SUM(quantity × weighted average price).

Q9 — Users, roles, login.

Roles: Admin (full), Cashier (sales only), Manager (reports + limited)
Password: bcrypt hashing via pointycastle (add to approved packages)
Password reset: Admin-only, emergency via direct database access
Audit log: all INSERT / UPDATE / DELETE on key tables
Q10 — Hardware (provisional). Thermal: any ESC/POS, USB primary, 58 mm roll.
Receipt: store name, logo, items with batch and expiry, tax, barcode.
Scanner: USB HID keyboard wedge — confirmed. Cash drawer: optional, not now.

Q11 — Language (provisional). English primary (thermal printer limitation).
Urdu is a future option. Date format DD/MM/YYYY. Currency display Rs. 1,234/-

Q12 — Backup (provisional). Local folder + USB. Daily automatic. 30 days retention.
No encryption now — decide at Phase 12.

Q13 — Data volume. The AI is to fill in the estimates. Opening stock is entered via
purchase entry (Phase 5). CSV import is not in scope now.

Q14 — Barcode generation. Yes, needed for items without a manufacturer barcode.
Use the barcode_widget package, added in Phase 11.

Q16 — Out of scope, confirmed. No prescriptions, no drug interactions, no insurance,
no patients, no multi-shop, no FBR, no e-commerce.

PART THREE — THE OWNER'S ORDERED NEXT STEPS
AI_UNDERSTANDING.md is already created — update it with these answers
Create AI_PROGRESS.md
Create AI_ROADMAP.md with all 13 phases and all tasks, status ⬜
Create PROPOSED_CHANGES.md containing: the missing table schemas (purchases, sale items,
doctors, returns, cash daily summary) · the ALTER TABLE categories migration · the integer
paisa migration for all money columns · the updated stock calculation with weighted average
Create CLEAN_COMPLETE_PROJECT_CONTEXT.md with all these decisions merged
Then await the owner's approval before any code
STANDING ORDER: "NO CODE until I approve PROPOSED_CHANGES.md."

PART FOUR — THE OWNER'S TAX SETTINGS SPECIFICATION
Given verbatim, in Urdu and English:

text

⚙️ Tax Settings (ٹیکس کی ترتیبات)
─────────────────────────────────────────────
[🔘] Enable Tax System (ٹیکس سسٹم آن کریں)    [ OFF / ON ]
     (جب یہ بند ہوگا تو کوئی ٹیکس لاگو نہیں ہوگا)

اگر آن (ON) کریں تو:
├── Tax Name: GST / Sales Tax
├── Default Rate: 17% (یا اپنی مرضی کا %)
└── Tax Type: [🔘] Inclusive in MRP (دوائی کی قیمت میں شامل)
              [⚪] Exclusive (بل کے اوپر الگ سے لگے)
Meaning: a master switch to enable the tax system; when off, no tax is applied anywhere.
When on: a tax name, a default rate the owner can change, and a choice between tax inclusive
in the MRP or tax added on top of the bill.

PART FIVE — THE OWNER'S HANDOVER INSTRUCTIONS
Save all information from the conversation into files, including whatever exists only in the AI's mind.
The purpose: the owner can hand these files to a new chat with the same AI, or to any other
AI agent, say "read it", and that agent will understand how far the work has gone, what has
been understood, what the new link is, what we want to do, and what the roadmap is — and
resume from exactly this point.
If anything is blocked or needs asking before doing this, ask.
Create a repository named area_72a and upload all files to it.
Keep the handover to a maximum of two files if possible; ideally one.
This file must contain only the owner's own input — requirements, decisions,
instructions, links — as a compact summary, without examples.
PART SIX — SETTINGS SCREEN STRUCTURE THE OWNER WANTS
text

⚙️ Settings
├── 🏪 Store Information (name, address, phone, logo)
├── 📁 Categories & Sub-Categories
│   ├── Product Categories (hierarchical tree)
│   ├── Expense Categories
│   └── Contact Categories
├── 👥 Contact Types (Customer, Supplier, Doctor, etc.)
├── 💰 Payment Methods (Cash, Card, JazzCash, EasyPaisa, etc.)
├── 📏 Units of Measurement (Piece, Box, Strip, ml, etc.)
├── 💊 Dosage Forms (Tablet, Syrup, Injection, etc.)
├── 🏷️ Tax Rates (GST 17%, 5%, etc.)
├── 💸 Expense Heads (Rent, Salary, Utilities, etc.)
├── 🔧 Custom Fields (add fields to any entity)
├── 🖨️ Printer Settings
├── 🔔 Alert Settings (expiry days, low-stock threshold)
├── 💾 Backup Settings (auto-backup schedule)
├── 👤 Users & Roles
└── 🎨 Theme & Language
On every dynamic list item the owner must be able to: add · edit ·
disable/enable (soft delete, never hard delete) · reorder by drag and drop ·
search and filter. For categories additionally: add a sub-category at any depth and
move it under a different parent.

The golden rule: if it is business data → database table → Settings screen.
If it is system logic → code → developer only.

PART SEVEN — ARCHITECTURE THE OWNER APPROVED
text

             MEDICAL STORE APP
                  │
         ┌────────┴────────┐
      WINDOWS           ANDROID
     (.exe)             (.apk)
         └────────┬────────┘
          SHARED BUSINESS LOGIC (Flutter/Dart)
                  │
            LOCAL SQLite DB
                  │
            OFFLINE FIRST
                  │
         ┌────────┴────────┐
    Windows Sync      Android Sync
         └───────┬─────────┘
            OPTIONAL CLOUD (future)
PART EIGHT — OWNER, 15 SEP 2026 (Urdu, Arena session)

Nothing in the app must be hardcoded if it is business data.

Currency: owner must change symbol and display themselves (Rs., $, or any sign).
Shop name and shop details: owner-editable.
Categories and sub-categories: owner-editable.
Customer fields (name, number, other details): owner must be able to change later.
Products: pharmacy products and veterinary products have different details
(e.g. how many ml). Prices: simple customer, VIP, doctor.
Discount: owner chooses whether discount is on the total amount or on profit.
All of the above must be managed from one Settings folder/module.

Offline remains the main goal: when there is no internet, the app uses the last
local data; when internet returns, local changes upload. Downloading an app is
not mandatory — if a web-based system can be better, the owner is willing to
work on web too.

Owner asked for a complete explanation in Pakistani Urdu script of: how Flutter
will be tested along the way; whether to change stack now; when main work starts.

END OF AREA_72A_C — USER INPUT ONLY.
For the AI's audit, findings, proposed schemas and task roadmap, see the other documents
(READ_ME_FIRST.md, AI_UNDERSTANDING.md, PROPOSED_CHANGES.md, AI_ROADMAP.md).
