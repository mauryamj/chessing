# Chessing — Full Development Roadmap

> Stack: Flutter · Riverpod · Stockfish UCI · Bishop · Drift · Supabase · Gemini API · Google Antigravity · Comprehensive Testing

---

## 1. Confirmed Technology Stack

| Domain | Choice | Rationale |
|---|---|---|
| **Framework** | Flutter (Dart 3.3+, null-safe) | Single cross-platform codebase, 60fps canvas rendering |
| **State Management** | Riverpod 2 (`@riverpod` code generation) | Testable, robust, dependency-injected state |
| **Chess Engine** | Stockfish 16+ UCI | Golden standard chess evaluation and bot play |
| **Chess Rules** | Bishop + Squares | Full FIDE rules, FEN/PGN parser, Zobrist hashing |
| **Local DB** | Drift (SQLite) | Reactive streams, type-safe queries, migration support |
| **Backend** | Supabase (PostgreSQL) | Authentication, Row Level Security, Cloud sync, Storage |
| **AI Coach** | Google Gemini (Gemini 2.5/3.5 Flash) | Context-aware move explanations, persona roleplaying |
| **Security** | `flutter_secure_storage` | Hardware Keystore/Keychain encryption for API keys |
| **Testing** | `flutter_test`, `mocktail` | Unit logic tests, provider container tests, widget tests |

---

## 2. Release Roadmap & Phases

```
┌────────────────┐     ┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│    Phase 1     │────▶│    Phase 2     │────▶│    Phase 3     │────▶│    Phase 4     │
│ Board & Engine │     │ Analysis & Eval│     │   AI Coaching  │     │ Theory Library │
└────────────────┘     └────────────────┘     └────────────────┘     └────────────────┘
                                                                             │
┌────────────────┐     ┌────────────────┐     ┌────────────────┐             │
│    Phase 7     │◀────│    Phase 6     │◀────│    Phase 5     │◀────────────┘
│ Release Polish │     │   Cloud Sync   │     │ Auth & Security│
└────────────────┘     └────────────────┘     └────────────────┘
```

---

### Phase 1: Core Board & Stockfish Engine (Completed)
- 2D interactive chessboard (`squares`) with tap and drag-and-drop input.
- Background isolate Stockfish UCI worker with difficulty Elo mapping (800 to 2800+).
- Move notation generation (SAN and UCI formats) and FEN serialization.
- Timed chess clocks: Bullet, Blitz, Rapid, Classical, and custom increments.
- 4 dynamic board themes: Classic, Wood, Neon, and Minimal.

### Phase 2: Post-Game Analysis & Evaluation Graphs (Completed)
- Background game evaluation worker analyzing every move in a completed match.
- Move classifications: Brilliant (`!!`), Best (`!`), Excellent, Inaccuracy (`?!`), Mistake (`?`), Blunder (`??`).
- Centipawn evaluation curve rendered with `fl_chart`.
- Scrubber integration: tap any point on the chart to instantly update the board to that move state.
- Best move visual overlay arrows comparing played move with engine recommendation.

### Phase 3: Gemini AI Coaching & Historical Personas (Completed)
- `CoachingService` communicating directly with Google Gemini REST API using `x-goog-api-key`.
- Tactical blunder explainer: "Why is this move a mistake?" in natural English.
- Grandmaster roleplay mode: chat advice styled after Magnus Carlsen, Garry Kasparov, Mikhail Tal, and Bobby Fischer.
- In-app user API key management in Settings with live connectivity test.

### Phase 4: Opening Theory & Repertoire Explorer (Completed)
- ECO-classified opening library with master game statistics.
- Interactive move tree allowing branch exploration and note viewing.
- Personal opening bookmarking saved to local Drift SQLite database.

### Phase 5: Authentication, Security & Hardening (Completed)
- Google Sign-In with Supabase Auth token exchange.
- Hardware-backed keystore integration via `flutter_secure_storage` for user API keys.
- Supabase initialization crash prevention and defensive error boundaries.
- Android build migration to Built-in Kotlin (Gradle 9+ compatibility).

### Phase 6: Cloud Synchronization & Notifications (Completed)
- Bi-directional sync service syncing Drift SQLite match histories and ratings with Supabase PostgreSQL.
- Strict Row Level Security (RLS) policies protecting user data.
- Firebase Cloud Messaging and local daily reminder scheduling.

### Phase 7: App Store Polish & Production Release (In Progress)
- [x] High-resolution app icon generation (obsidian & gold knight with neural accents).
- [ ] Multi-density launcher icon generation via `flutter_launcher_icons`.
- [ ] Release signing keystore (`key.properties`) setup.
- [ ] Play Store metadata, screenshots, and privacy policy documentation.

### Future Horizon (v1.5 & v2.0)
- **v1.5:** Real-time peer-to-peer multiplayer matchmaking via Supabase Realtime channels.
- **v1.6:** Spaced-repetition opening puzzle trainer.
- **v2.0:** Camera-based physical chessboard scanner using Gemini Vision multimodal API to convert physical boards into playable FEN positions.
