---
trigger: always_on
---

# Mandatory Verification & Quality Gates

## 1. Implementation Plan Requirements
Before writing implementation code in `/plan` mode, you MUST include a `## Testing Strategy` section covering:
1. **Engine / Domain Logic:** PGN parsing, move validation, or score conversion tests.
2. **State / Riverpod Tests:** Provider container overrides using `ProviderContainer`.
3. **Widget Tests:** Screen rendering using `testWidgets` with mocked dependencies.

## 2. Verification Protocol (Run in Terminal)
Before reporting a task as complete, execute this sequence:

1. **Code Generation Check:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs