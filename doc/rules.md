# Chessing — Agent Coding Rules

> Mandatory rules and operational protocols for any AI agent or pair programmer contributing to Chessing.
> Do not bypass or work around these rules.

---

## 0. Start-of-Session Routine

1. **Check Memory & Active State:** Read `doc/memory.md` for current status, stack decisions, and known gotchas.
2. **Review Task List:** Read `doc/task.md` and select the first active/in-progress task.
3. **Verify Pre-Flight:** Run `flutter analyze` and `flutter test` before writing code to verify a green baseline.
4. **End-of-Session:** Update `doc/task.md` with finished tasks, document new architectural decisions in `doc/memory.md`, and execute the Verification Protocol.

---

## 1. Flutter & Dart Standards

- **State Management:** Riverpod 2 only. New providers must use the `@riverpod` annotation from `riverpod_annotation`. Never introduce new `StateNotifierProvider` or `ChangeNotifierProvider`.
- **Code Generation:** Any file using `@riverpod`, Drift tables, or Freezed must declare `part 'filename.g.dart';`. After editing, run:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- **Routing:** Use `go_router`. All routes and redirects live in [`lib/app/router.dart`](file:///d:/M/flutter/chessing/lib/app/router.dart). Use `context.go()` to replace the navigation stack and `context.push()` to push sub-screens. Direct usage of `Navigator.of(context)` is prohibited.
- **Async Safety:** Never use `BuildContext` across an async gap without `if (!context.mounted) return;` immediately following the `await`.
- **Widget Modularization:** Any `build()` method exceeding ~80 lines must be decomposed into private extracted widget classes (`_MySubWidget`) or `const` constructors.
- **Null Safety:** Strict null safety. Avoid force unwrapping (`!`) unless guaranteed by a preceding assert or check.

---

## 2. Security & Credentials (Zero Exceptions)

1. **Never commit secrets:** Never add `.env` to `flutter: assets:` in [`pubspec.yaml`](file:///d:/M/flutter/chessing/pubspec.yaml). For CI, use `--dart-define` or secrets injection.
2. **Hardware Key Storage:** Sensitive user secrets (such as personal Gemini API keys) must be stored via [`SecureStorage`](file:///d:/M/flutter/chessing/lib/core/storage/secure_storage.dart) using `flutter_secure_storage` (Android Keystore / iOS Keychain), never unencrypted `SharedPreferences`.
3. **Header Security:** Gemini API calls must send keys via the `x-goog-api-key` HTTP header, never in query string parameters.
4. **Sanitized User Errors:** Raw stack traces, database exceptions, or raw `e.toString()` messages must never reach the user UI. UI errors must be generic and actionable (e.g., *"Sign-in failed. Please try again."*).

---

## 3. Database & Cloud Architecture Rules

- **Drift SQLite (Local):** Any schema change requires a matching migration entry in `AppDatabase.onUpgrade` and schema verifier tests.
- **Supabase PostgreSQL (Cloud):** All database writes must filter by `supabase.auth.currentUser?.id`. Row Level Security (RLS) policies are mandatory on all tables.
- **Offline Protection:** All gameplay data must persist locally to Drift first before queuing for cloud sync.

---

## 4. Verification Protocol & Definition of Done

Before marking any task as complete or proposing a commit:
1. **Code Generation:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
2. **Static Analysis:**
   ```bash
   flutter analyze
   ```
   *Must exit with 0 issues and 0 warnings.*
3. **Test Suite:**
   ```bash
   flutter test
   ```
   *All unit and widget tests must pass.*
4. **Documentation:**
   *Update `doc/task.md` and `doc/memory.md` reflecting all changes.*
