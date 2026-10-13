# Chessing — Product Requirements Document (PRD)

> Version 1.0 · 2026-10-13 · Owner: Maurya
> Read this first. Then read `architecture.md`, `design.md`, `rules.md`, `task.md`, `memory.md`.

---

## 1. Product Summary

**Chessing** is an intelligent, offline-first mobile chess training and analysis platform built with Flutter. It combines grandmaster-level Stockfish engine play, rich opening theory libraries, interactive move review with evaluation graphs, and AI-driven coaching powered by Google Gemini.

**One-Line Pitch:** "Your personal Grandmaster in your pocket — engine mastery, personalized AI coaching, and deep game analysis."

---

## 2. Goals and Non-Goals

### Goals
1. **Complete Offline Gameplay:** Play against Stockfish bots across calibrated Elo levels (800 to 2800+) with custom time controls completely offline.
2. **Deep Post-Game Review:** Automatic post-game analysis generating move classification (Brilliant, Best, Excellent, Inaccuracy, Mistake, Blunder), centipawn advantage graphs, and critical blunder explanations.
3. **Interactive AI Coaching:** Gemini-powered interactive explanations for "Why is this move good/bad?", roleplaying historical Grandmasters (e.g. Magnus Carlsen, Garry Kasparov, Bobby Fischer), and opening guidance.
4. **Opening Theory Library:** Categorized openings (e.g., Ruy Lopez, Sicilian Defense, Queen's Gambit) with move trees, master game stats, and practice drills.
5. **Multi-Device Cloud Sync:** Sync profile ratings, match histories, and bookmark lists seamlessly with Supabase PostgreSQL while remaining fully playable offline.
6. **Privacy & Security by Design:** Zero hardcoded API keys; individual users manage their personal Gemini API key stored in hardware keystores (`flutter_secure_storage`). Strict Row Level Security on cloud databases.

### Non-Goals (v1)
- Real-time multiplayer matchmaking with WebSockets (planned for future phases; v1 focuses on bot play, analysis, and trainer modes).
- Desktop or web-specific production builds (Android-first with iOS support).
- Commercial subscriptions or paywalls in MVP.

---

## 3. Target User Persona

- **The Intermediate Improver (Elo 1000–1600):** Plays frequently online (Chess.com/Lichess) but plateaus because they don't understand *why* certain tactical moves are mistakes. Needs human-language AI coaching rather than raw engine numbers.
- **The Theory Enthusiast:** Wants to drill specific opening repertoires and review classic historical games move-by-move.
- **The Commuter / Offline Player:** Wants a reliable, fast chess companion that doesn't disconnect or drain battery when offline.

---

## 4. Scope by Release

| Release | Milestone Contents |
|---|---|
| **v0.1 (MVP Core)** | Bot Play against Stockfish, PGN recording, local Drift SQLite database, Board screen with move dots and threat overlays, Settings. |
| **v0.5 (Analysis & AI)** | Post-game review screen, win chance & evaluation charts (`fl_chart`), Gemini coach integration, Opening Theory Explorer, Grandmaster Roleplay modes. |
| **v1.0 (Cloud & Sync)** | Google Sign-In with Supabase Auth, bi-directional cloud sync, FCM daily reminders & notifications, Secure Storage for user credentials, GitHub Actions CI APK build. |
| **v1.5+ (Future)** | Live peer-to-peer multiplayer, custom puzzle generator, opening repertoire builder with spaced repetition. |

---

## 5. Core Features & Functional Requirements

Priority: **P0** (Critical), **P1** (High), **P2** (Enhancement).

### F-01 Game Play & Engine (P0)
- **Board UI:** Responsive 8x8 chessboard supporting piece tap-to-move, drag-and-drop, legal move highlights, check indicators, threat overlays, and customizable board/piece themes.
- **Engine Logic:** Embedded Stockfish UCI engine running on a background isolate. Difficulty levels ranging from Beginner (Elo 800) to Grandmaster (Elo 2800+).
- **Time Controls:** Bullet (1+0, 2+1), Blitz (3+0, 3+2, 5+0), Rapid (10+0, 15+10), and Classical (30+0), plus untimed casual mode.
- **Clocks & Adjudication:** Accurate countdown timers with increments, draw offer, resignation, 3-fold repetition, 50-move rule, and stalemate detection.

### F-02 Post-Game Analysis & Move Review (P0)
- **Centipawn Evaluation:** Full game scan with Stockfish depth analysis.
- **Move Classification:** Tags every move as Brilliant, Best, Excellent, Good, Inaccuracy, Mistake, or Blunder.
- **Evaluation Graph:** Interactive centipawn advantage curve (`fl_chart`) synced with the board state.
- **Best Move Alternative:** Visual arrows on the board showing the player's move vs. the engine's suggested best move.

### F-03 Gemini AI Coaching (P0)
- **On-Demand Explanation:** "Explain this move" button prompting Gemini to translate complex tactical lines into natural, plain English advice.
- **Persona Roleplay:** Conversational feedback in the voice of chess legends (Magnus, Kasparov, Tal, Fischer).
- **User-Owned API Keys:** Users enter their free Google Gemini API key in Settings; stored in Android Keystore / iOS Keychain.

### F-04 Theory & Opening Library (P1)
- **Repertoire Tree:** Comprehensive PGN opening library categorized by ECO code (Open Games, Semi-Open, Closed, Indian Defenses).
- **Interactive Training:** Step-by-step branch exploration with commentary on key opening ideas.
- **Bookmarks & Progress:** Save favorite variations and track mastery percentage.

### F-05 User Profile & Elo Tracking (P1)
- **Elo Ratings:** Dynamic Elo calculation across game categories (Bullet, Blitz, Rapid).
- **Match History:** Paginated match log with PGN export, win/loss stats, accuracy percentages, and opponent breakdowns.
- **Sync Status:** Visual indicator for cloud synchronization status.

### F-06 Authentication & Cloud Sync (P1)
- **Google Authentication:** Native Google Sign-In exchanging ID tokens with Supabase Auth.
- **Offline-First Synchronization:** All games and profile edits write immediately to local Drift SQLite, queuing pending sync rows to Supabase when online.
- **Row-Level Security:** Strict user data isolation enforced at the database policy layer.

### F-07 Settings & Customization (P1)
- **Visuals:** 4 board themes (Classic, Wood, Neon, Minimal) and piece sets with live board preview.
- **Gameplay Toggles:** Move confirmation, auto-queen promotion, legal move dots, threat overlays.
- **Haptics & Audio:** Move, capture, check, and clock warning sounds with volume slider and haptic feedback.
- **Notifications:** Daily puzzle/play reminder scheduling via FCM and local notifications.
