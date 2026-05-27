# Chess App – Flutter Implementation Plan

> Feed this file to your AI agent IDE. Each phase is a discrete, ordered task list.
> Stack: Flutter · Riverpod · Stockfish · Drift (SQLite) · go_router · fl_chart · LLM API (Claude)

---

## Project Structure

```
lib/
├── main.dart
├── app/
│   ├── router.dart              # go_router config
│   └── theme.dart               # light/dark theme
├── core/
│   ├── engine/
│   │   ├── stockfish_service.dart   # isolate wrapper
│   │   └── engine_models.dart
│   ├── database/
│   │   ├── app_database.dart        # drift DB
│   │   ├── tables/
│   │   │   ├── games_table.dart
│   │   │   ├── moves_table.dart
│   │   │   └── profile_table.dart
│   │   └── daos/
│   │       ├── games_dao.dart
│   │       └── profile_dao.dart
│   ├── ai/
│   │   └── coaching_service.dart    # LLM API calls
│   └── pgn/
│       └── pgn_parser.dart
├── features/
│   ├── play/
│   │   ├── setup/
│   │   │   ├── game_setup_screen.dart
│   │   │   └── game_setup_provider.dart
│   │   ├── board/
│   │   │   ├── board_screen.dart
│   │   │   ├── board_provider.dart
│   │   │   ├── widgets/
│   │   │   │   ├── chess_board_widget.dart
│   │   │   │   ├── threat_overlay.dart
│   │   │   │   ├── legal_moves_overlay.dart
│   │   │   │   ├── clock_widget.dart
│   │   │   │   ├── captured_pieces_bar.dart
│   │   │   │   └── material_diff_bar.dart
│   │   │   └── board_state.dart
│   │   └── review/
│   │       ├── review_screen.dart
│   │       ├── review_provider.dart
│   │       └── widgets/
│   │           ├── eval_bar.dart
│   │           ├── best_move_card.dart
│   │           ├── blunder_map.dart
│   │           └── move_timeline.dart
│   ├── theory/
│   │   ├── library/
│   │   │   ├── theory_library_screen.dart
│   │   │   └── theory_provider.dart
│   │   ├── detail/
│   │   │   ├── theory_detail_screen.dart
│   │   │   └── widgets/
│   │   │       ├── board_demo_widget.dart
│   │   │       └── variation_tree.dart
│   │   └── models/
│   │       └── theory_entry.dart
│   ├── roleplay/
│   │   ├── roleplay_home_screen.dart
│   │   ├── roleplay_provider.dart
│   │   └── modes/
│   │       ├── why_this_move_screen.dart
│   │       ├── coach_persona_screen.dart
│   │       └── historical_match_screen.dart
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   ├── profile_provider.dart
│   │   └── widgets/
│   │       ├── rating_card.dart
│   │       ├── wdl_donut.dart
│   │       └── achievements_grid.dart
│   └── history/
│       ├── match_log_screen.dart
│       ├── performance_screen.dart
│       ├── history_provider.dart
│       └── widgets/
│           ├── match_list_tile.dart
│           ├── rating_chart.dart
│           └── accuracy_chart.dart
└── shared/
    ├── models/
    │   ├── game_model.dart
    │   ├── move_model.dart
    │   └── user_profile.dart
    └── widgets/
        └── app_bottom_nav.dart
```

---

## Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Chess
  squares: ^5.0.0              # board UI + drag/drop
  bishop: ^2.0.0               # move generation (pairs with squares)
  stockfish: ^2.0.0            # Stockfish native plugin

  # Navigation
  go_router: ^13.0.0

  # State management
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

  # Local database
  drift: ^2.18.0
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.0
  path: ^1.9.0

  # Networking (LLM API)
  dio: ^5.4.0

  # Charts
  fl_chart: ^0.68.0

  # Utilities
  shared_preferences: ^2.2.0
  uuid: ^4.4.0
  intl: ^0.19.0

dev_dependencies:
  build_runner: ^2.4.0
  drift_dev: ^2.18.0
  riverpod_generator: ^2.3.0
```

---

## Phase 1 – Core Board (Week 1–3)

**Goal:** Playable game against Stockfish bot with clock.

### 1.1 Project bootstrap
- [ ] Run `flutter create chess_app --org com.yourcompany`
- [ ] Add all dependencies listed above to `pubspec.yaml`
- [ ] Run `flutter pub get`
- [ ] Create folder structure as shown above

### 1.2 Theme & routing
- [ ] Implement `app/theme.dart`
  - Light and dark `ThemeData` using `ColorScheme.fromSeed`
  - Custom chess board colors (cream / dark-brown) as theme extensions
- [ ] Implement `app/router.dart` with `go_router`
  - Routes: `/`, `/setup`, `/board`, `/review/:gameId`, `/theory`, `/theory/:id`, `/roleplay`, `/profile`, `/history`
  - Shell route wrapping all tabs with `AppBottomNav`
- [ ] Implement `shared/widgets/app_bottom_nav.dart` (5 tabs)

### 1.3 Stockfish engine service
- [ ] Create `core/engine/stockfish_service.dart`
  - Spawn Stockfish in a `dart:isolate` or use the plugin's stream API
  - Expose `Future<String> getBestMove(String fen, {int depth = 15})` 
  - Expose `Stream<int> analysisStream(String fen)` for eval bar
  - Map skill level 1–10 to UCI `setoption name Skill Level value X`
  - Dispose isolate on game end

### 1.4 Game setup screen
- [ ] Create `features/play/setup/game_setup_screen.dart`
  - Mode selector: Timed / Free / Level
  - Timed sub-options: Bullet (1+0), Blitz (3+2, 5+0), Rapid (10+0, 15+10)
  - Level slider: 1 (Beginner) → 10 (Master) — hidden if Timed mode
  - Color picker: White / Black / Random
  - "Play" button navigates to `/board` passing `GameConfig` as extra
- [ ] Create `features/play/setup/game_setup_provider.dart`
  - `GameConfigNotifier` holds current `GameConfig` state

### 1.5 Chess board screen
- [ ] Create `features/play/board/board_state.dart`
  ```dart
  class BoardState {
    final String fen;
    final List<String> moves;       // UCI move list
    final bool isPlayerTurn;
    final String? lastMove;
    final GameStatus status;        // playing | checkmate | stalemate | draw
    final Duration whiteTime;
    final Duration blackTime;
  }
  ```
- [ ] Create `features/play/board/board_provider.dart`
  - `BoardNotifier extends AsyncNotifier<BoardState>`
  - Handle legal move validation via `bishop`
  - After each player move → call `StockfishService.getBestMove()` → apply bot move
  - Tick clocks using a `Timer.periodic` — pause on bot turn
  - Detect game-over conditions and emit `GameStatus`
- [ ] Create `features/play/board/widgets/chess_board_widget.dart`
  - Use `squares` package `Board` widget
  - Pass `BoardController` from provider
  - Highlight last move squares (from/to)
  - Show check highlight on king square
- [ ] Create `features/play/board/widgets/clock_widget.dart`
  - Displays `mm:ss` — turns red under 10 seconds
  - Hidden in Free mode
- [ ] Create `features/play/board/widgets/captured_pieces_bar.dart`
  - Row of captured piece SVGs grouped by type
- [ ] Create `features/play/board/widgets/material_diff_bar.dart`
  - Shows `+N` advantage for leading side
- [ ] Assemble `features/play/board/board_screen.dart`
  - Stack: board + clock top + clock bottom + captured bars + action buttons (Resign / Offer Draw)

### 1.6 Database – games table
- [ ] Define `core/database/tables/games_table.dart`
  ```dart
  class Games extends Table {
    IntColumn get id => integer().autoIncrement()();
    TextColumn get pgn => text()();
    TextColumn get result => text()();          // '1-0' | '0-1' | '1/2-1/2'
    TextColumn get mode => text()();            // 'timed' | 'free' | 'level'
    IntColumn get botLevel => integer().nullable()();
    IntColumn get timeControlSeconds => integer().nullable()();
    DateTimeColumn get playedAt => dateTime()();
    IntColumn get playerAccuracy => integer().nullable()();
  }
  ```
- [ ] Define `core/database/tables/moves_table.dart`
  ```dart
  class Moves extends Table {
    IntColumn get id => integer().autoIncrement()();
    IntColumn get gameId => integer().references(Games, #id)();
    IntColumn get ply => integer()();
    TextColumn get uci => text()();
    TextColumn get san => text()();
    IntColumn get evalCentipawns => integer().nullable()();
    TextColumn get classification => text().nullable()(); // 'best'|'good'|'inaccuracy'|'mistake'|'blunder'
  }
  ```
- [ ] Run `flutter pub run build_runner build`
- [ ] Implement `core/database/daos/games_dao.dart`
  - `insertGame`, `getAllGames`, `getGameById`, `getRecentGames(int limit)`

---

## Phase 2 – Overlays & Post-Game Review (Week 4–5)

**Goal:** Threat HUD, legal moves overlay, and full post-game review with best-move coaching.

### 2.1 Threat overlay
- [ ] Create `features/play/board/widgets/threat_overlay.dart`
  - Calculate all squares attacked by opponent pieces from current FEN
  - Draw semi-transparent red circles on those squares
  - Toggled by a shield icon button on the board screen
  - Use `bishop` package's attack generation or compute manually from FEN

### 2.2 Legal moves HUD
- [ ] Create `features/play/board/widgets/legal_moves_overlay.dart`
  - On piece tap, show dots on all legal destination squares
  - Dot style: hollow circle for empty squares, ring for captures
  - This is distinct from the threat overlay — shows YOUR pieces' moves, not enemy attacks

### 2.3 Post-game review screen
- [ ] Create `features/play/review/review_screen.dart`
  - Board in replay mode (no interaction, only prev/next navigation)
  - Move list panel: SAN notation, colored by classification (green=best, yellow=inaccuracy, orange=mistake, red=blunder)
  - Swipe or arrow buttons to step through plies
- [ ] Create `features/play/review/widgets/eval_bar.dart`
  - Vertical bar, white/black fill proportion based on centipawn eval
  - Animates smoothly between moves
- [ ] Create `features/play/review/widgets/move_timeline.dart`
  - Horizontal scrubber showing eval graph over the game
  - Tap any point to jump to that ply
- [ ] Create `features/play/review/widgets/blunder_map.dart`
  - Summary: counts of best / good / inaccuracy / mistake / blunder moves
  - Tap a blunder → jumps board to that ply
- [ ] Create `features/play/review/review_provider.dart`
  - Loads game PGN from DB
  - Re-runs Stockfish at depth 18 on each position to classify moves
  - Stores classifications back to `moves` table

### 2.4 Best-move hint card
- [ ] Create `features/play/review/widgets/best_move_card.dart`
  - Shows a move arrow overlay on the board (from-square → to-square)
  - Below the board: a `Card` with one short sentence explaining the best move
  - Sentence comes from `CoachingService` (see Phase 3)
  - "Show best move" button visible on review screen for each ply

---

## Phase 3 – AI Coaching & Theory (Week 6–7)

**Goal:** LLM-powered coaching tips, roleplay modes, and theory library.

### 3.1 Coaching service
- [ ] Create `core/ai/coaching_service.dart`
  - Base method:
    ```dart
    Future<String> ask(String systemPrompt, String userMessage);
    ```
  - Uses `dio` to POST to Claude API (`/v1/messages`)
  - Set `anthropic-version` header and `x-api-key` (from env / `--dart-define`)
  - Model: `claude-sonnet-4-20250514`, `max_tokens: 300`
  - Handle rate limit and network errors gracefully

### 3.2 Best-move tip generation
- [ ] In `CoachingService`, add:
  ```dart
  Future<String> getBestMoveTip({
    required String fen,
    required String bestMoveUci,
    required String playerMoveUci,
  });
  ```
  - System prompt: "You are a chess coach. Given a position, explain in one sentence (max 20 words) why the suggested move is better than what the player played."
  - Pass FEN + both moves in user message
  - Return tip string → displayed in `BestMoveCard`

### 3.3 Roleplay – Why this move?
- [ ] Create `features/roleplay/modes/why_this_move_screen.dart`
  - User can paste a FEN or load from recent games
  - Select any move from the legal moves list
  - Tap "Explain" → calls `CoachingService.explainMove(fen, moveUci)`
  - System prompt: "You are Magnus Carlsen. Explain your reasoning for this chess move in 2–3 sentences in first person."
  - Display response in a styled chat bubble with a board showing the position

### 3.4 Roleplay – Chess coach persona
- [ ] Create `features/roleplay/modes/coach_persona_screen.dart`
  - Conversational chat UI (`ListView` of bubbles + text field)
  - Full game PGN sent as context in system prompt
  - System prompt: "You are a grandmaster chess coach reviewing this game. Answer questions about positions, decisions, and improvements."
  - Maintain conversation history in provider (list of `{role, content}` maps)
  - "Load current game" button pre-fills context

### 3.5 Roleplay – Historical match
- [ ] Create `features/roleplay/modes/historical_match_screen.dart`
  - Dropdown of bundled famous games (Fischer–Spassky 1972 G6, Kasparov–Deep Blue 1997 G2, etc.)
  - Board steps through the game ply by ply
  - Each move triggers `CoachingService.commentMove(fen, moveSan, playerName)`
  - System prompt: "You are a chess commentator. In 1–2 sentences, explain what {playerName} just did and why."
  - Store famous games as PGN strings in `assets/pgn/`

### 3.6 Theory library
- [ ] Create `assets/theory/theory.json` — seed data:
  ```json
  [
    {
      "id": "sicilian-najdorf",
      "phase": "opening",
      "title": "Sicilian Defence – Najdorf",
      "summary": "Black's most popular response to 1.e4, fighting for the centre asymmetrically.",
      "moves": ["e2e4","c7c5","g1f3","d7d6","d2d4","c5d4","f3d4","g8f6","b1c3","a7a6"],
      "keyIdeas": ["Control d5","Queenside counterplay","Sharp tactical positions"],
      "variations": [...]
    }
  ]
  ```
- [ ] Create `features/theory/models/theory_entry.dart` matching JSON shape
- [ ] Create `features/theory/library/theory_provider.dart`
  - Loads JSON from assets on first launch
  - Exposes filtered list by phase (`opening` / `middlegame` / `endgame`) and search query
- [ ] Create `features/theory/library/theory_library_screen.dart`
  - Segmented control: Openings / Middlegame / Endgames
  - Search bar filters by title and key ideas
  - `ListView` of `TheoryCard` tiles
- [ ] Create `features/theory/detail/theory_detail_screen.dart`
  - Board at top showing current position in the line
  - Prev / Next buttons to step through `moves`
  - Key ideas chips
  - Variation tree (`VariationTree` widget) below

---

## Phase 4 – Profile & History (Week 8–9)

**Goal:** User profile, match log, and performance charts.

### 4.1 Profile data model
- [ ] Define `core/database/tables/profile_table.dart`
  ```dart
  class Profile extends Table {
    IntColumn get id => integer().autoIncrement()();
    TextColumn get username => text().withDefault(const Constant('Player'))();
    TextColumn get avatarPath => text().nullable()();
    IntColumn get currentRating => integer().withDefault(const Constant(800))();
    IntColumn get peakRating => integer().withDefault(const Constant(800))();
    IntColumn get gamesPlayed => integer().withDefault(const Constant(0))();
    IntColumn get wins => integer().withDefault(const Constant(0))();
    IntColumn get draws => integer().withDefault(const Constant(0))();
    IntColumn get losses => integer().withDefault(const Constant(0))();
    DateTimeColumn get createdAt => dateTime()();
  }
  ```
- [ ] Implement `core/database/daos/profile_dao.dart`
  - `getProfile`, `upsertProfile`, `updateRating`

### 4.2 Rating calculation
- [ ] In `core/engine/`, create `rating_service.dart`
  - Simple Elo: `newRating = oldRating + K * (score - expected)`
  - `K = 32` for < 2100, `K = 24` for 2100–2400
  - Map bot level 1–10 to approximate Elo (Level 1 ≈ 600, Level 10 ≈ 2200)
  - Call after each game, persist to `profile` table

### 4.3 Profile screen
- [ ] Create `features/profile/widgets/rating_card.dart`
  - Current rating large, peak rating small, trend arrow (+/- last 10 games)
- [ ] Create `features/profile/widgets/wdl_donut.dart`
  - `fl_chart` `PieChart` with Win (green) / Draw (gray) / Loss (red) segments
  - Center label: total games played
- [ ] Create `features/profile/widgets/achievements_grid.dart`
  - Badge list. Define milestones:
    - First win, 10 games, 50 games, 100 games
    - First win vs Level 5+, First win vs Level 8+
    - Win streak of 3, 5, 10
    - Accuracy ≥ 90% in a game
  - Locked badges shown as greyed out with lock icon
- [ ] Assemble `features/profile/profile_screen.dart`
  - Avatar (image_picker for custom photo, initials fallback)
  - Username (inline edit on tap)
  - `RatingCard`, `WdlDonut`, `AchievementsGrid`
  - Settings tile → theme toggle, sound toggle, about

### 4.4 Match log screen
- [ ] Create `features/history/widgets/match_list_tile.dart`
  - Result chip (W/D/L colored), date, mode, bot level, accuracy %, duration
  - Tap → navigate to `/review/:gameId`
- [ ] Create `features/history/match_log_screen.dart`
  - Filter row: All / Wins / Losses / Draws
  - Sort: Most recent / Highest accuracy / Longest game
  - `ListView` of `MatchListTile`
  - Empty state illustration

### 4.5 Performance charts
- [ ] Create `features/history/widgets/rating_chart.dart`
  - `fl_chart` `LineChart` — x: game number, y: rating after game
  - Dot on each data point, tap shows tooltip with date + result
- [ ] Create `features/history/widgets/accuracy_chart.dart`
  - `BarChart` — x: last 20 games, y: accuracy percentage
  - Color bars green / yellow / red by accuracy range (>85 / 65–85 / <65)
- [ ] Create `features/history/performance_screen.dart`
  - Two charts stacked
  - Summary stats: average accuracy, longest win streak, best rating gain in a week

---

## Phase 5 – Polish & Offline (Week 10)

**Goal:** Animations, accessibility, offline support, final QA.

### 5.1 Animations
- [ ] Piece move animation: animate piece sliding from source to destination square (200ms ease-in-out) — use `squares` package's built-in animation config
- [ ] Capture animation: brief scale-down on captured piece before removal
- [ ] Eval bar: `AnimatedContainer` height transitions between moves (300ms)
- [ ] Best-move arrow: fade in over 250ms when `BestMoveCard` appears
- [ ] Page transitions: custom slide transition for board → review navigation

### 5.2 Accessibility
- [ ] All interactive elements have `Semantics` labels
- [ ] Board squares announced by screen reader as "e4, white pawn"
- [ ] Minimum tap target 48×48dp on all buttons
- [ ] High-contrast mode: respect `MediaQuery.highContrast`
- [ ] Font scaling: all text uses `sp` units (via `TextScaler`)

### 5.3 Offline support
- [ ] Theory content fully bundled in assets — no network needed
- [ ] Stockfish runs on-device — no network needed for gameplay
- [ ] `CoachingService` gracefully degrades: if no network, show "Coaching unavailable offline" instead of error
- [ ] Queue failed coaching requests and retry when online (use `connectivity_plus`)

### 5.4 Settings screen
- [ ] Board theme picker: Classic / Wood / Neon / Minimal (4 `BoardTheme` presets)
- [ ] Piece set picker: Standard / Neo / Alpha (use different SVG asset sets)
- [ ] Sound toggle: move sound, capture sound, clock warning
- [ ] Haptics toggle: light impact on move, heavy on check

### 5.5 Final QA checklist
- [ ] Engine isolate disposes correctly on every navigation path
- [ ] DB migrations tested (add `MigrationStrategy` to `AppDatabase`)
- [ ] No memory leaks from Stockfish stream subscriptions
- [ ] All `async` providers have loading and error states handled
- [ ] Screenshots on 3 device sizes (small phone, large phone, tablet)
- [ ] `flutter analyze` passes with zero warnings
- [ ] `flutter test` coverage ≥ 60% for business logic (engine service, rating calc, PGN parser)

---

## Key Architectural Decisions

| Concern | Choice | Reason |
|---|---|---|
| State management | Riverpod (code gen) | Compile-safe, testable, works well with async |
| Database | Drift (SQLite) | Type-safe, reactive streams, no cloud dependency |
| Chess engine | Stockfish plugin | Industry standard, runs on-device |
| Move generation | bishop + squares | Designed to work together, good Flutter integration |
| Navigation | go_router | Deep link support, shell routes for bottom nav |
| Charts | fl_chart | No dependencies, highly customisable |
| AI coaching | Claude API (Sonnet) | Best instruction-following for chess context |
| Board UI | squares | Most maintained Flutter chess board package |

---

## Environment Setup

```bash
# Add API key via dart-define (never hardcode)
flutter run --dart-define=CLAUDE_API_KEY=your_key_here

# Access in code
const apiKey = String.fromEnvironment('CLAUDE_API_KEY');
```

Add to `.gitignore`:
```
.env
*.key
```

---

## Data Flow Summary

```
User taps square
  → BoardNotifier.onSquareTap(square)
    → bishop validates legal moves
      → if legal: apply move to FEN
        → StockfishService.getBestMove(newFen, depth)
          → Stockfish UCI response parsed
            → apply bot move to FEN
              → update BoardState
                → board widget rebuilds
                  → on game end: save to DB via GamesDao
                    → RatingService.calculate() → update Profile
                      → navigate to /review/:gameId
```

---

## Notes for AI Agent

- Implement phases in order — later phases depend on providers and DB tables from earlier ones.
- Each `// TODO:` in generated code should be treated as a discrete task.
- Prefer `AsyncNotifierProvider` over `FutureProvider` for mutable state.
- All Stockfish calls must be in an isolate — never on the main thread.
- The `squares` + `bishop` package combo requires `SquaresState` to bridge between them; see the packages' README for the glue code pattern.
- For the best-move arrow overlay, draw on a `CustomPainter` layered over the `Board` widget, not inside it.
- LLM prompts are in `core/ai/prompts.dart` as constants — keep them there for easy tuning.
