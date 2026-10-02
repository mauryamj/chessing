---
description: Core architecture, Riverpod generator, Drift database, and state boundaries for Chessing.
---

# Chessing Architectural Standards

## 1. State Management & Code Generation
- **Riverpod 2.x:** Exclusively use `@riverpod` annotations via `riverpod_annotation`. Never hand-roll legacy `StateNotifierProvider` or `ChangeNotifierProvider`.
- Every file declaring providers, Drift tables, or Freezed models MUST contain its part directive:
  ```dart
  part 'filename.g.dart';