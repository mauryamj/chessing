---
description: Core architecture, Riverpod generator, Drift database, state boundaries, and key file map for Chessing.
---

# Chessing Architecture Reference

## 1. State Management — Riverpod 2.x

- **Exclusively use `@riverpod` annotations** via `riverpod_annotation`. Never hand-roll legacy `StateNotifierProvider`.
- Every file declaring providers, Drift tables, or Freezed models MUST contain its part directive:
  ```dart
  part 'filename.g.dart';
  ```
- After any change to annotated files:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```

## 2. Key File Map

| Responsibility | File |
|---------------|------|
| Router / navigation | `lib/app/router.dart` |
| App theme | `lib/app/theme.dart` |
| Auth state machine | `lib/core/auth/auth_provider.dart` + `auth_state.dart` |
| Supabase client (singleton) | `lib/core/supabase/supabase_client.dart` |
| Local SQLite DB (Drift) | `lib/core/database/app_database.dart` |
| Cache invalidation | `lib/core/cache/cache_service.dart` |
| Offline-first pattern | `lib/core/cache/offline_first_repository.dart` |
| Game engine (Stockfish + mock) | `lib/core/engine/stockfish_service.dart` |
| Elo rating | `lib/core/engine/rating_service.dart` |
| Gemini coaching | `lib/core/ai/coaching_service.dart` |
| FCM notifications | `lib/core/firebase/fcm_service.dart` |
| Board game state | `lib/features/play/board/board_provider.dart` |
| Profile state (local) | `lib/features/profile/profile_provider.dart` |
| Settings (sound/haptics/key) | `lib/features/settings/settings_provider.dart` |

## 3. Data Flow — Offline-First Pattern

```
User Action
    │
    ▼
Feature Provider (Riverpod)
    │
    ├──► CacheService.hasCache(key)?
    │         │
    │    Yes ◄┴► No
    │    │         │
    │    │         ▼
    │    │    fetchFromRemote() → Supabase
    │    │         │
    │    │    saveToLocal() → Drift
    │    │         │
    │    ▼         ▼
    │   fetchFromLocal() → Drift
    │         │
    │    [background] isStale? → _backgroundRefresh()
    │
    ▼
UI Widget reads from provider
```

## 4. Auth State Machine

```
AuthLoading  ──────────────────────────────────────────────────────────────►  AuthAuthenticated(user)
     │                                                                              │
     │   Google sign-in fails / Guest                                              │  signOut()
     ▼                                                                              ▼
AuthError ◄─── deleteAccount() fails       AuthGuest ◄─── signInAsGuest()   AuthUnauthenticated
     │
     │  (redirected to /login by router)
```

## 5. Database Schema (Drift, v4)

| Table | Key Columns |
|-------|-------------|
| `games` | id, pgn, result, mode, botLevel, playedAt, playerColorIndex, pendingSync, remoteId |
| `moves` | id, gameId, ply, uci, san, evalCentipawns, classification, bestMoveUci |
| `profile` | id, username, avatarUrl, currentRating, peakRating, wins, draws, losses, gamesPlayed, remoteId |
| `cache_meta` | key, fetchedAt, itemCount |
| `theory_entries` | id, title, fen, moves, description, difficulty, sortOrder |
| `theory_user_data` | theoryId, isBookmarked, isCompleted |
| `historical_matches` | id, opponentName, pgn, year, description |

## 6. Adding a New Feature — Required Steps

1. Create `lib/features/<name>/` with subdirectories: `presentation/` (screens, widgets), `presentation/controllers/` (Riverpod providers), `data/` (repositories).
2. Add `GoRoute` in `lib/app/router.dart` — use `parentNavigatorKey: _rootNavigatorKey` for full-screen routes, or place inside `ShellRoute` for bottom-nav routes.
3. Create test file: `test/features/<name>/<name>_provider_test.dart`.
4. Run `dart run build_runner build --delete-conflicting-outputs`.
5. Run `flutter analyze && flutter test`.

## 7. Stockfish Integration

- `StockfishService` wraps the native `stockfish` package with a mock fallback using Bishop.
- The mock is activated when `_useMock = true` (Stockfish init fails, or platform is unsupported).
- `getBestMove(fen, level: n)` — `n` is 1–10, mapped to Stockfish skill level 1–20.
- `analyzePosition(fen)` — returns `AnalysisResult(bestMove, eval)` in centipawns.
- The service is provided via `stockfishServiceProvider` (non-autoDispose — lives for app lifetime).
- **Important:** `StockfishService.dispose()` must be called on app exit. Currently missing — tracked as item A5 in the professional checklist.