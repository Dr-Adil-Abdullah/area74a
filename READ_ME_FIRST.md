# READ ME FIRST — area74a Medical Store POS

Naya agent / naya session: **pehle yeh file**, phir neeche wali order.

Yeh Pakistan ki medical store (pharmacy) POS hai. Windows `.exe` + Android `.apk`, 100% offline. Base code: [icybeard/pos-register](https://github.com/icybeard/pos-register) (KeregePOS, Apache-2.0).

## Abhi kis stage par hain

| Item | Status |
|---|---|
| Owner requirements saved | done — `AREA_72A_C.md` |
| Base repo padh liya | done — icybeard/pos-register clone (analysis only) |
| 4 critical decisions (15 Sep 2026) | done — see below |
| Tracking files | done — this commit |
| Base code is repo mein copy | **nahi** — `PROPOSED_CHANGES.md` ke approve ka wait |
| Application code | **nahi** — standing order: no code until proposal approved |

**Agela kaam:** Flutter wali machine par `flutter pub get && flutter analyze && flutter test`. Phir Phase 3 Settings (schemaVersion 8).

## 15 Sep 2026 ke locked decisions

1. **Base:** poora icybeard/pos-register is repo mein copy, phir customize. Scratch se nahi.
2. **Architecture:** `lib/features/` + **Riverpod** rehne do. Clean Architecture rewrite **nahi**.
3. **Cloud:** standalone only. pos-server / gRPC / Kazakhstan API **default off, baad mein hata denge**. Local SQLite hi source of truth.
4. **Tax:** Settings se master switch — ON/OFF, tax name, rate %, inclusive **ya** exclusive. Hardcoded 17% nahi.

## Files — kaun si kya hai

| File | Who writes | What |
|---|---|---|
| `AREA_72A_C.md` | Owner only | Raw requirements / decisions / links |
| `CLEAN_COMPLETE_PROJECT_CONTEXT.md` | AI, after owner answers | Merged truth for building |
| `AI_UNDERSTANDING.md` | AI | Base-code analysis, reuse vs don't-touch |
| `PROPOSED_CHANGES.md` | AI | Schemas — **approved 15 Sep 2026** |
| `AI_ROADMAP.md` | AI | 13 phases, task status |
| `AI_PROGRESS.md` | AI | Session log — never delete old sessions |
| `READ_ME_FIRST.md` | AI | This file |

## Purane docs se 3 bari ghalatian (ignore old assumptions)

1. `mosespace/pos-register` **404** hai. Sahi base: `icybeard/pos-register`.
2. Purana “Clean Architecture / customers table / integer IDs / sqflite migrations” **is base par apply nahi hota**.
3. Purana DO-NOT-TOUCH list galat codebase ke liye likha tha. Naya list: `AI_UNDERSTANDING.md`.

## Git (is Arena session ke liye)

- Branch: `arena/01a0a641-area74a` only.
- `main` / `develop` / `feature/*` is session mein **use nahi** — Arena isi branch ko track karta hai.
- Repo: https://github.com/Dr-Adil-Abdullah/area74a

## Rule jo har session par lagta hai

REUSE → EXTEND → BUILD. Offline pehle. Schema change = Drift `schemaVersion` bump. Owner ke approve ke baghair naya package nahi. Poori file rewrite nahi. Guess nahi — poochho.
