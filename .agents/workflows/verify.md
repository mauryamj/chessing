---
description: Mandatory pre-flight verification gate (codegen, analyzer, test suite).
---

# Workflow: Pre-Flight Verification Gate

Run before submitting changes or claiming task completion.

## 1. Step-by-Step Execution

```bash
# Step 1: Run code generation if models, providers, or Drift tables changed
dart run build_runner build --delete-conflicting-outputs

# Step 2: Static analysis (MUST be 0 errors)
flutter analyze --no-fatal-infos

# Step 3: Run the full test suite
flutter test --no-pub
```

## 2. Common Fixes & Troubleshooting
- **Missing `.g.dart` file:** Verify `part '<filename>.g.dart';` is present and rerun `build_runner`.
- **Async context warning:** Check for `if (!context.mounted) return;` immediately following `await`.
- **Nullable cast errors in router:** Ensure `state.extra as Type?` is used instead of direct forced casts.