# Chessing — Architecture Specification

> Version 1.0 · 2026-10-13 · Source of truth for architecture and technical patterns.

---

## 1. Technology Stack

| Concern | Technology / Package | Role & Justification |
|---|---|---|
| **Framework** | Flutter 3.x (Dart 3.3+, null-safe) | Cross-platform high-performance 60fps UI |
| **State Management** | `flutter_riverpod` + `riverpod_annotation` | Compile-safe, testable reactive state via code-gen `@riverpod` |
| **Routing** | `go_router: ^13.0.0` | Declarative URL routing, stack redirects, deep-linking |
| **Chess Engine** | `stockfish: ^1.8.1` | Native UCI engine binary running in a background worker isolate |
| **Chess Rules & UI** | `bishop` + `squares` + `square_bishop` | Complete FIDE rule validation, FEN/PGN parsing, responsive 2D board |
| **Local Database** | `drift` + `sqlite3_flutter_libs` | Type-safe, reactive SQLite database for offline-first persistence |
| **Cloud Backend** | `supabase_flutter: ^2.18.0` | PostgreSQL database, Row Level Security, Auth, Cloud Storage |
| **Secrets & Keys** | `flutter_secure_storage: ^11.2.0` | Hardware-backed keystore (Android Keystore / iOS Keychain) |
| **Networking** | `dio: ^5.4.0` | HTTP client for Gemini API and REST communication |
| **AI Integration** | Google Gemini API (REST) | AI coaching, game insights, and Grandmaster persona roleplaying |
| **Notifications** | `firebase_messaging` + `flutter_local_notifications` | Push notifications and scheduled local daily training reminders |
| **Testing** | `flutter_test`, `mocktail` | Unit tests, Riverpod container tests, Widget rendering tests |
| **CI / CD** | GitHub Actions | Automated linting, test suites, and release APK building |

---

## 2. Architectural Layers (Clean Feature-First Architecture)

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│   (Screens, ConsumerWidgets, UI State Notifiers)       │
└───────────────────────────▲────────────────────────────┘
                            │ Watches / Calls
┌───────────────────────────┴────────────────────────────┐
│                      Domain Layer                      │
│   (Entities, Value Objects, Move Rules, Contracts)     │
└───────────────────────────▲────────────────────────────┘
                            │ Implements
┌───────────────────────────┴────────────────────────────┐
│                       Data Layer                       │
│ (Drift DAOs, Supabase Repos, Stockfish UCI, SecureStore)│
└────────────────────────────────────────────────────────┘
```

### Dependency Rules:
1. **Presentation depends on Domain & Providers:** Widgets never interact directly with raw SQL or raw Supabase calls; they call Riverpod notifiers or repository abstractions.
2. **Domain is pure:** Contains game models, move notations, and interfaces.
3. **Data implements Domain contracts:** Manages SQLite reads/writes, Supabase network requests, and external APIs.
4. **Isolate Isolation:** Heavy computations (Stockfish engine searches, full PGN tree generation) run in background isolates to avoid dropping UI frames.

---

## 3. Directory Layout

```
lib/
├── app/
│   ├── router.dart             # GoRouter setup, ShellRoute, redirect guards
│   └── theme.dart              # Material 3 light/dark themes, ChessBoardTheme extensions
├── core/
│   ├── ai/                     # Gemini CoachingService, prompts, persona definitions
│   ├── auth/                   # AuthNotifier, AuthStateModel, Google Sign-In wiring
│   ├── cache/                  # In-memory LRU caching utilities
│   ├── database/               # Drift AppDatabase, DAOs, schema tables, migrations
│   ├── engine/                 # StockfishEngineService, UCI bridge, difficulty mappings
│   ├── firebase/               # FCMService, token registration, background message handlers
│   ├── pgn/                    # PGN reader/writer, ECO classifier, move annotators
│   ├── storage/                # SecureStorage (hardware Keystore/Keychain helper)
│   ├── supabase/               # SupabaseClient configuration, repositories, SyncService
│   └── utils/                  # Move helpers, sound/haptic players, time formatters
├── features/
│   ├── auth/                   # LoginScreen, SplashScreen
│   ├── history/                # MatchLogScreen, PerformanceScreen, stats charts
│   ├── play/                   # GameSetupScreen, BoardScreen, ReviewScreen (graphs/arrows)
│   ├── profile/                # ProfileScreen, avatar upload, rating badges
│   ├── roleplay/               # RoleplayHomeScreen, WhyThisMoveScreen, PersonaCoachScreen
│   ├── settings/               # SettingsScreen, settings_provider, thematic sections
│   └── theory/                 # TheoryLibraryScreen, TheoryDetailScreen
└── shared/
    └── widgets/                # Common buttons, chess clock, bottom nav, error dialogs
```

---

## 4. Key Subsystems & Data Flows

### A. Stockfish Engine & Bishop Rules Pipeline
1. Board interactions emit moves to `BoardNotifier`.
2. `Bishop` validates move legality, updates the FEN, and triggers clock decrements.
3. If it is the bot's turn, `BoardNotifier` dispatches the current position FEN and difficulty config (depth, skill level, time limit) to `StockfishEngineService`.
4. Stockfish runs via native isolate process, returns best move UCI (e.g., `e7e5`), and `BoardNotifier` applies the move.

### B. Offline-First Cloud Synchronization
```
[User Action / Game Finished]
         │
         ▼
[Local Drift SQLite Database] (Instant write, flags is_synced = 0)
         │
         ▼
  [Online Check?]
    ├── NO  ──> Remains in Drift pending sync queue
    └── YES ──> SyncService pushes row to Supabase PostgreSQL (RLS filtered)
                  └── On Success ──> Updates local row is_synced = 1
```

### C. Gemini AI Coaching Flow
1. User requests move analysis ("Why was this a mistake?").
2. App queries `SettingsNotifier` for user's Gemini API key from `SecureStorage`.
3. If key is present: `CoachingService` builds prompt with current FEN, move UCI, and engine evaluation, calling Google Gemini via `x-goog-api-key` header.
4. Response streams or loads directly into `WhyThisMoveScreen` or `BestMoveCard`.
5. If key is missing: UI presents clear, user-friendly prompt directing the user to enter their free API key in Settings.
