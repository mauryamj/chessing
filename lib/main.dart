import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'firebase_options.dart';
import 'core/supabase/supabase_client.dart';
import 'core/supabase/sync/sync_service.dart';
import 'core/firebase/fcm_service.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'features/settings/settings_provider.dart';

Future<void> _safeLoadDotenv() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Failed to load .env file: $e');
  }
}

Future<void> _safeInitFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize dotenv and Firebase concurrently to speed up startup
  await Future.wait([
    _safeLoadDotenv(),
    _safeInitFirebase(),
  ]);

  // 2. Supabase (depends on dotenv being loaded)
  try {
    await initSupabase();
  } catch (e) {
    debugPrint('Failed to initialize Supabase: $e');
  }

  // 3. Timezone database loading
  try {
    tz.initializeTimeZones();
  } catch (e) {
    debugPrint('Failed to initialize timezones: $e');
  }

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Initialize FCM and Sync on startup if user is logged in
      try {
        final user = supabase.auth.currentUser;
        if (user != null) {
          await FcmService().initialize();
          await ref.read(syncServiceProvider).retryPendingSync();
        }
      } catch (e) {
        debugPrint('Startup sync/FCM failed: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Chessing',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
