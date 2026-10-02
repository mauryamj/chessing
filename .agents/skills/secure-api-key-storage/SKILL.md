---
name: secure-api-key-storage
description: Migrate the Gemini API key from SharedPreferences (plaintext XML) to flutter_secure_storage (Android Keystore / iOS Keychain). Use when the user asks to secure the API key storage, improve credential security, or when preparing for production/Play Store release.
---

# Skill: Migrate Gemini API Key to Secure Storage

## Problem

`lib/features/settings/settings_provider.dart` stores the Gemini API key using:
```dart
await _prefs.setString(_kGeminiApiKey, trimmed);
```

`SharedPreferences` on Android is backed by an unencrypted XML file at:
`/data/data/com.example.chessing/shared_prefs/FlutterSharedPreferences.xml`

On rooted devices or via ADB backup, this file is readable by any app or person.

## Solution

Use `flutter_secure_storage` which uses the **Android Keystore System** and **iOS Keychain**.

## Step 1: Add Dependency

```yaml
# pubspec.yaml
dependencies:
  flutter_secure_storage: ^9.2.2
```

```bash
flutter pub get
```

## Step 2: Android Configuration

In `android/app/build.gradle`, ensure `minSdkVersion` is at least 21:
```gradle
android {
  defaultConfig {
    minSdkVersion 21
  }
}
```

## Step 3: Create a `SecureSettingsStorage` Helper

```dart
// lib/core/storage/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _kGeminiApiKey = 'secure_gemini_api_key';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static Future<String?> getGeminiApiKey() async {
    return _storage.read(key: _kGeminiApiKey);
  }

  static Future<void> setGeminiApiKey(String key) async {
    await _storage.write(key: _kGeminiApiKey, value: key.trim());
  }

  static Future<void> deleteGeminiApiKey() async {
    await _storage.delete(key: _kGeminiApiKey);
  }
}
```

## Step 4: Migrate `SettingsNotifier`

In `lib/features/settings/settings_provider.dart`:

```dart
// In build():
@override
Future<AppSettings> build() async {
  _prefs = await SharedPreferences.getInstance();
  
  // Migrate: if key exists in SharedPreferences, move to secure storage
  final legacyKey = _prefs.getString(_kGeminiApiKey);
  if (legacyKey != null && legacyKey.isNotEmpty) {
    await SecureStorage.setGeminiApiKey(legacyKey);
    await _prefs.remove(_kGeminiApiKey); // delete from insecure storage
  }
  
  return _load();
}

// In _load():
AppSettings _load() async {
  // ... all other settings from SharedPreferences ...
  final geminiKey = await SecureStorage.getGeminiApiKey() ?? '';
  return AppSettings(
    // ...
    geminiApiKey: geminiKey,
  );
}

// In setGeminiApiKey():
Future<void> setGeminiApiKey(String key) async {
  final trimmed = key.trim();
  await SecureStorage.setGeminiApiKey(trimmed); // replaces _prefs.setString
  state = state.whenData((s) => s.copyWith(geminiApiKey: trimmed));
}
```

> **Note:** `_load()` becomes `async` since `SecureStorage.getGeminiApiKey()` is async.
> Update `build()` to `await _load()`.

## Step 5: Remove the Old SharedPreferences Key Constant

```dart
// DELETE this line:
const _kGeminiApiKey = 'settings_gemini_api_key';
```

## Step 6: Verify

```bash
flutter analyze
flutter test
```

Manual: Set a Gemini API key in Settings. Force-stop the app. Reopen — key should still be present. Inspect `shared_prefs/FlutterSharedPreferences.xml` via ADB — key should NOT appear there.

## Affected Files

- `lib/features/settings/settings_provider.dart` — main migration target
- `lib/core/storage/secure_storage.dart` — new file
- `android/app/build.gradle` — ensure `minSdkVersion 21`
- `pubspec.yaml` — add `flutter_secure_storage`
