# Chessing — Task List

> Version 1.0 · 2026-10-13.
> Rules: Work top-to-bottom. One task = one clear branch/diff.
> S (≤ 2h), M (≤ 1 day), L (> 1 day).

---

## Phase 0 — Project Foundation & Environment

- [x] **T-0.1 (S)** Flutter project initialization with Android/iOS platform configurations.
- [x] **T-0.2 (S)** Setup `pubspec.yaml` dependencies: squares, bishop, stockfish, drift, supabase, riverpod, dio, fl_chart.
- [x] **T-0.3 (S)** Setup `.gitignore`, `analysis_options.yaml`, and environment configuration templates (`.env.example`).
- [x] **T-0.4 (S)** Configure GitHub Actions workflow for building Android APKs (`.github/workflows/build-apk.yml`).

---

## Phase 1 — Chess Board UI & Engine Play

- [x] **T-1.1 (M)** Implement 2D interactive chessboard via `squares` and `bishop` move engine.
- [x] **T-1.2 (M)** Integrate Stockfish UCI engine on background worker isolate with adjustable Elo/depth.
- [x] **T-1.3 (M)** Board interactions: tap-to-move, drag-and-drop, legal move dots, in-check pulse, threat overlay.
- [x] **T-1.4 (S)** Chess clocks supporting Bullet, Blitz, Rapid, Classical, and Increment time controls.
- [x] **T-1.5 (S)** Board Themes: Classic, Wood, Neon, and Minimal with dynamic theme switching in Settings.

---

## Phase 2 — Post-Game Analysis & Evaluation

- [x] **T-2.1 (L)** Full PGN game scan with Stockfish depth engine.
- [x] **T-2.2 (M)** Move classification algorithms (Brilliant, Best, Excellent, Inaccuracy, Mistake, Blunder).
- [x] **T-2.3 (M)** Interactive Centipawn evaluation curve (`fl_chart`) with scrub-to-move board synchronization.
- [x] **T-2.4 (S)** Best move alternative overlay with board directional arrows.

---

## Phase 3 — Gemini AI Coaching & Grandmaster Personas

- [x] **T-3.1 (M)** Create `CoachingService` with Google Gemini REST API integration via `x-goog-api-key`.
- [x] **T-3.2 (M)** Implement "Why this move?" tactical explainer translating raw engine lines into plain English.
- [x] **T-3.3 (M)** Grandmaster persona roleplay coach (Magnus Carlsen, Garry Kasparov, Mikhail Tal, Bobby Fischer).
- [x] **T-3.4 (S)** User API Key configuration UI with live validation ping in Settings.

---

## Phase 4 — Opening Theory & PGN Library

- [x] **T-4.1 (M)** Opening taxonomy organized by ECO codes (Open, Semi-Open, Closed, Indian Defenses).
- [x] **T-4.2 (M)** Interactive opening tree viewer with variation exploration and branch notes.
- [x] **T-4.3 (S)** Bookmarks and mastery tracking persisted in local Drift database.

---

## Phase 5 — Authentication & Credential Security

- [x] **T-5.1 (M)** Google Sign-In integrating with Supabase OAuth token exchange.
- [x] **T-5.2 (S)** Remove guest login to enforce secure, backed-up user accounts.
- [x] **T-5.3 (M)** Migrate Gemini API key storage from plaintext SharedPreferences to `flutter_secure_storage` (Android Keystore / iOS Keychain).
- [x] **T-5.4 (S)** Safeguard Supabase client initialization against uninitialized assertion crashes.
- [x] **T-5.5 (S)** Built-in Kotlin migration in `build.gradle.kts` removing deprecated `kotlin-android`.

---

## Phase 6 — Cloud Synchronization & Persistence

- [x] **T-6.1 (M)** Drift SQLite local database schemas for games, moves, profiles, and opening bookmarks.
- [x] **T-6.2 (M)** Bi-directional sync service with Supabase PostgreSQL and Row Level Security.
- [x] **T-6.3 (S)** Firebase Cloud Messaging (FCM) integration for daily reminder notifications.

---

## Phase 7 — Production Polish & App Store Launch

- [x] **T-7.1 (S)** Design high-resolution custom app icon (obsidian & gold knight with neural circuit accents).
- [ ] **T-7.2 (S)** Configure `flutter_launcher_icons` and generate multi-density mipmaps for Android and iOS.
- [ ] **T-7.3 (M)** Configure release signing keys (`key.properties`) for Play Store AAB generation.
- [ ] **T-7.4 (S)** Add Play Store screenshots and metadata package.
