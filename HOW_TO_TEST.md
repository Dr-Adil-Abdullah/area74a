# Beginner: how to test this app (GitHub Desktop + one command)

You do **not** need to be a programmer. Two checks after every change:

1. **Computer check** — one command. Fast. No window.
2. **You click** — open the app, tap like a shop.

This Arena computer **cannot** run Flutter. Test on **your Windows PC**.

---

## A. One-time setup (only the first day)

### 1. GitHub Desktop

1. Install [GitHub Desktop](https://desktop.github.com/).
2. Sign in with the GitHub account that owns `Dr-Adil-Abdullah/area74a`.
3. **File → Clone repository**.
4. Pick **`Dr-Adil-Abdullah/area74a`**. Choose a folder (example: `Documents\area74a`).
5. Top bar: **Current Branch**. Switch to **`arena/01a0a641-area74a`**.  
   Do **not** use `main` for this work.

### 2. Flutter (needed for every command)

1. Open https://docs.flutter.dev/get-started/install/windows
2. Download the Flutter SDK zip. Unzip to a simple path, e.g. `C:\flutter`  
   (avoid `Program Files` and folders with spaces if you can).
3. Add `C:\flutter\bin` to Windows **PATH**:
   - Start → search **Environment variables**
   - **Path** → **Edit** → **New** → `C:\flutter\bin`
4. Close GitHub Desktop and any Command Prompt, then reopen.
5. In GitHub Desktop: **Repository → Open in Command Prompt**.
6. Type and press Enter:

```bat
flutter doctor
```

You want a tick next to **Flutter** and **Windows**.  
Android Studio is optional until you build an APK for a phone.

First time only, also run this **inside the project folder**:

```bat
flutter pub get
```

That downloads libraries. Wait until it finishes. Do it again if you see `pubspec.yaml changed`.

---

## B. Every time we push new code (your daily loop)

1. GitHub Desktop → branch **`arena/01a0a641-area74a`**.
2. Click **Fetch origin**.
3. If it says **Pull origin**, click it. Your folder now matches GitHub.
4. **Repository → Open in Command Prompt**.
5. Run the **computer check** (section C).
6. If green, run the **app** (section D) and click the checklist for that feature.

---

## C. Computer check — copy/paste commands

Always start in the project folder (the one that contains `pubspec.yaml`).  
GitHub Desktop’s **Open in Command Prompt** already puts you there.

### The one command you will use most

**This week’s prices + Rs. display:**

```bat
flutter test test/core/utils/money_config_test.dart test/core/utils/price_book_test.dart
```

Wait. End of output:

- **`All tests passed!`** → that piece of code is OK.
- **`Some tests failed`** → copy the red text and send it.

### Whole project (slower, more complete)

```bat
flutter test
```

or the same thing via Makefile:

```bat
make test
```

### Did we break Dart syntax?

```bat
flutter analyze --no-fatal-infos
```

or:

```bat
make analyze
```

`error` = must fix. `info` / style notes can wait.

### Only one file (when we name it)

```bat
flutter test test\core\utils\price_book_test.dart
```

Windows accepts `\` or `/`.

---

## D. Open the app and click (human check)

```bat
flutter run -d windows
```

First run can take several minutes. A window should open.

Stop the app: in that same Command Prompt press **`Ctrl+C`**.

Phone later (optional):

```bat
flutter run -d windows
flutter build apk
```

`.apk` is for Android. Shop till is Windows first.

---

## E. What to click — feature by feature

Do these **in the running app**, after PIN / first-run (create owner PIN if asked).

### 1. Settings hub (shop data is not hardcoded)

| Click | Expect |
|---|---|
| Sidebar **Settings** (or pharmacy settings tile) | Lists: shop, currency, tax, dictionaries |
| Shop name / address / phone / footer | Save. Re-open. Same text still there |
| Currency symbol | Seed should be **`Rs.`** (you can change it) |
| Tax | Master switch **on/off**, name, rate. Not stuck at 17% |
| Price tiers list | Retail, VIP, Doctor (you may add more) |
| Contact types | Customer, VIP, Doctor, Supplier |

### 2. `Rs.` on screen + tax from Settings

| Click | Expect |
|---|---|
| POS cart / product prices | Amounts look like **`Rs. 1,440/-`** not tenge `₸` |
| Settings → tax **OFF** | POS total has **no** tax line (or tax = 0) |
| Tax **ON**, set name e.g. GST and a rate | POS uses **that** name/rate, not a hidden 12% or 17% |

### 3. Customer type → price (this week)

Need at least one product with a **Retail** sale price.

| Click | Expect |
|---|---|
| Products → Edit a medicine | Extra boxes **VIP** and **Doctor**. Empty = use Retail |
| Put Retail `100`, VIP `90`, Doctor `80` → Save | Fields still there after re-open |
| POS | Chips: **Customer**, **VIP**, **Doctor**. **No Supplier** chip |
| Chip **Customer**, add the medicine | Cart price = Retail `100` |
| Chip **VIP**, add again (or new line) | Cart price = `90` |
| Chip **Doctor** | Cart price = `80` |
| Leave VIP/Doctor empty on another product | Always Retail (safe fallback) |

**Known gap:** lines **already in the cart** may keep the old price if you switch chip after adding. New adds use the chip. Say if you want old lines to update too.

---

## F. If something goes wrong

| You see | Try |
|---|---|
| `'flutter' is not recognized` | Flutter not on PATH. Redo A.2. Close and reopen Command Prompt |
| `No pubspec.yaml` | Command Prompt is in the wrong folder. GitHub Desktop → Open in Command Prompt again |
| GitHub Desktop on `main` | Switch branch to `arena/01a0a641-area74a`, then Fetch + Pull |
| App window never opens | `flutter doctor` — fix red items first |
| Tests fail only on your PC | Send the full red output. Do not edit files at random |

---

## G. What you do **not** need

- You do **not** install Flutter inside GitHub. GitHub only stores code.
- You do **not** need cloud / internet for the till after the first `flutter pub get`.
- You do **not** run `git push` from Desktop onto `main`. Stay on this Arena branch.

---

## H. Tiny cheat-sheet (print this)

```bat
REM 1. GitHub Desktop: Fetch origin → Pull origin
REM 2. Repository → Open in Command Prompt

flutter pub get
flutter test test/core/utils/money_config_test.dart test/core/utils/price_book_test.dart
flutter run -d windows
```

Then click the table in section E for the feature we just built.
