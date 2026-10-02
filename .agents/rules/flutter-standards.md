---
trigger: always_on
---

# Flutter Architecture & Coding Standards

## 1. Project Conventions
- **State Management:** Use Riverpod (or BLoC/Provider - declare yours here). Do not mix multiple paradigms.
- **Routing:** Use `go_router`. Place all route definitions in `lib/core/router/`.
- **Clean Architecture:** Structure code into:
  - `data/` (models, datasources, repositories implementation)
  - `domain/` (entities, repository contracts, use cases)
  - `presentation/` (screens, widgets, controllers/providers)

## 2. Widget Guidelines
- Prefer small, private widget classes (`_MySubWidget`) or extracted widgets over large monolithic `build()` methods.
- Always add `const` constructors where possible to prevent unnecessary rebuilds.
- Avoid passing `BuildContext` across asynchronous gaps without checking `if (!context.mounted) return;`.

## 3. Code Generation
- If modifying files using `freezed`, `json_serializable`, or `injectable`, run:
  `dart run build_runner build --delete-conflicting-outputs`