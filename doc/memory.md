# Chessing — Project Memory & Decisions Log

> The agent's long-term memory for Chessing. Read at the start of every session; update at the end.
> Never store sensitive credentials (API keys, passwords) here.

---

## 1. Project Identity

- **App:** Chessing — Flutter Chess Trainer with Stockfish engine play, deep analysis, and Gemini AI coaching.
- **Package ID:** `com.example.chessing`
- **Stack:** Flutter 3.x · Dart 3.3+ · Riverpod 2 (`@riverpod`) · GoRouter · Drift (SQLite) · Supabase Flutter · Stockfish UCI · Bishop · Squares · Dio · Firebase Messaging · flutter_secure_storage.
- **IDE:** Google Antigravity.
- **Design Tokens:** 4 Board themes (Classic, Wood, Neon, Minimal) in [`lib/app/theme.dart`](file:///d:/M/flutter/chessing/lib/app/theme.dart).

---

## 2. Current State

- **Date of Last Update:** 2026-10-13
- **Phase:** Phase 6 complete; Phase 7 (Release preparation) in progress.
- **Last Completed Work:**
  1. Migrated Gemini API key storage to hardware-backed [`SecureStorage`](file:///d:/M/flutter/chessing/lib/core/storage/secure_storage.dart) (`flutter_secure_storage`).
  2. Fixed Supabase uninitialized assertion crash on startup by adding fallback environment handling and null guards in [`AuthRepository`](file:///d:/M/flutter/chessing/lib/core/supabase/repositories/auth_repository.dart).
  3. Fixed Google Sign-In `ApiException: 10` on Android: removed `clientId` on Android in [`AuthProvider`](file:///d:/M/flutter/chessing/lib/core/auth/auth_provider.dart), set `serverClientId`, and mapped Web OAuth Client ID.
  4. Removed "Play as Guest" login option to ensure all user matches and progress sync to cloud.
  5. Migrated Android Gradle setup to Built-in Kotlin (removed deprecated `kotlin-android` from `build.gradle.kts`).
  6. Generated official app icon in [`assets/icon/app_icon.jpg`](file:///d:/M/flutter/chessing/assets/icon/app_icon.jpg).
  7. Added 6 core engineering skills to `.agents/skills/`.
- **Next Task:** `T-7.2`: Configure `flutter_launcher_icons` to generate mipmap assets from the new icon.

---

## 3. Decisions Log

### D-01: Riverpod 2 Code-Gen Standard
- **Decision:** All new state providers must use `@riverpod` annotations from `riverpod_annotation`.
- **Reason:** Ensures compile-time safety, auto-disposal semantics, and eliminates boilerplate.

### D-02: Offline-First Hybrid Storage (Drift + Supabase)
- **Decision:** All gameplay actions write synchronously to local Drift SQLite first; background sync pushes rows to Supabase when connectivity is confirmed.
- **Reason:** Prevents any move lag or match loss during network drops or subway commutes.

### D-03: User-Owned Gemini API Keys via Keystore
- **Decision:** Users configure their own Gemini API key directly in **Settings > AI & Coaching**. Stored exclusively via `flutter_secure_storage`.
- **Reason:** Prevents exposing developer billing limits and keeps the app 100% free and sustainable. Android Keystore / iOS Keychain prevents plaintext XML extraction on rooted devices.

### D-04: Android Google Sign-In Architecture
- **Decision:** In Flutter's `GoogleSignIn`, `clientId` is set to `null` on Android, while `serverClientId` is set to the Web Client ID (`270105926493-eg0db58im8t2pq59f9njcu2qkuifo4gf.apps.googleusercontent.com`).
- **Reason:** Passing `clientId` on Android causes Google Play Services to look for a matching Android client ID, triggering `ApiException: 10` (Developer Error).

### D-05: Built-in Kotlin over Legacy Plugin
- **Decision:** Removed `id("kotlin-android")` from `android/app/build.gradle.kts`.
- **Reason:** Flutter 3.27+ Gradle plugin automatically configures Kotlin. Legacy plugin triggers deprecation warnings on Gradle 9+.

---

## 4. Known Gotchas & Troubleshooting

1. **Firebase Options on CI:**
   - [`lib/firebase_options.dart`](file:///d:/M/flutter/chessing/lib/firebase_options.dart) and [`android/app/google-services.json`](file:///d:/M/flutter/chessing/android/app/google-services.json) must remain tracked in git so GitHub Actions can build the release APK.
2. **Local Debug Keystore SHA-1:**
   - Local debug fingerprint: `35:F4:7A:92:16:40:1B:D4:F9:CA:32:91:9F:96:80:60:42:98:90:71`.
   - Must be registered in Firebase Console under `chessing-app-mauryamj` for Google Sign-In to succeed on local debug runs.
