---
description: 
---

# Workflow: Pre-Flight Verification
1. Run `dart run build_runner build --delete-conflicting-outputs`.
2. Run `flutter analyze`.
3. Run `flutter test`.
4. Report any broken mock engines, unhandled null checks, or syntax warnings.