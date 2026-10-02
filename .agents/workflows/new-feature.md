---
description: Comprehensive workflow to scaffold, wire, and test a new feature module in Chessing.
---

# Workflow: Scaffold New Feature Module

When creating a new feature in `lib/features/<name>/`:

## 1. Directory Structure Setup
Scaffold the standard layout under `lib/features/<name>/`:
- `data/`: Repositories, DTOs, data sources (e.g. Supabase / Drift DAOs).
- `domain/`: Pure Dart entities/models if domain logic is distinct.
- `presentation/`:
  - `controllers/`: Riverpod providers using `@riverpod` annotations with `part '<name>_provider.g.dart';`.
  - `widgets/`: Feature-specific private/sub-widgets (keep `build` methods under 80 lines).
  - `<name>_screen.dart`: Main entry screen extending `ConsumerWidget`.

## 2. Router Integration
Add the new screen route in [router.dart](file:///d:/M/flutter/chessing/lib/app/router.dart):
- Define standard route path (e.g., `/<name>`).
- If passing arguments via `state.extra`, always cast safely with `as Type?`.
- Use `context.go()` for stack-replacing navigation or `context.push()` for sub-screens.

## 3. Test Creation
Create a mirror test file under `test/features/<name>/`:
- Test provider logic with `ProviderContainer` and mock overrides.
- Test widget rendering using `testWidgets` with necessary fake/mock providers.

## 4. Code Generation & Quality Gate
Run full code generation and verify:
```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze --no-fatal-infos
flutter test --no-pub
```