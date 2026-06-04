# Chess App – Phase 2 Implementation Plan
## Settings Screen · Supabase Backend · Firebase Google Auth · FCM

> Feed this file to your AI agent IDE after IMPLEMENTATION_PLAN.md is complete.
> Prerequisites: Phase 1–5 complete, local Drift DB working, profile screen exists.

---

## New Dependencies (`pubspec.yaml` additions)

```yaml
dependencies:
  # Supabase
  supabase_flutter: ^2.5.0

  # Firebase
  firebase_core: ^3.3.0
  firebase_auth: ^5.1.0
  google_sign_in: ^6.2.0
  firebase_messaging: ^15.0.0
  flutter_local_notifications: ^17.0.0

  # Settings UI
  flutter_settings_ui: ^2.0.0    # optional — or build custom
  image_picker: ^1.1.0           # avatar upload
  cached_network_image: ^3.3.0   # remote avatar display

  # Utilities
  flutter_dotenv: ^5.1.0         # .env file support
  connectivity_plus: ^6.0.0      # already added in phase 1
```

---

## Environment Variables (`.env`)

```
# Root of project — add to .gitignore immediately
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

Access in code:
```dart
// main.dart — load before runApp
await dotenv.load(fileName: '.env');
final supabaseUrl = dotenv.env['SUPABASE_URL']!;
final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;
```

Add to `.gitignore`:
```
.env
google-services.json
GoogleService-Info.plist
```

---

## New Folder Structure (additions only)

```
lib/
├── core/
│   ├── supabase/
│   │   ├── supabase_client.dart         # singleton client
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── profile_repository.dart
│   │   │   ├── games_repository.dart
│   │   │   └── notifications_repository.dart
│   │   └── sync/
│   │       └── sync_service.dart        # local Drift ↔ Supabase
│   ├── firebase/
│   │   ├── fcm_service.dart
│   │   └── fcm_models.dart
│   └── auth/
│       ├── auth_state.dart
│       └── auth_provider.dart
├── features/
│   ├── auth/
│   │   ├── splash_screen.dart           # decides route on app start
│   │   ├── login_screen.dart
│   │   └── widgets/
│   │       └── google_sign_in_button.dart
│   └── settings/
│       ├── settings_screen.dart
│       ├── settings_provider.dart
│       └── sections/
│           ├── account_section.dart
│           ├── appearance_section.dart
│           ├── gameplay_section.dart
│           ├── notifications_section.dart
│           └── about_section.dart
```

---

## Part A – Settings Screen

### A.1 Settings provider

- [ ] Create `features/settings/settings_provider.dart`

```dart
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Settings build() => _loadFromPrefs();

  // Appearance
  Future<void> setThemeMode(ThemeMode mode);
  Future<void> setBoardTheme(BoardTheme theme);
  Future<void> setPieceSet(PieceSet set);

  // Gameplay
  Future<void> setShowLegalMoves(bool value);
  Future<void> setShowThreatOverlay(bool value);
  Future<void> setAutoQueenPromotion(bool value);
  Future<void> setMoveConfirmation(bool value);

  // Sound & haptics
  Future<void> setSoundEnabled(bool value);
  Future<void> setHapticsEnabled(bool value);
  Future<void> setMoveSoundVolume(double value);   // 0.0–1.0

  // Notifications
  Future<void> setDailyReminderEnabled(bool value);
  Future<void> setDailyReminderTime(TimeOfDay time);
  Future<void> setAchievementNotifications(bool value);
}

class Settings {
  final ThemeMode themeMode;           // system | light | dark
  final BoardTheme boardTheme;         // classic | wood | neon | minimal
  final PieceSet pieceSet;             // standard | neo | alpha
  final bool showLegalMoves;
  final bool showThreatOverlay;
  final bool autoQueenPromotion;
  final bool moveConfirmation;
  final bool soundEnabled;
  final bool hapticsEnabled;
  final double moveSoundVolume;
  final bool dailyReminderEnabled;
  final TimeOfDay dailyReminderTime;
  final bool achievementNotifications;
}
```

- [ ] Persist each setting via `shared_preferences`
- [ ] Expose `settingsProvider` as a `Provider<Settings>` for read-only consumption

### A.2 Settings screen shell

- [ ] Create `features/settings/settings_screen.dart`
  - `Scaffold` with `CustomScrollView` + `SliverAppBar` (pinned)
  - Sections as `SliverList` groups with section headers
  - Pull-to-refresh syncs profile from Supabase

### A.3 Account section

- [ ] Create `features/settings/sections/account_section.dart`
  - Avatar: `CircleAvatar` with `CachedNetworkImage` (remote) or `FileImage` (local)
  - Tap avatar → `ImagePicker.pickImage(source: ImageSource.gallery)` → upload to Supabase Storage → update profile
  - Username: `ListTile` with edit icon → inline `TextField` dialog
  - Email: read-only display (from Firebase Auth user)
  - "Sign out" tile → calls `AuthRepository.signOut()` → navigate to `/login`
  - "Delete account" tile (danger zone, red text) → confirm dialog → `AuthRepository.deleteAccount()`

### A.4 Appearance section

- [ ] Create `features/settings/sections/appearance_section.dart`
  - Theme toggle: segmented button (System / Light / Dark)
  - Board theme: horizontal scrollable preview cards (4 themes)
  - Piece set: horizontal scrollable piece previews (3 sets)
  - Each tap → calls `SettingsNotifier.setBoardTheme()` / `setPieceSet()`

### A.5 Gameplay section

- [ ] Create `features/settings/sections/gameplay_section.dart`
  - `SwitchListTile`: Show legal move dots
  - `SwitchListTile`: Show threat overlay by default
  - `SwitchListTile`: Auto-promote to queen
  - `SwitchListTile`: Require move confirmation (tap piece → tap target → confirm)

### A.6 Sound & haptics section (inside appearance section or separate)

- [ ] `SwitchListTile`: Sound on/off
- [ ] `Slider`: Volume (visible only when sound enabled)
- [ ] `SwitchListTile`: Haptic feedback

### A.7 Notifications section

- [ ] Create `features/settings/sections/notifications_section.dart`
  - `SwitchListTile`: Daily practice reminder
  - `ListTile` (visible only when reminder on): reminder time → `showTimePicker`
  - `SwitchListTile`: Achievement unlocked notifications
  - `SwitchListTile`: Weekly performance summary

### A.8 About section

- [ ] Create `features/settings/sections/about_section.dart`
  - App version (from `package_info_plus`)
  - Privacy policy link (`url_launcher`)
  - Terms of service link
  - Rate the app (store link)
  - "Send feedback" → email intent

---

## Part B – Supabase Backend

### B.1 Supabase project setup (do in Supabase dashboard)

- [ ] Create new Supabase project
- [ ] Note `Project URL` and `anon public` key → add to `.env`
- [ ] In Supabase dashboard → Authentication → Providers → enable **Google**
  - Add Web client ID from Firebase (see Part C)
  - Add authorized redirect URL: `io.supabase.yourapp://login-callback/`
- [ ] In Storage → create bucket `avatars` (public read, authenticated write)

### B.2 Supabase database schema (run in SQL Editor)

```sql
-- profiles table (mirrors local Profile table, source of truth in cloud)
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  username text not null default 'Player',
  avatar_url text,
  current_rating integer not null default 800,
  peak_rating integer not null default 800,
  games_played integer not null default 0,
  wins integer not null default 0,
  draws integer not null default 0,
  losses integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- games table
create table public.games (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade not null,
  pgn text not null,
  result text not null,          -- '1-0' | '0-1' | '1/2-1/2'
  mode text not null,            -- 'timed' | 'free' | 'level'
  bot_level integer,
  time_control_seconds integer,
  player_accuracy integer,
  played_at timestamptz not null default now()
);

-- moves table
create table public.moves (
  id uuid primary key default gen_random_uuid(),
  game_id uuid references public.games on delete cascade not null,
  ply integer not null,
  uci text not null,
  san text not null,
  eval_centipawns integer,
  classification text             -- 'best'|'good'|'inaccuracy'|'mistake'|'blunder'
);

-- fcm tokens table
create table public.fcm_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade not null,
  token text not null unique,
  platform text not null,        -- 'android' | 'ios'
  created_at timestamptz not null default now()
);

-- Enable Row Level Security
alter table public.profiles enable row level security;
alter table public.games enable row level security;
alter table public.moves enable row level security;
alter table public.fcm_tokens enable row level security;

-- RLS policies — users can only access their own data
create policy "Users manage own profile"
  on public.profiles for all using (auth.uid() = id);

create policy "Users manage own games"
  on public.games for all using (auth.uid() = user_id);

create policy "Users manage own moves"
  on public.moves for all
  using (game_id in (select id from public.games where user_id = auth.uid()));

create policy "Users manage own fcm tokens"
  on public.fcm_tokens for all using (auth.uid() = user_id);

-- Auto-create profile row when user signs up
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, username, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'name', 'Player'),
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- updated_at auto-update
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger profiles_updated_at
  before update on public.profiles
  for each row execute procedure public.handle_updated_at();
```

### B.3 Supabase client singleton

- [ ] Create `core/supabase/supabase_client.dart`

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
}

// Convenience getter used everywhere
SupabaseClient get supabase => Supabase.instance.client;
```

- [ ] Call `initSupabase()` in `main()` before `runApp()`

### B.4 Auth repository

- [ ] Create `core/supabase/repositories/auth_repository.dart`

```dart
class AuthRepository {
  // Called after Firebase Google Sign-In succeeds — see Part C
  Future<void> signInWithIdToken({
    required String idToken,
    required String accessToken,
  }) async {
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> deleteAccount() async {
    // Call a Supabase Edge Function that deletes auth.users row
    await supabase.functions.invoke('delete-account');
  }

  User? get currentUser => supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges =>
      supabase.auth.onAuthStateChange;
}
```

### B.5 Profile repository

- [ ] Create `core/supabase/repositories/profile_repository.dart`

```dart
class ProfileRepository {
  Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    final res = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    return res;
  }

  Future<void> updateProfile({
    required String userId,
    String? username,
    String? avatarUrl,
  }) async {
    await supabase.from('profiles').update({
      if (username != null) 'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    }).eq('id', userId);
  }

  Future<void> updateStats({
    required String userId,
    required int currentRating,
    required int peakRating,
    required int gamesPlayed,
    required int wins,
    required int draws,
    required int losses,
  }) async {
    await supabase.from('profiles').update({
      'current_rating': currentRating,
      'peak_rating': peakRating,
      'games_played': gamesPlayed,
      'wins': wins,
      'draws': draws,
      'losses': losses,
    }).eq('id', userId);
  }

  Future<String> uploadAvatar(String userId, File imageFile) async {
    final path = '$userId/avatar.jpg';
    await supabase.storage.from('avatars').upload(
      path,
      imageFile,
      fileOptions: const FileOptions(upsert: true),
    );
    return supabase.storage.from('avatars').getPublicUrl(path);
  }
}
```

### B.6 Games repository

- [ ] Create `core/supabase/repositories/games_repository.dart`

```dart
class GamesRepository {
  Future<void> uploadGame(GameModel game) async {
    final gameRow = await supabase.from('games').insert({
      'user_id': supabase.auth.currentUser!.id,
      'pgn': game.pgn,
      'result': game.result,
      'mode': game.mode,
      'bot_level': game.botLevel,
      'time_control_seconds': game.timeControlSeconds,
      'player_accuracy': game.playerAccuracy,
      'played_at': game.playedAt.toIso8601String(),
    }).select().single();

    // Upload moves
    if (game.moves.isNotEmpty) {
      await supabase.from('moves').insert(
        game.moves.map((m) => {
          'game_id': gameRow['id'],
          'ply': m.ply,
          'uci': m.uci,
          'san': m.san,
          'eval_centipawns': m.evalCentipawns,
          'classification': m.classification,
        }).toList(),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchGames({int limit = 20, int offset = 0}) async {
    return await supabase
        .from('games')
        .select('*, moves(*)')
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('played_at', ascending: false)
        .range(offset, offset + limit - 1);
  }
}
```

### B.7 Sync service (local Drift ↔ Supabase)

- [ ] Create `core/supabase/sync/sync_service.dart`

```dart
// Strategy: local Drift is the write-first store.
// SyncService pushes completed games to Supabase in the background.
// On login, it pulls remote data to hydrate local DB.

class SyncService {
  final GamesDao _gamesDao;
  final ProfileDao _profileDao;
  final GamesRepository _gamesRepo;
  final ProfileRepository _profileRepo;

  // Called after login — pull cloud → local
  Future<void> pullFromCloud() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    // Sync profile
    final remoteProfile = await _profileRepo.fetchProfile(userId);
    if (remoteProfile != null) {
      await _profileDao.upsertFromRemote(remoteProfile);
    }

    // Sync last 50 games (avoid full download on every login)
    final remoteGames = await _gamesRepo.fetchGames(limit: 50);
    for (final g in remoteGames) {
      await _gamesDao.upsertFromRemote(g);
    }
  }

  // Called after each game ends — push local → cloud
  Future<void> pushGame(int localGameId) async {
    if (supabase.auth.currentUser == null) return; // offline, skip
    final game = await _gamesDao.getGameById(localGameId);
    if (game == null) return;
    try {
      await _gamesRepo.uploadGame(game);
    } catch (e) {
      // Store failed uploads in a pending_sync table, retry on next launch
      await _gamesDao.markPendingSync(localGameId);
    }
  }

  // Called on app start — retry any previously failed uploads
  Future<void> retryPendingSync() async {
    final pending = await _gamesDao.getPendingSync();
    for (final game in pending) {
      await pushGame(game.id);
    }
  }
}
```

- [ ] Add `pending_sync` boolean column to local `games` table in Drift
- [ ] Call `SyncService.retryPendingSync()` on app start if user is logged in

---

## Part C – Firebase Google Auth → Supabase

### C.1 Firebase project setup (Firebase Console)

- [ ] Create new Firebase project (or use existing)
- [ ] Add Android app:
  - Package name: your app's `applicationId` from `build.gradle`
  - Download `google-services.json` → place in `android/app/`
- [ ] Add iOS app:
  - Bundle ID: from `ios/Runner.xcodeproj`
  - Download `GoogleService-Info.plist` → place in `ios/Runner/`
- [ ] Enable **Google** as sign-in provider in Firebase Console → Authentication → Sign-in method
- [ ] Copy the **Web client ID** (OAuth 2.0 client) from Google Cloud Console → APIs & Services → Credentials
  - This is needed for both Android and the Supabase Google provider config

### C.2 Android configuration

- [ ] `android/build.gradle` — add Google services plugin to classpath:
  ```groovy
  dependencies {
    classpath 'com.google.gms:google-services:4.4.2'
  }
  ```
- [ ] `android/app/build.gradle` — apply plugin at bottom:
  ```groovy
  apply plugin: 'com.google.gms.google-services'
  ```
- [ ] Add SHA-1 and SHA-256 fingerprints to Firebase project (required for Google Sign-In):
  ```bash
  cd android && ./gradlew signingReport
  ```
  Copy debug fingerprints → Firebase Console → Project settings → Android app → Add fingerprint

### C.3 iOS configuration

- [ ] Open `ios/Runner.xcworkspace` in Xcode
- [ ] Drag `GoogleService-Info.plist` into Runner target (copy if needed)
- [ ] `ios/Runner/Info.plist` — add URL scheme for Google Sign-In:
  ```xml
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleURLSchemes</key>
      <array>
        <!-- REVERSED_CLIENT_ID from GoogleService-Info.plist -->
        <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
      </array>
    </dict>
  </array>
  ```

### C.4 Initialize Firebase in Flutter

- [ ] Update `main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // generated by FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initSupabase();
  runApp(const ProviderScope(child: ChessApp()));
}
```

- [ ] Run FlutterFire CLI to generate `firebase_options.dart`:
  ```bash
  dart pub global activate flutterfire_cli
  flutterfire configure
  ```

### C.5 Auth provider (Riverpod)

- [ ] Create `core/auth/auth_provider.dart`

```dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthStateModel build() {
    // Listen to Supabase auth state changes
    supabase.auth.onAuthStateChange.listen((data) {
      state = data.session != null
          ? AuthStateModel.authenticated(data.session!.user)
          : const AuthStateModel.unauthenticated();
    });
    final user = supabase.auth.currentUser;
    return user != null
        ? AuthStateModel.authenticated(user)
        : const AuthStateModel.unauthenticated();
  }

  Future<void> signInWithGoogle() async {
    state = const AuthStateModel.loading();
    try {
      // Step 1: Google Sign-In via Firebase
      final googleUser = await GoogleSignIn(
        clientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
      ).signIn();
      if (googleUser == null) {
        state = const AuthStateModel.unauthenticated();
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken!;
      final accessToken = googleAuth.accessToken!;

      // Step 2: Pass tokens to Supabase
      await AuthRepository().signInWithIdToken(
        idToken: idToken,
        accessToken: accessToken,
      );

      // Step 3: Sync cloud data to local DB
      await SyncService().pullFromCloud();

      state = AuthStateModel.authenticated(supabase.auth.currentUser!);
    } catch (e) {
      state = AuthStateModel.error(e.toString());
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await AuthRepository().signOut();
    state = const AuthStateModel.unauthenticated();
  }
}

// Sealed class for auth state
sealed class AuthStateModel {
  const AuthStateModel();
  const factory AuthStateModel.unauthenticated() = _Unauthenticated;
  const factory AuthStateModel.loading() = _Loading;
  const factory AuthStateModel.authenticated(User user) = _Authenticated;
  const factory AuthStateModel.error(String message) = _Error;
}
```

### C.6 Login screen

- [ ] Create `features/auth/login_screen.dart`
  - App logo / chess illustration at top
  - "Continue with Google" button (`GoogleSignInButton` widget)
  - "Play as Guest" text button → navigates to `/setup` without auth (local-only mode)
  - Watches `authNotifierProvider` — if `_Authenticated`, auto-navigate to `/`
  - Show `CircularProgressIndicator` during `_Loading` state
  - Show `SnackBar` on `_Error`

- [ ] Create `features/auth/widgets/google_sign_in_button.dart`
  - White elevated button with Google logo SVG + "Continue with Google" text
  - `onPressed`: calls `ref.read(authNotifierProvider.notifier).signInWithGoogle()`

### C.7 Splash screen (auth router)

- [ ] Create `features/auth/splash_screen.dart`
  - Shown on cold start while checking auth state
  - If `supabase.auth.currentUser != null` → go to `/`
  - If null → go to `/login`
  - Shows logo + `CircularProgressIndicator`

- [ ] Update `app/router.dart` — add redirect logic:

```dart
redirect: (context, state) {
  final isLoggedIn = supabase.auth.currentUser != null;
  final isLoggingIn = state.matchedLocation == '/login';
  if (!isLoggedIn && !isLoggingIn) return '/login';
  if (isLoggedIn && isLoggingIn) return '/';
  return null;
},
```

---

## Part D – Firebase Cloud Messaging (FCM)

### D.1 Android FCM setup

- [ ] `android/app/build.gradle` — ensure `minSdkVersion` is 21+
- [ ] Add notification icon to `android/app/src/main/res/drawable/`
  - Name it `ic_notification.png` — chess piece or app logo, white on transparent
- [ ] `android/app/src/main/AndroidManifest.xml` — add inside `<application>`:
  ```xml
  <meta-data
    android:name="com.google.firebase.messaging.default_notification_icon"
    android:resource="@drawable/ic_notification" />
  <meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="chess_notifications" />
  ```

### D.2 iOS FCM setup

- [ ] In Xcode → Runner → Signing & Capabilities → "+ Capability" → add **Push Notifications**
- [ ] Add **Background Modes** capability → check "Remote notifications"
- [ ] Upload APNs Auth Key to Firebase Console → Project Settings → Cloud Messaging → iOS app

### D.3 FCM service

- [ ] Create `core/firebase/fcm_service.dart`

```dart
class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission (iOS + Android 13+)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    // Create Android notification channel
    const channel = AndroidNotificationChannel(
      'chess_notifications',
      'Chess Notifications',
      description: 'Daily reminders and achievement alerts',
      importance: Importance.high,
    );
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Get token and save to Supabase
    final token = await _messaging.getToken();
    if (token != null) await _saveToken(token);

    // Refresh token listener
    _messaging.onTokenRefresh.listen(_saveToken);

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background/terminated tap handler
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from a terminated state via notification
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _handleNotificationTap(initial);
  }

  Future<void> _saveToken(String token) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    await supabase.from('fcm_tokens').upsert({
      'user_id': userId,
      'token': token,
      'platform': Platform.isAndroid ? 'android' : 'ios',
    }, onConflict: 'token');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification when app is in foreground
    final notification = message.notification;
    if (notification == null) return;
    FlutterLocalNotificationsPlugin().show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'chess_notifications',
          'Chess Notifications',
          icon: '@drawable/ic_notification',
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Navigate based on notification type
    final type = message.data['type'];
    if (type == 'achievement') {
      // router.go('/profile');
    } else if (type == 'daily_reminder') {
      // router.go('/setup');
    }
  }

  // Call on sign-out to avoid sending notifications to old sessions
  Future<void> deleteToken() async {
    final token = await _messaging.getToken();
    if (token != null) {
      await supabase.from('fcm_tokens').delete().eq('token', token);
    }
    await _messaging.deleteToken();
  }
}
```

### D.4 Local notification scheduling (daily reminder)

- [ ] In `FcmService`, add:

```dart
Future<void> scheduleDailyReminder(TimeOfDay time) async {
  await FlutterLocalNotificationsPlugin().zonedSchedule(
    0,
    'Time to practice!',
    'A daily game keeps your rating climbing ♟️',
    _nextInstanceOfTime(time),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'chess_notifications',
        'Chess Notifications',
        icon: '@drawable/ic_notification',
      ),
    ),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time, // repeat daily
  );
}

Future<void> cancelDailyReminder() async {
  await FlutterLocalNotificationsPlugin().cancel(0);
}

tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
  final now = tz.TZDateTime.now(tz.local);
  var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
  if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 1));
  return scheduled;
}
```

- [ ] Add `timezone` package to pubspec and init in `main()`:
  ```dart
  import 'package:timezone/data/latest_all.dart' as tz;
  tz.initializeTimeZones();
  ```

### D.5 Wire reminder setting to FCM

- [ ] In `SettingsNotifier.setDailyReminderEnabled`:
  ```dart
  if (value) {
    await FcmService().scheduleDailyReminder(state.dailyReminderTime);
  } else {
    await FcmService().cancelDailyReminder();
  }
  ```
- [ ] In `SettingsNotifier.setDailyReminderTime`:
  ```dart
  await FcmService().scheduleDailyReminder(time); // reschedule with new time
  ```

### D.6 Initialize FCM after login

- [ ] In `AuthNotifier.signInWithGoogle()`, after sync completes:
  ```dart
  await FcmService().initialize();
  ```
- [ ] In `AuthNotifier.signOut()`, before clearing state:
  ```dart
  await FcmService().deleteToken();
  ```

---

## Part E – Wire Everything Together

### E.1 Updated `main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load env
  await dotenv.load(fileName: '.env');

  // 2. Firebase (must be before Supabase)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Supabase
  await initSupabase();

  // 4. Timezone (for scheduled notifications)
  tz.initializeTimeZones();

  // 5. If already logged in, initialize FCM and sync
  if (supabase.auth.currentUser != null) {
    await FcmService().initialize();
    await SyncService().retryPendingSync();
  }

  runApp(const ProviderScope(child: ChessApp()));
}
```

### E.2 Profile screen updates

- [ ] Source profile data from `ProfileRepository` (Supabase) not just local Drift
- [ ] Show network avatar via `CachedNetworkImage(url: profile.avatarUrl)`
- [ ] "Signed in as" subtitle below username using `supabase.auth.currentUser?.email`
- [ ] Tap "Sign out" in account section → `AuthNotifier.signOut()` → router redirects to `/login`

### E.3 Game end flow update

```
Game ends
  → save to local Drift DB (always)
  → RatingService.calculate() → update local profile
  → if logged in: SyncService.pushGame(localGameId)  ← new
                  ProfileRepository.updateStats(...)  ← new
  → navigate to /review/:gameId
```

### E.4 Guest mode handling

- [ ] All game features work without login (Drift local only)
- [ ] Profile screen shows "Sign in to back up your progress" banner when guest
- [ ] Settings → Account section shows "Sign in with Google" when guest
- [ ] On sign-in: `SyncService.pullFromCloud()` merges cloud data
  - If cloud has no games: upload all local games
  - If cloud has games: prefer cloud data (user played on another device)

---

## Testing Checklist

### Auth flow
- [ ] Cold start logged out → `/login` shown
- [ ] Google Sign-In success → splash resolves to `/`
- [ ] Cold start logged in → splash resolves to `/` without login screen
- [ ] Sign out → all local session cleared → `/login`
- [ ] Token refresh works (revoke token in Firebase Console, reopen app)

### Supabase sync
- [ ] Play a game offline → complete → marked as pending sync
- [ ] Go online → pending game uploads automatically
- [ ] Profile stats match between local DB and Supabase dashboard
- [ ] RLS: cannot read another user's games (test via Supabase SQL editor with different `auth.uid()`)

### FCM
- [ ] Token saved to `fcm_tokens` table after login
- [ ] Foreground notification appears as local notification overlay
- [ ] Background tap navigates to correct screen
- [ ] Daily reminder appears at scheduled time
- [ ] Token deleted from DB on sign-out
- [ ] No duplicate tokens after token refresh

### Settings
- [ ] Theme change applies immediately app-wide
- [ ] Board theme change reflects in next game
- [ ] Sound toggle persists across app restarts
- [ ] Avatar upload appears in profile and syncs to Supabase Storage
- [ ] Username edit updates local + Supabase simultaneously

---

## Notes for AI Agent

- Implement parts in order: **A (Settings) → B (Supabase schema + repos) → C (Auth) → D (FCM) → E (wiring)**
- Never store the Supabase anon key or Firebase config in source code — always use `.env` / `--dart-define`
- The Google Sign-In flow is **two steps**: Firebase Auth first, then pass `idToken` + `accessToken` to Supabase. Do not skip either step.
- All Supabase calls must be wrapped in try/catch — network can fail silently on mobile
- Drift `upsertFromRemote` methods need to handle UUID (Supabase) ↔ int (local) ID mismatch — store `remote_id` as a nullable text column in local tables
- `FcmService.initialize()` must only be called after the user is authenticated — calling it as a guest will fail silently and waste the token
- FCM token can be null on emulators — guard every `token != null` check
- For the Supabase `delete-account` Edge Function: create it in `supabase/functions/delete-account/index.ts` using the service-role key (never expose service-role key to the client)
