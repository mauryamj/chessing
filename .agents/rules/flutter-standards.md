---
trigger: always_on
---

# Flutter Architecture & Coding Standards — Chessing

## 1. Project Conventions

- **State Management:** Riverpod only. Use `@riverpod` annotation from `riverpod_annotation` for all new providers. Do NOT create new `StateNotifierProvider` or `ChangeNotifierProvider` — existing ones may be refactored incrementally.
- **Routing:** `go_router`. All route paths and `GoRoute` definitions live in `lib/app/router.dart`. Use `context.go()` for replacing stack, `context.push()` for pushing. Never use `Navigator` directly.
- **Project Structure:**
  ```
  lib/
    app/           ← router.dart, theme.dart
    core/          ← ai/, auth/, cache/, database/, engine/, firebase/, pgn/, supabase/, utils/
    features/      ← auth/, history/, play/, profile/, roleplay/, settings/, theory/
    shared/        ← widgets/
  ```
- **No mixed paradigms.** Every new provider must use the `@riverpod` code-gen pattern.

## 2. Widget Guidelines

- Prefer small, private widget classes (`_MySubWidget`) or extracted `const` widgets over large monolithic `build()` methods. Any `build()` over ~80 lines should be split.
- Always add `const` constructors to every widget that takes only `final` fields.
- **NEVER** pass `BuildContext` across async gaps without checking `if (!context.mounted) return;` immediately after the `await`.
- Use `ConsumerWidget` / `ConsumerStatefulWidget` from Riverpod instead of `StatelessWidget` / `StatefulWidget` when watching providers.

## 3. Code Generation

- Files using `@riverpod`, Drift tables, or `@freezed` MUST include the `part` directive:
  ```dart
  part 'filename.g.dart';
  ```
- After any change to annotated files, run:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- Never manually edit `.g.dart` files — they are regenerated and changes will be lost.

## 4. Supabase / Database Rules

- All Supabase writes MUST filter by `supabase.auth.currentUser?.id` — never write to another user's rows.
- All new Supabase tables need Row Level Security (RLS) policies. Use the `supabase-rls-checklist` skill.
- All new Drift tables need a migration entry in `app_database.dart::onUpgrade` and a matching schema test. Use the `drift-migration-test` skill.

## 5. Security Rules (Non-Negotiable)

- **Never** add `.env` to `flutter.assets` in `pubspec.yaml`. Use `--dart-define-from-file` for CI.
- **Never** pass API keys in URL query parameters. Use `x-goog-api-key` header for Gemini.
- Sensitive user settings (API keys) MUST use `flutter_secure_storage`, NOT `SharedPreferences`.
- Error messages shown in the UI must be generic user-facing strings. Raw `e.toString()` or stack traces must never reach `AuthError` state or any displayed widget.

## 6. Naming & File Conventions

| Artifact | Convention |
|----------|-----------|
| Screens | `*_screen.dart` → `class *Screen extends ConsumerWidget` |
| Providers | `*_provider.dart` → `@riverpod` annotated |
| Repositories | `*_repository.dart` → plain Dart class |
| Models/DTOs | `*_model.dart` or `*_entry.dart` |
| DAOs | `*_dao.dart` |
| Tests | Mirror `lib/` structure under `test/` |