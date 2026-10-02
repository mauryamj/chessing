---
description: Run build runner code generation cleanly for Riverpod, Drift, and Freezed models.
---

# Workflow: Run Full Code Generation

Use this whenever modifying `@riverpod`, `@DriftDatabase`, or `@freezed` models.

## 1. Safety Check
Check if any dangling `build_runner watch` process is holding file locks.

## 2. Generate Files
Execute:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## 3. Verify Generated Output
- Ensure no unresolved conflict warnings or compilation errors in `.g.dart` or `.drift.dart` files.
- Never edit `.g.dart` files directly.