---
description: 
---

# Workflow: Scaffold New Feature Module
When the user requests a new feature in `lib/features/<name>/`:
1. Scaffold standard folder layout:
   - `lib/features/<name>/presentation/` (screens, widgets)
   - `lib/features/<name>/presentation/controllers/` (annotated Riverpod providers)
   - `lib/features/<name>/data/` (repositories, DTOs if applicable)
2. Add route definition to `lib/app/` using `go_router`.
3. Create corresponding test file in `test/features/<name>/`.
4. Run `dart run build_runner build --delete-conflicting-outputs`.