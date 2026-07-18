# ♟️ Chessing

A feature-rich Flutter chess app powered by Stockfish, Gemini AI coaching, and real-time cloud sync via Supabase & Firebase.

---

## ✨ Features

### 🎮 Play
- **vs Stockfish Engine** — Play against the world's strongest open-source chess engine
- **3 Game Modes** — Timed (with clock), Free (no time limit), and Level-based difficulty
- **10 Difficulty Levels** — Adjustable bot skill from beginner to master (mapped to Stockfish Skill Level 0–20)
- **Color Choice** — Play as White, Black, or Random
- **Graceful Fallback** — Uses the Bishop engine as a mock AI when Stockfish is unavailable

### 🤖 AI Coaching & Roleplay
- **Why This Move?** — Get Grandmaster-style reasoning for any board position via Gemini 2.5 Flash
- **GM Coach Persona** — Chat in real-time with an AI chess coach to review your games and ask strategic questions
- **Historical Matches** — Watch famous historical games with live move-by-move AI commentary

### 📊 Game Review
- **Post-Game Analysis** — Full Stockfish-powered position evaluation after each game
- **Best Move Cards** — See what the engine recommended vs what you played
- **Eval Bar** — Real-time position advantage visualization
- **Blunder Map** — Identify where the game turned
- **Move Timeline** — Step through every move of the game

### 📈 Match History & Performance
- **Match Log** — Chronological game history with results and summaries
- **Performance Screen** — Accuracy charts, rating trends, and W/D/L statistics
- **Rating Chart** — Visual ELO progression over time

### 📚 Opening Theory Library
- **Theory Browser** — Browse and study chess openings from a built-in library
- **Detail View** — Deep dive into variations and key positions for each opening

### 👤 Profile
- **User Profile** — View achievements, stats, and rating card
- **W/D/L Donut Chart** — Visual breakdown of your win/draw/loss record
- **Achievements Grid** — Unlock milestones as you play

### ⚙️ Settings
- **Dark / Light / System Theme** — Full theming support
- **Account Management** — Sign in with Google or continue as guest
- **Notifications** — Firebase Cloud Messaging (FCM) push notifications
- **Gameplay Preferences** — Customize coaching tips and board behavior

---

## 🏗️ Architecture

```
lib/
├── app/               # Router (go_router) & theme
├── core/
│   ├── ai/            # Gemini coaching service & AI prompts
│   ├── auth/          # Auth state & Riverpod provider
│   ├── cache/         # Offline-first repository pattern
│   ├── database/      # Local Drift (SQLite) DB, DAOs & tables
│   ├── engine/        # Stockfish service (with Bishop mock fallback)
│   ├── firebase/      # FCM push notification service
│   ├── pgn/           # PGN parser for historical match data
│   └── supabase/      # Supabase client, repositories & sync service
├── features/
│   ├── auth/          # Login & splash screens
│   ├── history/       # Match log & performance screens
│   ├── play/
│   │   ├── board/     # Interactive chess board & game state
│   │   ├── review/    # Post-game analysis & eval tools
│   │   └── setup/     # Game configuration screen
│   ├── profile/       # User profile & stats
│   ├── roleplay/      # AI coaching & historical match modes
│   ├── settings/      # App settings screens
│   └── theory/        # Opening theory library
└── shared/
    └── widgets/       # Shared UI components (bottom nav, etc.)
```

**State Management:** Riverpod (`flutter_riverpod` + `riverpod_annotation` with code generation)
**Navigation:** `go_router` with shell routes and slide-up transitions
**Local DB:** Drift (SQLite) with offline-first sync
**Backend:** Supabase (auth, database, realtime sync)
**Auth:** Firebase Auth + Google Sign-In
**Push Notifications:** Firebase Cloud Messaging

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x (Dart >= 3.3.0) |
| State Management | Riverpod 2.x |
| Navigation | go_router 13.x |
| Chess Engine | Stockfish (native) + Bishop (fallback) |
| AI Coaching | Google Gemini 2.5 Flash API |
| Local Database | Drift (SQLite) |
| Backend | Supabase |
| Auth | Firebase Auth + Google Sign-In |
| Push Notifications | Firebase Messaging |
| Charts | fl_chart |
| HTTP | Dio |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >= 3.3.0
- Dart >= 3.3.0
- A Firebase project with Android & iOS apps configured
- A Supabase project

### 1. Clone the repository

```bash
git clone https://github.com/your-username/chessing.git
cd chessing
```

### 2. Set up environment variables

Create a `.env` file in the project root (never commit this):

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
GOOGLE_WEB_CLIENT_ID=your-google-web-client-id.apps.googleusercontent.com
```

### 3. Add Firebase config files

Place your Firebase config files in the appropriate directories (never commit these):

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart` (generated via `flutterfire configure`)

### 4. Install dependencies

```bash
flutter pub get
```

### 5. Run code generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. Run the app

```bash
# With Gemini AI coaching enabled
flutter run --dart-define=GEMINI_API_KEY=your_gemini_api_key

# Without AI coaching (coaching features will show a graceful message)
flutter run
```

---

## 🔑 Environment & Secrets

This project uses multiple secret values. **None of these should ever be committed to version control.**

| Secret | Where | How |
|--------|-------|-----|
| `SUPABASE_URL` | `.env` file | Loaded via `flutter_dotenv` |
| `SUPABASE_ANON_KEY` | `.env` file | Loaded via `flutter_dotenv` |
| `GOOGLE_WEB_CLIENT_ID` | `.env` file | Loaded via `flutter_dotenv` |
| `GEMINI_API_KEY` | `--dart-define` flag | Compile-time constant |
| Firebase config | `google-services.json` / `GoogleService-Info.plist` / `firebase_options.dart` | Platform config files |

---

## 🧪 Running Tests

```bash
flutter test
```

Key test files:
- `test/bishop_test.dart` — Chess move generation tests
- `test/core/pgn/pgn_parser_test.dart` — PGN parsing tests
- `test/router_test.dart` — Navigation routing tests
- `test/timezone_test.dart` — Timezone initialization tests

---

## 📁 Project Notes

- **Offline-First:** All game data is stored locally in SQLite via Drift and synced to Supabase when online
- **Mock Engine Fallback:** If Stockfish fails to initialize on a platform, the app transparently falls back to the Bishop chess engine
- **Guest Mode:** Users can play without signing in; sign-in unlocks cloud sync and profile features

---

## 📄 License

This project is private and not licensed for public distribution.
