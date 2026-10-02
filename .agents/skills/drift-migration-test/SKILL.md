---
name: drift-migration-test
description: Adds Drift schema migration tests using SchemaVerifier to validate every database upgrade path (v1→v2→v3→v4). Use when adding a new Drift table, column, or schema version, or when the user asks about database migrations or testing.
---

# Skill: Drift Schema Migration Testing

## Background

`lib/core/database/app_database.dart` is at `schemaVersion = 4` with 3 migration steps.
**None of these migrations are tested.** A bug silently deletes user data on upgrade.

This skill creates a proper migration test using Drift's `SchemaVerifier`.

## Prerequisites

```bash
# Export current schema snapshots (run once, or after each schema change)
dart run drift_dev schema dump lib/core/database/app_database.dart \
  drift_schemas/drift_schema_v4.json
```

For each historical version you need a snapshot. If you don't have them, generate the current one and create minimal JSON for earlier versions manually or from git history.

## File Structure to Create

```
test/
  core/
    database/
      migration_test.dart   ← new
drift_schemas/
  drift_schema_v1.json      ← generated or reconstructed
  drift_schema_v2.json
  drift_schema_v3.json
  drift_schema_v4.json      ← current
```

## Add `drift_dev` to `dev_dependencies` (already present ✓)

```yaml
dev_dependencies:
  drift_dev: ^2.18.0  # already in pubspec.yaml
```

## Migration Test Template

```dart
// test/core/database/migration_test.dart
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chessing/core/database/app_database.dart';

// Generated verifier — run `dart run drift_dev schema generate` first
import 'generated_migrations/schema.dart';

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('upgrade from v1 to v2', () async {
    final connection = await verifier.startAt(1);
    final db = AppDatabase(connection);
    await verifier.migrateAndValidate(db, 2);
    await db.close();
  });

  test('upgrade from v2 to v3', () async {
    final connection = await verifier.startAt(2);
    final db = AppDatabase(connection);
    await verifier.migrateAndValidate(db, 3);
    await db.close();
  });

  test('upgrade from v3 to v4', () async {
    final connection = await verifier.startAt(3);
    final db = AppDatabase(connection);
    await verifier.migrateAndValidate(db, 4);
    await db.close();
  });

  test('full upgrade from v1 to v4', () async {
    final connection = await verifier.startAt(1);
    final db = AppDatabase(connection);
    await verifier.migrateAndValidate(db, 4);
    await db.close();
  });
}
```

## Add AppDatabase Constructor Overload for Testing

The `AppDatabase` class uses `_openConnection()` which opens a file. Add a test constructor:

```dart
// In lib/core/database/app_database.dart
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());
  // ... rest of class
}
```

This allows tests to pass `DatabaseConnection` from `SchemaVerifier.startAt()`.

## Generate Schema Snapshots

Run after every `schemaVersion` bump:

```bash
dart run drift_dev schema dump \
  lib/core/database/app_database.dart \
  drift_schemas/drift_schema_v4.json

dart run drift_dev schema generate \
  drift_schemas/ \
  test/core/database/generated_migrations/
```

## Steps

1. Add AppDatabase test constructor (see above).
2. Dump current schema: `dart run drift_dev schema dump lib/core/database/app_database.dart drift_schemas/drift_schema_v4.json`.
3. Create `test/core/database/migration_test.dart` from the template above.
4. Run `dart run drift_dev schema generate drift_schemas/ test/core/database/generated_migrations/`.
5. Run `flutter test test/core/database/migration_test.dart`.

## Every Time You Bump schemaVersion

```bash
# 1. Increment schemaVersion in app_database.dart
# 2. Write migration in onUpgrade
# 3. Dump new schema
dart run drift_dev schema dump lib/core/database/app_database.dart drift_schemas/drift_schema_vN.json
# 4. Re-generate test helpers
dart run drift_dev schema generate drift_schemas/ test/core/database/generated_migrations/
# 5. Add test for vN-1 → vN
# 6. Run tests
flutter test test/core/database/
```
